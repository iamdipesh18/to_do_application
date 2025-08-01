import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_event.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_state.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_state.dart';
import 'package:to_do_application/logic/cubits/theme_cubit.dart';
import 'package:to_do_application/presentation/dialogs/task_dialog.dart';
import 'package:to_do_application/presentation/widgets/task_tile.dart';
import 'package:to_do_application/presentation/widgets/filter_buttons.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/core/enums/priority.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Task> _filterTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.active:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO App'),
        centerTitle: true,
        actions: [
          // Sort button
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                ),
                tooltip: 'Sort by Due Date',
                onPressed: () {
                  context.read<TaskBloc>().add(ToggleSortOrderEvent());
                },
              );
            },
          ),
          // Theme toggle button
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Light/Dark Theme',
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<FilterBloc, FilterState>(
              builder: (context, filterState) {
                return FilterButtons(
                  activeFilter: filterState.activeFilter,
                  onFilterSelected: (filter) {
                    context.read<FilterBloc>().add(FilterEvent(filter));
                  },
                );
              },
            ),
          ),

          // Task List
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, taskState) {
                if (taskState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (taskState.tasks.isEmpty) {
                  return const Center(child: Text('No tasks found.'));
                }

                return BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, filterState) {
                    final filteredTasks =
                        _filterTasks(taskState.tasks, filterState.activeFilter);

                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return TaskTile(task: task, index: index);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const TaskDialog(), // Add mode
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
