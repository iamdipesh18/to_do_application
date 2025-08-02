import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/core/enums/task_filter.dart';
import 'package:to_do_application/core/enums/sort_order.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_event.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_state.dart';

import '../../logic/blocs/task_bloc/task_bloc.dart';
import '../../logic/blocs/task_bloc/task_event.dart';
import '../../logic/blocs/task_bloc/task_state.dart';
import '../../logic/blocs/filter_bloc/filter_bloc.dart';
import '../../logic/blocs/filter_bloc/filter_event.dart';
import '../../logic/blocs/filter_bloc/filter_state.dart';

import '../../domain/usecases/sort_tasks.dart';

import '../widgets/task_tile.dart';
import '../widgets/filter_buttons.dart';
import '../dialogs/task_dialog.dart';

// The main screen that shows the list of tasks and controls.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SortTasks _sortTasks = SortTasks(); // Use case to sort tasks

  // Shows the dialog to add a new task.
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        onSave: (task) {
          // When the user saves, add the task via TaskBloc.
          context.read<TaskBloc>().add(AddTaskEvent(task));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // When screen loads, fetch all tasks.
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // Reload tasks when refresh is tapped.
            onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // Open dialog to add a task.
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter buttons (All, Active, Completed)
          BlocBuilder<FilterBloc, FilterState>(
            builder: (context, filterState) {
              return FilterButtons(
                activeFilter: filterState.activeFilter,
                onFilterSelected: (filter) {
                  // Change filter state on button tap.
                  context.read<FilterBloc>().add(ChangeFilter(filter));
                },
              );
            },
          ),
          // Sort buttons to select ascending or descending due date order.
          BlocBuilder<SortBloc, SortState>(
            builder: (context, sortState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sort by Due Date: '),
                    ChoiceChip(
                      label: const Text('Asc'),
                      selected: sortState.order == SortOrder.ascending,
                      onSelected: (_) {
                        // Change sort order to ascending.
                        context
                            .read<SortBloc>()
                            .add(ChangeSortOrder(SortOrder.ascending));
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Desc'),
                      selected: sortState.order == SortOrder.descending,
                      onSelected: (_) {
                        // Change sort order to descending.
                        context
                            .read<SortBloc>()
                            .add(ChangeSortOrder(SortOrder.descending));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          // Expanded list of tasks
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  // Show loading indicator while tasks load.
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  // When tasks are loaded, also listen to filter and sort states.
                  return BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, filterState) {
                      return BlocBuilder<SortBloc, SortState>(
                        builder: (context, sortState) {
                          // Filter tasks based on active filter.
                          final filteredTasks =
                              _filterTasks(state.tasks, filterState.activeFilter);
                          // Sort filtered tasks by due date.
                          final sortedTasks =
                              _sortTasks(filteredTasks, sortState.order);

                          if (sortedTasks.isEmpty) {
                            // Show message if no tasks available.
                            return const Center(child: Text('No tasks found.'));
                          }

                          // Show tasks in a scrolling list.
                          return ListView.builder(
                            itemCount: sortedTasks.length,
                            itemBuilder: (context, index) {
                              final task = sortedTasks[index];
                              return TaskTile(task: task); // Custom widget for each task.
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (state is TaskError) {
                  // Show error message if loading tasks failed.
                  return Center(child: Text('Error: ${state.message}'));
                }
                // Show empty space if no state matches.
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to filter tasks by status.
  List<Task> _filterTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }
}
