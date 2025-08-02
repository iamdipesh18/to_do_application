import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';

void showTaskBottomSheet({
  required BuildContext context,
  Task? task,
  required void Function(Task task) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return _TaskBottomSheetContent(task: task, onSave: onSave);
    },
  );
}

class _TaskBottomSheetContent extends StatefulWidget {
  final Task? task;
  final void Function(Task task) onSave;

  const _TaskBottomSheetContent({required this.task, required this.onSave});

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
    _dueDate = task?.dueDate ?? DateTime.now();
    _priority = task?.priority ?? Priority.medium;
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
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
                // Title
                Text(
                  isEditing ? 'Edit Task' : 'New Task',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Title Field
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _title = value!.trim(),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Title required'
                      : null,
                ),
                const SizedBox(height: 14),

                // Description Field
                TextFormField(
                  initialValue: _description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 14),

                // Due Date Picker
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Due: ${_dueDate.toLocal().toString().split(' ')[0]}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDueDate,
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Priority Dropdown
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Priority>(
                      value: _priority,
                      isExpanded: true,
                      items: Priority.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.label),
                        );
                      }).toList(),
                      onChanged: (p) {
                        if (p != null) {
                          setState(() {
                            _priority = p;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Aligns to the right
                  children: [
                    ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.task == null ? 'Add Task' : 'Update Task',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
