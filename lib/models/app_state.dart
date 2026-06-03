import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

const _uuid = Uuid();

class AppState extends ChangeNotifier {
  List<Task> tasks = [
    Task(
      id: _uuid.v4(),
      text: 'Morning meditation',
      priority: Priority.low,
      date: DateTime.now(),
    ),
    Task(
      id: _uuid.v4(),
      text: 'Review project proposal',
      priority: Priority.high,
      date: DateTime.now(),
    ),
    Task(
      id: _uuid.v4(),
      text: 'Team call at 3pm',
      priority: Priority.med,
      date: DateTime.now(),
    ),
    Task(
      id: _uuid.v4(),
      text: 'Grocery shopping',
      done: true,
      priority: Priority.med,
      date: DateTime.now(),
    ),
  ];

  List<Note> notes = [
    Note(
      id: _uuid.v4(),
      title: 'Book ideas',
      content:
          'Looking for books on stoicism and productivity. Maybe read Marcus Aurelius again. The Obstacle Is The Way was brilliant.',
      colorKey: 'purple',
      date: DateTime.now(),
      isPinned: true,
    ),
    Note(
      id: _uuid.v4(),
      title: 'Recipe: mango chai',
      content:
          '2 cups milk, 1 tsp tea, cardamom, ginger, 1/2 mango blended. Simmer 5 mins. Pure magic.',
      colorKey: 'yellow',
      date: DateTime.now(),
    ),
    Note(
      id: _uuid.v4(),
      title: 'Travel bucket list',
      content:
          'Kyoto in October\nIstanbul for 2 weeks\nValencia for the architecture\nOaxaca for the food',
      colorKey: 'blue',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<DiaryEntry> diary = [
    DiaryEntry(
      id: _uuid.v4(),
      title: 'A surprisingly good day',
      content:
          'Woke up early for once and it completely changed the energy of the day. Had a great chai, journaled for 20 minutes, and felt genuinely present.\n\nWork was productive — finished the proposal that had been sitting half-done for weeks. Small win, but it felt significant.\n\nEvening walk. The kind where you stop noticing your phone is in your pocket.',
      mood: '☀️ Great',
      date: DateTime.now(),
    ),
    DiaryEntry(
      id: _uuid.v4(),
      title: 'On feeling overwhelmed',
      content:
          'Some days the to-do list just feels like it reproduces itself. Crossed off five things, somehow six appeared.\n\nBut I made soup. And read for an hour. And that felt like enough.',
      mood: '😌 Calm',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DiaryEntry(
      id: _uuid.v4(),
      title: 'Weekend thoughts',
      content:
          'Visited the old neighbourhood. Everything feels smaller and more vivid at the same time. Nostalgia is a strange filter.',
      mood: '🤔 Focused',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  String currentMood = '';
  String quickNote = '';

  // --- Tasks ---
  void addTask(String text, Priority priority) {
    tasks.add(Task(
      id: _uuid.v4(),
      text: text,
      priority: priority,
      date: DateTime.now(),
    ));
    notifyListeners();
  }

  void toggleTask(String id) {
    final t = tasks.firstWhere((x) => x.id == id);
    t.done = !t.done;
    notifyListeners();
  }

  void deleteTask(String id) {
    tasks.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  List<Task> get todayTasks {
    final now = DateTime.now();
    return tasks
        .where((t) =>
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)
        .toList();
  }

  int get todayTasksDone => todayTasks.where((t) => t.done).length;
  double get todayProgress =>
      todayTasks.isEmpty ? 0 : todayTasksDone / todayTasks.length;

  // --- Notes ---
  void addNote(Note note) {
    notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(Note note) {
    final i = notes.indexWhere((x) => x.id == note.id);
    if (i >= 0) notes[i] = note;
    notifyListeners();
  }

  void deleteNote(String id) {
    notes.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  // --- Diary ---
  void addDiaryEntry(DiaryEntry entry) {
    diary.insert(0, entry);
    notifyListeners();
  }

  void updateDiaryEntry(DiaryEntry entry) {
    final i = diary.indexWhere((x) => x.id == entry.id);
    if (i >= 0) diary[i] = entry;
    notifyListeners();
  }

  void deleteDiaryEntry(String id) {
    diary.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  List<DiaryEntry> get sortedDiary {
    final sorted = [...diary];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // --- Mood ---
  void setMood(String mood) {
    currentMood = mood;
    notifyListeners();
  }

  void setQuickNote(String text) {
    quickNote = text;
    notifyListeners();
  }

  void saveQuickNoteAsNote() {
    if (quickNote.trim().isEmpty) return;
    addNote(Note(
      id: _uuid.v4(),
      title: 'Quick Note — ${_todayLabel()}',
      content: quickNote.trim(),
      colorKey: 'yellow',
      date: DateTime.now(),
    ));
    quickNote = '';
    notifyListeners();
  }

  void saveQuickNoteAsDiary() {
    if (quickNote.trim().isEmpty) return;
    addDiaryEntry(DiaryEntry(
      id: _uuid.v4(),
      title: 'Daily thoughts',
      content: quickNote.trim(),
      mood: currentMood,
      date: DateTime.now(),
    ));
    quickNote = '';
    notifyListeners();
  }

  String _todayLabel() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}';
  }
}
