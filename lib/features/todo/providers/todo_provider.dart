import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/features/todo/core/hive_boxes.dart';
import 'package:todo_app/features/todo/enums/todo_status.dart';
import 'package:todo_app/features/todo/model/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoState {
  final List<TodoModel> todos;
  final bool isLoading;
  final String? error;

  TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
  });

  TodoState copyWith({
    List<TodoModel>? todos,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier();
});

final pendingCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todoProvider).todos;
  return todos.where((todo) => !todo.isCompleted).length;
});

class TodoNotifier extends StateNotifier<TodoState> {
  final _uuid = const Uuid();
  final box = HiveBoxes.getToDoBox();

  TodoNotifier() : super(TodoState()) {
    loadTodos();
  }

  void loadTodos() {
    try {
      final todos = box.values
          .map((e) => TodoModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
      state = state.copyWith(todos: todos);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void addToDo(String title, String description, {DateTime? dueDate}) {
    final todo = TodoModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
    );
    box.put(todo.id, todo.toMap());
    loadTodos();
  }

  void updateToDo(String id, String title, String description, bool isCompleted, {DateTime? dueDate}) {
    final existingData = box.get(id);
    final updateTodo = TodoModel(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: existingData != null
          ? DateTime.parse(existingData['createdAt'])
          : DateTime.now(),
      dueDate: dueDate,
    );
    box.put(id, updateTodo.toMap());
    loadTodos();
  }

  void toggleToDo(String id) {
    final data = box.get(id);
    if (data != null) {
      final todo = TodoModel.fromMap(Map<String, dynamic>.from(data as Map));
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      box.put(id, updatedTodo.toMap());
      loadTodos();
    }
  }

  void deleteToDo(String id) {
    box.delete(id);
    loadTodos();
  }
}




class FilterState {
  final DateTime? startDate;
  final DateTime? endDate;
  final TodoStatus status;

  FilterState({
    this.startDate,
    this.endDate,
    this.status = TodoStatus.all,
  });

  FilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    TodoStatus? status,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return FilterState(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      status: status ?? this.status,
    );
  }
 
  bool get hasActiveFilters =>
      startDate != null || endDate != null || status != TodoStatus.all;
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date, clearStartDate: date == null);
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date, clearEndDate: date == null);
  }

  void setStatus(TodoStatus status) {
    state = state.copyWith(status: status);
  }

  void clearFilters() {
    state = FilterState();
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

final filteredTodosProvider = Provider<List<TodoModel>>((ref) {
  final todos = ref.watch(todoProvider).todos;
  final filter = ref.watch(filterProvider);

  var filtered = todos;

  if (filter.startDate != null || filter.endDate != null) {
    filtered = filtered.where((todo) {
      // Skip todos without due date when filtering by date
      if (todo.dueDate == null) return false;
      
      final todoDate = DateTime(
        todo.dueDate!.year,
        todo.dueDate!.month,
        todo.dueDate!.day,
      );

      if (filter.startDate != null && filter.endDate != null) {
        final start = DateTime(
          filter.startDate!.year,
          filter.startDate!.month,
          filter.startDate!.day,
        );
        final end = DateTime(
          filter.endDate!.year,
          filter.endDate!.month,
          filter.endDate!.day,
        );
        return (todoDate.isAtSameMomentAs(start) || todoDate.isAfter(start)) &&
            (todoDate.isAtSameMomentAs(end) || todoDate.isBefore(end));
      } else if (filter.startDate != null) {
        final start = DateTime(
          filter.startDate!.year,
          filter.startDate!.month,
          filter.startDate!.day,
        );
        return todoDate.isAtSameMomentAs(start) || todoDate.isAfter(start);
      } else if (filter.endDate != null) {
        final end = DateTime(
          filter.endDate!.year,
          filter.endDate!.month,
          filter.endDate!.day,
        );
        return todoDate.isAtSameMomentAs(end) || todoDate.isBefore(end);
      }
      return true;
    }).toList();
  }

  if (filter.status == TodoStatus.completed) {
    filtered = filtered.where((todo) => todo.isCompleted).toList();
  } else if (filter.status == TodoStatus.pending) {
    filtered = filtered.where((todo) => !todo.isCompleted).toList();
  }

  return filtered;
});

