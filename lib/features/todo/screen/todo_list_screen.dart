// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todo/dialogs/add_todo_dialog.dart';
import 'package:todo_app/features/todo/dialogs/edit_todo_dialog.dart';
import 'package:todo_app/features/todo/dialogs/error_dialog.dart';
import 'package:todo_app/features/todo/dialogs/filter_dialog.dart';
import 'package:todo_app/features/todo/dialogs/speech_dialog.dart';
import 'package:todo_app/features/todo/providers/todo_provider.dart';
import 'package:todo_app/features/widgets/todo_list_item.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todoDate = DateTime(date.year, date.month, date.day);

    int hour12 = date.hour % 12;
    if (hour12 == 0) hour12 = 12;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = date.minute.toString().padLeft(2, '0');

    if (todoDate == today) {
      return "Today, $hour12:$minuteStr $amPm";
    } else if (todoDate == today.subtract(const Duration(days: 1))) {
      return "Yesterday, $hour12:$minuteStr $amPm";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final todos = ref.watch(filteredTodosProvider);
        final pendingCount = ref.watch(pendingCountProvider);
        final filterState = ref.watch(filterProvider);
        final hasActiveFilters = filterState.hasActiveFilters;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text(
              "My Todos",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.filter_list, color: Colors.white),
                    if (hasActiveFilters)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const FilterDialog(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Center(
                  child: Text(
                    "$pendingCount pending",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            type: ExpandableFabType.up,
            distance: 64,
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            closeButtonBuilder: RotateFloatingActionButtonBuilder(
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.close, color: Colors.white),
            ),
            children: [
              _customFab(
                icon: Icons.add,
                label: "Write",
                color: Colors.indigo,
                onTap: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => const AddTodoDialog(),
                  );
                  if (result == false && context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => const ErrorDialog(
                        message: "Please add proper inputs and retry!",
                      ),
                    );
                  }
                },
              ),
              _customFab(
                icon: Icons.search,
                label: "Speech",
                color: Colors.teal,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SpeechToTextDialog(),
                  );
                },
              ),
            ],
          ),

          body: todos.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              hasActiveFilters
                                  ? Icons.search_off
                                  : Icons.check_circle_outline,
                              size: 80,
                              color: Colors.indigo.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasActiveFilters
                                  ? "No matching todos"
                                  : "No todos yet!",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.indigo.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hasActiveFilters
                                  ? "Try adjusting your filters"
                                  : "Tap the + button to add a new todo",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.indigo.shade300,
                              ),
                            ),
                            if (hasActiveFilters) ...[
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () {
                                  ref
                                      .read(filterProvider.notifier)
                                      .clearFilters();
                                },
                                icon: const Icon(Icons.clear_all),
                                label: Text(
                                  "Clear Filters",
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TodoListItem(
                          todo: todo,
                          onEdit: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => EditTodoDialog(todo: todo),
                            );
                            if (result == false && context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => const ErrorDialog(
                                  message:
                                      "Please add proper inputs and retry!",
                                ),
                              );
                            }
                          },
                          formattedDate: _formatDate(todo.createdAt),
                          onToggle: () {
                            ref.read(todoProvider.notifier).toggleToDo(todo.id);
                          },
                          onDelete: () {
                            ref.read(todoProvider.notifier).deleteToDo(todo.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

Widget _customFab({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
