import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todo/model/todo_model.dart';
import 'package:todo_app/features/todo/providers/todo_provider.dart';
import 'package:todo_app/features/widgets/custom_button.dart';

class EditTodoDialog extends ConsumerStatefulWidget {
  final TodoModel todo;

  const EditTodoDialog({
    super.key,
    required this.todo,
  });

  @override
  ConsumerState<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends ConsumerState<EditTodoDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(text: widget.todo.description);
    selectedDate = widget.todo.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.indigo),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Edit Todo",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              labelText: "Title",
              hintText: "Enter todo title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            cursorColor: Colors.indigo,
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Enter todo description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Select Date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                selectedDate == null
                    ? "Select due date"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: selectedDate == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          onPress: () => Navigator.pop(context),
          title: "Cancel",
          isBackgroundColor: false,
        ),
        CustomButton(
          onPress: () {
            if (titleController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Title is required",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            if (descriptionController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Description is required",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            if (selectedDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Date is required",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            ref.read(todoProvider.notifier).updateToDo(
                  widget.todo.id,
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                  widget.todo.isCompleted,
                  dueDate: selectedDate,
                );
            Navigator.pop(context, true);
          },
          title: "Save",
          isBackgroundColor: true,
        ),
      ],
    );
  }
}