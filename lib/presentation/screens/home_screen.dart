import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/domain/entities/task.dart';
import '../../logic/blocs/task_bloc/task_bloc.dart';
import '../../logic/blocs/task_bloc/task_event.dart';
import '../../logic/blocs/task_bloc/task_state.dart';
import '../../logic/blocs/filter_bloc/filter_bloc.dart';
import '../../logic/blocs/filter_bloc/filter_event.dart';
import '../../logic/blocs/filter_bloc/filter_state.dart';
import '../widgets/task_tile.dart';
import '../widgets/filter_buttons.dart';
import '../dialogs/task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        onSave: (task) {
          context.read<TaskBloc>().add(AddTaskEvent(task));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
            onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          BlocBuilder<FilterBloc, FilterState>(
            builder: (context, filterState) {
              return FilterButtons(
                activeFilter: filterState.activeFilter,
                onFilterSelected: (filter) {
                  context.read<FilterBloc>().add(ChangeFilter(filter));
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  return BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, filterState) {
                      final filteredTasks = _filterTasks(state.tasks, filterState.activeFilter);
                      if (filteredTasks.isEmpty) {
                        return const Center(child: Text('No tasks found.'));
                      }
                      return ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return TaskTile(task: task);
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
    );
  }

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
