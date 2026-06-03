import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── Priority dot
class PriorityDot extends StatelessWidget {
  final Priority priority;
  final double size;
  const PriorityDot({super.key, required this.priority, this.size = 7});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: priority.color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Section label (serif italic)
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Lora',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppTheme.ink3,
            ),
          ),
          const SizedBox(height: 6),
          Container(height: 1, color: AppTheme.lineColor),
        ],
      ),
    );
  }
}

// ── Stat card
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Widget? extra;
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.paper2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Caveat',
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: AppTheme.accent,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10,
              letterSpacing: 1.5,
              color: AppTheme.ink3,
            ),
          ),
          if (extra != null) ...[const SizedBox(height: 6), extra!],
        ],
      ),
    );
  }
}

// ── Progress bar
class MiniProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  const MiniProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.lineColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.accentGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ── Task tile
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: task.done ? AppTheme.accentGreen : Colors.transparent,
                  border: Border.all(
                    color: task.done ? AppTheme.accentGreen : AppTheme.lineColor,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: task.done
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            PriorityDot(priority: task.priority),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                task.text,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 14,
                  color: task.done ? AppTheme.ink3 : AppTheme.ink,
                  decoration:
                      task.done ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 16, color: AppTheme.ink3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mood chip
class MoodChip extends StatelessWidget {
  final String mood;
  final bool selected;
  final VoidCallback onTap;
  const MoodChip({
    super.key,
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentLight : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.accentLight
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          mood,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 12,
            color: selected ? AppTheme.ink : Colors.white.withValues(alpha: 0.7),
            fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Priority selector
class PrioritySelector extends StatelessWidget {
  final Priority selected;
  final ValueChanged<Priority> onChanged;
  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Priority.values
          .map((p) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => onChanged(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: selected == p
                          ? p.color.withValues(alpha: 0.15)
                          : AppTheme.paper2,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: selected == p ? p.color : AppTheme.lineColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: p.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          p.label,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 12,
                            color: selected == p ? p.color : AppTheme.ink2,
                            fontWeight: selected == p
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// ── Color picker for notes
class NoteColorPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const NoteColorPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppTheme.noteColors.entries
          .map((e) => GestureDetector(
                onTap: () => onChanged(e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: e.value,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected == e.key
                          ? AppTheme.ink
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: selected == e.key
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),
              ))
          .toList(),
    );
  }
}

// ── Diary card
class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  const DiaryCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 48,
              child: Column(
                children: [
                  Text(
                    '${entry.date.day}',
                    style: const TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent,
                      height: 1,
                    ),
                  ),
                  Text(
                    _monthStr(entry.date.month).toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: AppTheme.ink3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    entry.content.replaceAll('\n', ' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 13,
                      color: AppTheme.ink2,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (entry.mood.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.highYellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entry.mood,
                            style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 11, color: Color(0xFF9A7B00)),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _fullDate(entry.date),
                        style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 11, color: AppTheme.ink3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.ink3, size: 18),
          ],
        ),
      ),
    );
  }

  String _monthStr(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }

  String _fullDate(DateTime d) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[d.weekday % 7]}, ${months[d.month - 1]} ${d.day}';
  }
}

// ── Note card
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.paper,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.lineColor),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 4, color: note.accentColor),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 12,
                      color: AppTheme.ink2,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _shortDate(note.date),
                    style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 11, color: AppTheme.ink3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
