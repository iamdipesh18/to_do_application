import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';

/// Shows a modal bottom sheet with a sleek task form.
/// Supports creating a new task or editing an existing one.
/// The [onSave] callback returns the created/updated Task.
void showTaskBottomSheet({
  required BuildContext context,
  Task? task,
  required void Function(Task task) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // To allow form to go above keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _TaskBottomSheetContent(task: task, onSave: onSave),
  );
}

class _TaskBottomSheetContent extends StatefulWidget {
  final Task? task;
  final void Function(Task task) onSave;

  const _TaskBottomSheetContent({
    required this.task,
    required this.onSave,
  });

  @override
  State<_TaskBottomSheetContent> createState() =>
      _TaskBottomSheetContentState();
}

class _TaskBottomSheetContentState extends State<_TaskBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late DateTime _dueDate;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = task?.priority ?? Priority.medium;
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final updatedTask = Task(
        id: widget.task?.id ?? UniqueKey().toString(),
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      widget.onSave(updatedTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomInset,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Wrap(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Text(
                  isEditing ? 'Edit Task' : 'New Task',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),

                // Title input field
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Title required'
                      : null,
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 18),

                // Description input field
                TextFormField(
                  initialValue: _description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onSaved: (value) => _description = value?.trim() ?? '',
                ),
                const SizedBox(height: 18),

                // Due date selector row
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDueDate,
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Priority dropdown inside input decorator for border
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Priority>(
                      value: _priority,
                      isExpanded: true,
                      items: Priority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        );
                      }).toList(),
                      onChanged: (priority) {
                        if (priority != null) {
                          setState(() {
                            _priority = priority;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Save button aligned to the right
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update Task' : 'Add Task',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
