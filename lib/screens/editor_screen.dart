import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

const _uuid = Uuid();

class EditorScreen extends StatefulWidget {
  final String type; // 'diary' or 'note'
  final DiaryEntry? entry;
  final Note? note;

  const EditorScreen({
    super.key,
    required this.type,
    this.entry,
    this.note,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late String _colorKey;
  String _selectedMood = '';
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.entry == null && widget.note == null;

    if (widget.type == 'diary' && widget.entry != null) {
      _titleCtrl = TextEditingController(text: widget.entry!.title);
      _contentCtrl = TextEditingController(text: widget.entry!.content);
      _selectedMood = widget.entry!.mood;
    } else if (widget.type == 'note' && widget.note != null) {
      _titleCtrl = TextEditingController(text: widget.note!.title);
      _contentCtrl = TextEditingController(text: widget.note!.content);
      _colorKey = widget.note!.colorKey;
    } else {
      _titleCtrl = TextEditingController();
      _contentCtrl = TextEditingController();
    }

    _colorKey = (widget.note?.colorKey ?? 'yellow');

    if (_isNew && widget.type == 'diary') {
      _selectedMood = context.read<AppState>().currentMood;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  int get _wordCount {
    final text = _contentCtrl.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (content.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final state = context.read<AppState>();
    final effectiveTitle = title.isEmpty ? 'Untitled' : title;

    if (widget.type == 'diary') {
      if (_isNew) {
        state.addDiaryEntry(DiaryEntry(
          id: _uuid.v4(),
          title: effectiveTitle,
          content: content,
          mood: _selectedMood,
          date: DateTime.now(),
        ));
      } else {
        final updated = DiaryEntry(
          id: widget.entry!.id,
          title: effectiveTitle,
          content: content,
          mood: _selectedMood,
          date: widget.entry!.date,
        );
        state.updateDiaryEntry(updated);
      }
    } else {
      if (_isNew) {
        state.addNote(Note(
          id: _uuid.v4(),
          title: effectiveTitle,
          content: content,
          colorKey: _colorKey,
          date: DateTime.now(),
        ));
      } else {
        final updated = Note(
          id: widget.note!.id,
          title: effectiveTitle,
          content: content,
          colorKey: _colorKey,
          date: widget.note!.date,
        );
        state.updateNote(updated);
      }
    }
    Navigator.pop(context);
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete entry?',
            style: TextStyle(fontFamily: 'Lora', fontSize: 17, fontWeight: FontWeight.w500)),
        content: const Text(
          'This cannot be undone.',
          style: TextStyle(fontFamily: 'DM Sans', fontSize: 14, color: AppTheme.ink2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(fontFamily: 'DM Sans', color: AppTheme.ink2)),
          ),
          TextButton(
            onPressed: () {
              final state = context.read<AppState>();
              if (widget.type == 'diary') {
                state.deleteDiaryEntry(widget.entry!.id);
              } else {
                state.deleteNote(widget.note!.id);
              }
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(
                    fontFamily: 'DM Sans',
                    color: AppTheme.accent, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDiary = widget.type == 'diary';
    return Scaffold(
      backgroundColor: AppTheme.paper,
      appBar: AppBar(
        backgroundColor: AppTheme.sidebarBg,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _isNew
              ? (isDiary ? 'New Diary Entry' : 'New Note')
              : (isDiary ? 'Edit Entry' : 'Edit Note'),
          style: const TextStyle(
            fontFamily: 'Lora',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline, color: Colors.white54),
            ),
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppTheme.accentLight,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toolbar for note options
                  if (!isDiary) ...[
                    _buildNoteToolbar(),
                    const SizedBox(height: 16),
                  ],
                  // Title
                  TextField(
                    controller: _titleCtrl,
                    style: const TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.ink,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Give this entry a title…',
                      hintStyle: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.ink3,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textInputAction: TextInputAction.next,
                    maxLines: 2,
                    minLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Container(height: 1, color: AppTheme.lineColor),
                  const SizedBox(height: 16),
                  // Mood selector for diary
                  if (isDiary) ...[
                    _buildMoodSelector(),
                    const SizedBox(height: 16),
                  ],
                  // Quick insert bar
                  _buildInsertBar(),
                  const SizedBox(height: 16),
                  // Main content
                  _buildContentArea(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildNoteToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.paper2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lineColor),
      ),
      child: Row(
        children: [
          const Text('Color:',
              style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: AppTheme.ink3)),
          const SizedBox(width: 10),
          NoteColorPicker(
            selected: _colorKey,
            onChanged: (k) => setState(() => _colorKey = k),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's mood",
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 11,
            letterSpacing: 1.5,
            color: AppTheme.ink3,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: moodOptions
              .map((m) => GestureDetector(
                    onTap: () => setState(() => _selectedMood = m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedMood == m
                            ? AppTheme.highYellow
                            : AppTheme.paper2,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedMood == m
                              ? const Color(0xFFE8A87C)
                              : AppTheme.lineColor,
                        ),
                      ),
                      child: Text(
                        m,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          color: _selectedMood == m
                              ? const Color(0xFF9A7B00)
                              : AppTheme.ink2,
                          fontWeight: _selectedMood == m
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildInsertBar() {
    final inserts = [
      ('• List', '• '),
      ('→ Point', '→ '),
      ('★ Star', '★ '),
      ('💡 Idea', '💡 '),
      ('📌 Note', '📌 '),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: inserts
            .map((item) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _insertText(item.$2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.paper2,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppTheme.lineColor),
                      ),
                      child: Text(
                        item.$1,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          color: AppTheme.ink2,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _insertText(String text) {
    final ctrl = _contentCtrl;
    final pos = ctrl.selection.baseOffset;
    if (pos < 0) {
      ctrl.text = ctrl.text + text;
      ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
    } else {
      final newText = ctrl.text.substring(0, pos) + text + ctrl.text.substring(pos);
      ctrl.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: pos + text.length),
      );
    }
    setState(() {});
  }

  Widget _buildContentArea() {
    return CustomPaint(
      painter: _RuledPainter(),
      child: Container(
        constraints: const BoxConstraints(minHeight: 600),
        child: TextField(
          controller: _contentCtrl,
          maxLines: null,
          style: const TextStyle(
            fontFamily: 'Lora',
            fontSize: 16,
            color: AppTheme.ink,
            height: 2.0,
          ),
          decoration: const InputDecoration(
            hintText: 'Start writing… your thoughts deserve space.',
            hintStyle: TextStyle(
              fontFamily: 'Lora',
              fontSize: 16,
              color: AppTheme.ink3,
              fontStyle: FontStyle.italic,
              height: 2.0,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 52, right: 16, top: 0),
            isDense: true,
            filled: false,
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.paper,
        border: Border(top: BorderSide(color: AppTheme.lineColor)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _contentCtrl,
            builder: (_, __) => Text(
              '$_wordCount words',
              style: const TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: AppTheme.ink3),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text(
              'Save Entry',
              style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuledPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizontalPaint = Paint()
      ..color = const Color(0xFFE0DDD4) // Subtle line color
      ..strokeWidth = 1.0;

    const lineHeight = 32.0;
    // Aligning horizontal lines to the text baseline
    // With font size 16 and height 2.0, the line height is 32.
    // The text baseline is usually around 27 pixels from the top of the line box.
    const firstLineY = 27.0;

    for (double y = firstLineY; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), horizontalPaint);
    }

    // Vertical margin line (College rule style)
    final verticalPaint = Paint()
      ..color = AppTheme.accent.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    const marginX = 40.0;
    canvas.drawLine(const Offset(marginX, 0), Offset(marginX, size.height), verticalPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
