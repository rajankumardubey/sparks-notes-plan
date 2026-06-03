import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'editor_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final notes = state.notes;

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
                'Notes',
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
                  const SectionLabel('Pinned & recent notes — tap any to edit'),
                  if (notes.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Text('📝', style: TextStyle(fontSize: 40)),
                            SizedBox(height: 12),
                            Text(
                              'No notes yet',
                              style: TextStyle(
                                fontFamily: 'Lora',
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.ink3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: notes.length + 1,
                      itemBuilder: (ctx, i) {
                        if (i == notes.length) {
                          return _addNoteCard(context);
                        }
                        return NoteCard(
                          note: notes[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditorScreen(
                                  type: 'note', note: notes[i]),
                            ),
                          ),
                        );
                      },
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
            builder: (_) => const EditorScreen(type: 'note'),
          ),
        ),
        icon: const Icon(Icons.note_add_outlined, size: 18),
        label: const Text('New Note',
            style: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w500)),
        backgroundColor: AppTheme.accent,
      ),
    );
  }

  Widget _addNoteCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EditorScreen(type: 'note'),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.lineColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+',
              style: TextStyle(
                fontSize: 32,
                color: AppTheme.ink3,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'New note',
              style: TextStyle(fontFamily: 'DM Sans', fontSize: 13, color: AppTheme.ink3),
            ),
          ],
        ),
      ),
    );
  }
}
