import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_text_field.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDate = widget.task?.date ?? DateTime.now();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    try {
      if (widget.task == null) {
        await taskProvider.addTask(_titleController.text, _descriptionController.text, _selectedDate);
      } else {
        await taskProvider.updateTask(widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          date: _selectedDate,
        ));
      }

      if (taskProvider.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(taskProvider.error!), backgroundColor: Colors.red),
          );
        }
      } else {
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "Add Task" : "Edit Task")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: "Title",
                validator: (v) => v!.isEmpty ? "Title is required" : null,
              ),
              CustomTextField(
                controller: _descriptionController,
                label: "Description",
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Date"),
                subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_month),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 32),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, _) {
                  return ElevatedButton(
                    onPressed: taskProvider.isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: taskProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(widget.task == null ? "Create Task" : "Update Task"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
