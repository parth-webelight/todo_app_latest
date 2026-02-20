import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todo/providers/todo_provider.dart';
import 'package:todo_app/features/widgets/custom_button.dart';

class AddTodoDialog extends ConsumerStatefulWidget {
  const AddTodoDialog({super.key});

  @override
  ConsumerState<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;

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
        "Add New Todo",
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
                    ? "Select date"
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
                    "Due date is required",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            ref.read(todoProvider.notifier).addToDo(
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                  dueDate: selectedDate,
                );
            Navigator.pop(context, true);
          },
          title: "Add",
          isBackgroundColor: true,
        ),
      ],
    );
  }
}