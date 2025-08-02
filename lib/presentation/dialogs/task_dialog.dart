import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';

// This widget shows a dialog to add a new task or edit an existing one.
// If `task` is null, it means we are adding a new task.
// If `task` is non-null, it means we are editing that task.
class TaskDialog extends StatefulWidget {
  final Task? task; // The task to edit, or null to create a new one.
  final Function(Task) onSave; // Callback when user saves the task.

  const TaskDialog({super.key, this.task, required this.onSave});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state.

  // Fields to hold input values.
  late String _title;
  late String _description;
  late Priority _priority;
  late DateTime _dueDate;

  // Initialize fields either with the task data (if editing) or default values.
  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _priority = task?.priority ?? Priority.medium;
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  // Show a date picker dialog to select due date.
  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked; // Update the selected date.
      });
    }
  }

  // Called when user taps Save/Add button.
  void _submit() {
    // Validate all inputs in the form.
    if (_formKey.currentState!.validate()) {
      // Save all form fields to their variables.
      _formKey.currentState!.save();

      // Create a new Task object:
      // If editing, copy the old task and update fields.
      // If adding, create a new Task with a new unique ID.
      final task = widget.task == null
          ? Task(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: _title,
              description: _description,
              dueDate: _dueDate,
              priority: _priority,
              isCompleted: false,
            )
          : widget.task!.copyWith(
              title: _title,
              description: _description,
              dueDate: _dueDate,
              priority: _priority,
            );

      widget.onSave(task); // Call the callback with the new/updated task.
      Navigator.of(context).pop(); // Close the dialog.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Title changes depending on adding or editing.
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: _formKey, // Attach form key to validate/save inputs.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text field for task title.
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(),
                  ),
                  // Title is required.
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Title required'
                      : null,
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 12),

                // Text field for task description.
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _description = value ?? '',
                ),
                const SizedBox(height: 12),

                // Dropdown to select priority.
                Row(
                  children: [
                    const Text('Priority:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    DropdownButton<Priority>(
                      value: _priority,
                      items: Priority.values
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.label),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _priority = value!),
                      underline: Container(height: 1, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Due date display and picker button.
                Row(
                  children: [
                    const Text('Due Date:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    Text(
                      '${_dueDate.toLocal()}'.split(' ')[0], // Show date only
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDueDate, // Open date picker
                      tooltip: 'Select due date',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Buttons at bottom: Cancel and Add/Save
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit, // Validate and save task
          child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
