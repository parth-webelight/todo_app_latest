import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todo/model/todo_model.dart';
import 'package:todo_app/features/widgets/custom_button.dart';

class TodoListItem extends StatelessWidget {
  final TodoModel todo;
  final String formattedDate;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.formattedDate,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onEdit,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: todo.isCompleted,
                activeColor: Colors.indigo,
                onChanged: (value) {
                  onToggle();
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: todo.isCompleted
                            ? Colors.grey
                            : Colors.indigo.shade500,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (todo.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        todo.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.indigo.shade300,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.indigo.shade300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Delete Todo",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to delete this todo?",
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        CustomButton(
                          onPress: () => Navigator.pop(context),
                          title: "Cancel",
                          isBackgroundColor: false,
                        ),
                        CustomButton(
                          onPress: () {
                            Navigator.pop(context);
                            onDelete();
                          },
                          title: "Delete",
                          isBackgroundColor: true,
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent.shade200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
