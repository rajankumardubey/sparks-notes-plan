import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'editor_screen.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final entries = state.sortedDiary;

    return Scaffold(
      backgroundColor: AppTheme.paper2,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.sidebarBg,
            pinned: true,
            expandedHeight: 70,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              title: const Text(
                'My Diary',
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              background: Container(color: AppTheme.sidebarBg),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('Your story, one day at a time'),
                  if (entries.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Text('📖', style: TextStyle(fontSize: 40)),
                            SizedBox(height: 12),
                            Text(
                              'Your story starts here —\nwrite your first entry',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lora',
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.ink3,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppTheme.lineColor),
                      itemBuilder: (_, i) => Dismissible(
                        key: Key(entries[i].id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppTheme.accent.withValues(alpha: 0.1),
                          child: const Icon(Icons.delete_outline,
                              color: AppTheme.accent),
                        ),
                        onDismissed: (_) =>
                            state.deleteDiaryEntry(entries[i].id),
                        child: DiaryCard(
                          entry: entries[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditorScreen(
                                  type: 'diary', entry: entries[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
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
        label: const Text('New Entry',
            style: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500)),
        backgroundColor: AppTheme.accent,
      ),
    );
  }
}
