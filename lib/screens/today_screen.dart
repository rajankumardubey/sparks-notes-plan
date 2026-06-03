import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'editor_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _taskCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  Priority _selectedPriority = Priority.med;
  bool _showBanner = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();
      _noteCtrl.text = state.quickNote;
    });
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final todayTasks = state.todayTasks;
    final doneTasks = todayTasks.where((t) => t.done).length;

    return Scaffold(
      backgroundColor: AppTheme.paper2,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(state),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showBanner) _buildWelcomeBanner(),
                  const SizedBox(height: 4),
                  _buildStatsRow(state, todayTasks.length, doneTasks),
                  const SizedBox(height: 20),
                  _buildTasksPanel(state, todayTasks),
                  const SizedBox(height: 20),
                  _buildQuickNotePanel(state),
                  const SizedBox(height: 20),
                  const SectionLabel('Recent diary entries'),
                  _buildRecentDiary(state),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EditorScreen(type: 'diary'),
          ),
        ),
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('New Entry', style: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500)),
        backgroundColor: AppTheme.accent,
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    final now = DateTime.now();
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Container(
      color: AppTheme.sidebarBg,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✦ Archival',
                      style: TextStyle(
                        fontFamily: 'Caveat',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${now.day}',
                          style: const TextStyle(
                            fontFamily: 'Caveat',
                            fontSize: 56,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentLight,
                            height: 1,
                          ),
                        ),
                      ]),
                    ),
                    Text(
                      days[now.weekday % 7],
                      style: TextStyle(
                        fontFamily: 'Caveat',
                        fontSize: 20,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '${months[now.month - 1]} ${now.year}',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _greeting(),
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Today is yours ✦',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.accentLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Today's mood",
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10,
              letterSpacing: 2,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: moodOptions
                  .map((m) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: MoodChip(
                          mood: m,
                          selected: state.currentMood == m,
                          onTap: () => state.setMood(m),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.accent, AppTheme.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('✦', style: TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Archival',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your planner, notes & diary — all in one place.',
                  style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showBanner = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Got it',
                style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppState state, int total, int done) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            value: '$total',
            label: 'Tasks today',
            extra: MiniProgressBar(value: state.todayProgress),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            value: '${state.notes.length}',
            label: 'Notes saved',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            value: '${state.diary.length}',
            label: 'Diary entries',
          ),
        ),
      ],
    );
  }

  Widget _buildTasksPanel(AppState state, List<Task> tasks) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lineColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                const Text(
                  "Today's Tasks",
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _priorityLegend(),
              ],
            ),
          ),
          const Divider(height: 1),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No tasks yet — add one below',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: AppTheme.ink3,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppTheme.lineColor),
              itemBuilder: (_, i) => TaskTile(
                task: tasks[i],
                onToggle: () => state.toggleTask(tasks[i].id),
                onDelete: () => state.deleteTask(tasks[i].id),
              ),
            ),
          const Divider(height: 1),
          _buildAddTaskBar(state),
        ],
      ),
    );
  }

  Widget _priorityLegend() {
    return Row(
      children: Priority.values
          .map((p) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    PriorityDot(priority: p),
                    const SizedBox(width: 3),
                    Text(
                      p == Priority.med ? 'Med' : p.label,
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 10, color: AppTheme.ink3),
                    ),
                  ],
                ),
              ))
          .toList(),
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
            decoration: InputDecoration(
              hintText: 'Add a task… tap Done to save',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppTheme.lineColor),
              ),
            ),
            onSubmitted: (_) => _submitTask(state),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrioritySelector(
                  selected: _selectedPriority,
                  onChanged: (p) => setState(() => _selectedPriority = p),
                ),
              ),
              ElevatedButton(
                onPressed: () => _submitTask(state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                child: const Text(
                  '+ Add',
                  style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                ),
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

  Widget _buildQuickNotePanel(AppState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lineColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Text('Quick Note',
                    style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 15, fontWeight: FontWeight.w500)),
                Spacer(),
                Text('auto-saved',
                    style:
                        TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: AppTheme.ink3)),
              ],
            ),
          ),
          const Divider(height: 1),
          Stack(
            children: [
              Positioned(
                left: 40,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: AppTheme.accent.withValues(alpha: 0.2),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.paper,
                ),
                child: TextField(
                  controller: _noteCtrl,
                  maxLines: 7,
                  style: const TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.ink,
                    height: 1.8,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Jot down a thought, idea, or reflection…',
                    hintStyle: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 17,
                      color: AppTheme.ink3,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(52, 14, 16, 14),
                  ),
                  onChanged: (v) => state.setQuickNote(v),
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _quickNoteBtn('📌 Save as Note', () {
                  state.saveQuickNoteAsNote();
                  _noteCtrl.clear();
                }),
                const SizedBox(width: 8),
                _quickNoteBtn('📖 Save as Diary', () {
                  state.saveQuickNoteAsDiary();
                  _noteCtrl.clear();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickNoteBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.paper2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.lineColor),
        ),
        child: Text(label,
            style: const TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: AppTheme.ink2)),
      ),
    );
  }

  Widget _buildRecentDiary(AppState state) {
    final recent = state.sortedDiary.take(2).toList();
    if (recent.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Begin your first diary entry ↑',
            style: TextStyle(
              fontFamily: 'Lora',
              fontStyle: FontStyle.italic,
              fontSize: 14,
              color: AppTheme.ink3,
            ),
          ),
        ),
      );
    }
    return Column(
      children: recent
          .map((e) => Column(
                children: [
                  DiaryCard(
                    entry: e,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditorScreen(type: 'diary', entry: e),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.lineColor),
                ],
              ))
          .toList(),
    );
  }
}
