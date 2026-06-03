import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _taskCtrl = TextEditingController();
  Priority _selectedPriority = Priority.med;
  String _filter = 'all';

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allTasks = state.tasks;
    final done = allTasks.where((t) => t.done).length;
    final total = allTasks.length;
    final pct = total == 0 ? 0 : ((done / total) * 100).round();

    List<Task> filtered;
    if (_filter == 'pending') {
      filtered = allTasks.where((t) => !t.done).toList();
    } else if (_filter == 'done') {
      filtered = allTasks.where((t) => t.done).toList();
    } else {
      filtered = [...allTasks];
    }
    // Sort: high priority first, done last
    filtered.sort((a, b) {
      if (a.done != b.done) return a.done ? 1 : -1;
      return a.priority.index.compareTo(b.priority.index);
    });

    return Scaffold(
      backgroundColor: AppTheme.paper2,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.sidebarBg,
            expandedHeight: 70,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              title: const Text(
                'Task Manager',
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              background: Container(
                color: AppTheme.sidebarBg,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.bottomLeft,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: StatCard(
                              value: '$total', label: 'Total')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: StatCard(
                              value: '$done', label: 'Completed')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: StatCard(
                              value: '$pct%', label: 'Progress')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.paper,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.lineColor),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                          child: Row(
                            children: [
                              const Text(
                                'All Tasks',
                                style: TextStyle(
                                  fontFamily: 'Lora',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              _filterBtn('All', 'all'),
                              const SizedBox(width: 4),
                              _filterBtn('Pending', 'pending'),
                              const SizedBox(width: 4),
                              _filterBtn('Done', 'done'),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(28),
                            child: Text(
                              'No tasks here',
                              style: TextStyle(
                                fontFamily: 'Lora',
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                color: AppTheme.ink3,
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final task = filtered[i];
                              return Column(
                                children: [
                                  TaskTile(
                                    task: task,
                                    onToggle: () =>
                                        state.toggleTask(task.id),
                                    onDelete: () =>
                                        state.deleteTask(task.id),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 52, right: 16, bottom: 6),
                                    child: Text(
                                      _dateStr(task.date),
                                      style: const TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: 11,
                                          color: AppTheme.ink3),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        const Divider(height: 1),
                        _buildAddTaskBar(state),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBtn(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : AppTheme.paper2,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.lineColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppTheme.ink2,
          ),
        ),
      ),
    );
  }

  Widget _buildAddTaskBar(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _taskCtrl,
            style: const TextStyle(fontFamily: 'DM Sans', fontSize: 14, color: AppTheme.ink),
            decoration: const InputDecoration(
              hintText: 'Add a new task…',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onSubmitted: (_) => _submitTask(state),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PrioritySelector(
                    selected: _selectedPriority,
                    onChanged: (p) => setState(() => _selectedPriority = p),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _submitTask(state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                child: const Text('+ Add',
                    style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitTask(AppState state) {
    final text = _taskCtrl.text.trim();
    if (text.isEmpty) return;
    state.addTask(text, _selectedPriority);
    _taskCtrl.clear();
  }

  String _dateStr(DateTime d) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[d.weekday % 7]}, ${months[d.month - 1]} ${d.day}';
  }
}
