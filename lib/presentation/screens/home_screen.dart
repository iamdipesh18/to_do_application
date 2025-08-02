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
import '../dialogs/task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SortTasks _sortTasks = SortTasks();
  
  get task => null;

  // Opens the modal dialog to add a new task
  void _showAddTaskDialog() {
showTaskBottomSheet(
  context: context,
  task: task,
  onSave: (updatedTask) => context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask)),
);
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks()); // Load tasks when screen starts
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload Tasks',
            onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Dropdowns for filtering and sorting ---
            Row(
              children: [
                // Filter Dropdown
                Expanded(
                  child: BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<TaskFilter>(
                        value: state.activeFilter,
                        decoration: InputDecoration(
                          labelText: "Filter",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                        ),
                        items: TaskFilter.values.map((filter) {
                          return DropdownMenuItem(
                            value: filter,
                            child: Text(_filterLabel(filter)),
                          );
                        }).toList(),
                        onChanged: (filter) {
                          if (filter != null) {
                            context
                                .read<FilterBloc>()
                                .add(ChangeFilter(filter));
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Sort Dropdown
                Expanded(
                  child: BlocBuilder<SortBloc, SortState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<SortOrder>(
                        value: state.order,
                        decoration: InputDecoration(
                          labelText: "Sort",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                        ),
                        items: SortOrder.values.map((order) {
                          return DropdownMenuItem(
                            value: order,
                            child: Text(order == SortOrder.ascending
                                ? 'Date ↑'
                                : 'Date ↓'),
                          );
                        }).toList(),
                        onChanged: (order) {
                          if (order != null) {
                            context
                                .read<SortBloc>()
                                .add(ChangeSortOrder(order));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- Task List Section ---
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    return BlocBuilder<FilterBloc, FilterState>(
                      builder: (context, filterState) {
                        return BlocBuilder<SortBloc, SortState>(
                          builder: (context, sortState) {
                            final filteredTasks = _filterTasks(
                                state.tasks, filterState.activeFilter);
                            final sortedTasks =
                                _sortTasks(filteredTasks, sortState.order);

                            if (sortedTasks.isEmpty) {
                              return Center(
                                child: Text(
                                  'No tasks found.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            }

                            return ListView.separated(
                              itemCount: sortedTasks.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) =>
                                  TaskTile(task: sortedTasks[index]),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is TaskError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Converts enum to readable text for dropdown
  String _filterLabel(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return "All";
      case TaskFilter.completed:
        return "Completed";
      case TaskFilter.pending:
        return "Pending";
    }
  }

  // Filters task list based on selected filter
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
