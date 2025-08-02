import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/core/enums/task_filter.dart';
import 'package:to_do_application/core/enums/sort_order.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_event.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_state.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_event.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_state.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_event.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_state.dart';
import 'package:to_do_application/domain/usecases/sort_tasks.dart';
import 'package:to_do_application/presentation/widgets/task_tile.dart';
import 'package:to_do_application/presentation/dialogs/task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final SortTasks _sortTasks = SortTasks();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
    _tabController = TabController(length: 3, vsync: this);

    // Update filter when tab is switched
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final filter = TaskFilter.values[_tabController.index];
        context.read<FilterBloc>().add(ChangeFilter(filter));
      }
    });
  }

  void _openAddTaskDialog() {
    showTaskBottomSheet(
      context: context,
      task: null,
      onSave: (updatedTask) =>
          context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          BlocBuilder<SortBloc, SortState>(
            builder: (context, sortState) {
              final isAscending = sortState.order == SortOrder.ascending;
              return IconButton(
                tooltip: isAscending ? 'Sort Descending' : 'Sort Ascending',
                icon: Icon(
                  isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                ),
                onPressed: () {
                  final newOrder =
                      isAscending ? SortOrder.descending : SortOrder.ascending;

                  // Dispatch event
                  context.read<SortBloc>().add(ChangeSortOrder(newOrder));

                  // Show feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sorted by: ${newOrder == SortOrder.ascending ? 'Ascending' : 'Descending'}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TaskBloc>().add(LoadTasks());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task list refreshed.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        onPressed: _openAddTaskDialog,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, taskState) {
            if (taskState is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (taskState is TaskLoaded) {
              return BlocBuilder<FilterBloc, FilterState>(
                builder: (context, filterState) {
                  return BlocBuilder<SortBloc, SortState>(
                    builder: (context, sortState) {
                      final filtered = _filterTasks(
                          taskState.tasks, filterState.activeFilter);
                      final sorted = _sortTasks(filtered, sortState.order);

                      if (sorted.isEmpty) {
                        return const Center(child: Text('No tasks found.'));
                      }

                      return ListView.separated(
                        itemCount: sorted.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return TaskTile(task: sorted[index]);
                        },
                      );
                    },
                  );
                },
              );
            } else if (taskState is TaskError) {
              return Center(child: Text(taskState.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Filter tasks based on selected tab
  List<Task> _filterTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
