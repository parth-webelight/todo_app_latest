// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todo/enums/todo_status.dart';
import 'package:todo_app/features/todo/providers/todo_provider.dart';
import 'package:todo_app/features/widgets/custom_button.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});
Future<void> _selectDateRange(BuildContext context, WidgetRef ref) async {
  final currentFilter = ref.read(filterProvider);

  final picked = await showDateRangePicker(
    context: context,
    barrierColor: Colors.indigo.withOpacity(0.2),
    initialDateRange:
        currentFilter.startDate != null && currentFilter.endDate != null
            ? DateTimeRange(
                start: currentFilter.startDate!,
                end: currentFilter.endDate!,
              )
            : null,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.indigo,        
            onPrimary: Colors.white,       
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          datePickerTheme: DatePickerThemeData(
            rangeSelectionBackgroundColor:
                Colors.indigo.withOpacity(0.2), 
            rangeSelectionOverlayColor:
                MaterialStateProperty.all(
                  Colors.indigo.withOpacity(0.15),
                ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    ref.read(filterProvider.notifier).setStartDate(picked.start);
    ref.read(filterProvider.notifier).setEndDate(picked.end);
  }
}


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final filter = ref.watch(filterProvider);

        return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Filter Todos",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date Range",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _selectDateRange(context, ref),
              icon: const Icon(Icons.date_range, size: 18),
              label: Text(
                filter.startDate == null || filter.endDate == null
                    ? "Select Date Range"
                    : "${filter.startDate!.day}/${filter.startDate!.month}/${filter.startDate!.year} - ${filter.endDate!.day}/${filter.endDate!.month}/${filter.endDate!.year}",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Status",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TodoStatus>(
              value: filter.status,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: TodoStatus.all,
                  child: Text("All", style: GoogleFonts.poppins()),
                ),
                DropdownMenuItem(
                  value: TodoStatus.completed,
                  child: Text("Completed", style: GoogleFonts.poppins()),
                ),
                DropdownMenuItem(
                  value: TodoStatus.pending,
                  child: Text("Pending", style: GoogleFonts.poppins()),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(filterProvider.notifier).setStatus(value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          onPress: () {
            ref.read(filterProvider.notifier).clearFilters();
            Navigator.pop(context);
          },
          title: "Clear",
          isBackgroundColor: false,
        ),
        CustomButton(
          onPress: () => Navigator.pop(context),
          title: "Close",
          isBackgroundColor: true,
        ),
      ],
        );
      },
    );
  }
}