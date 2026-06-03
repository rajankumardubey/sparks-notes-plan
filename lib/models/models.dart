import 'package:flutter/material.dart';

enum Priority { high, med, low }

extension PriorityExt on Priority {
  String get label {
    switch (this) {
      case Priority.high:
        return 'High';
      case Priority.med:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  Color get color {
    switch (this) {
      case Priority.high:
        return const Color(0xFFC84B31);
      case Priority.med:
        return const Color(0xFFE8A87C);
      case Priority.low:
        return const Color(0xFF4A7C59);
    }
  }

  String get emoji {
    switch (this) {
      case Priority.high:
        return '🔴';
      case Priority.med:
        return '🟡';
      case Priority.low:
        return '🟢';
    }
  }
}

class Task {
  final String id;
  String text;
  bool done;
  Priority priority;
  DateTime date;

  Task({
    required this.id,
    required this.text,
    this.done = false,
    this.priority = Priority.med,
    required this.date,
  });

  Task copyWith({
    String? id,
    String? text,
    bool? done,
    Priority? priority,
    DateTime? date,
  }) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      done: done ?? this.done,
      priority: priority ?? this.priority,
      date: date ?? this.date,
    );
  }
}

class Note {
  final String id;
  String title;
  String content;
  String colorKey; // 'red','yellow','green','blue','purple'
  DateTime date;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.colorKey = 'yellow',
    required this.date,
    this.isPinned = false,
  });

  Color get accentColor {
    const colors = {
      'red': Color(0xFFC84B31),
      'yellow': Color(0xFFE8A87C),
      'green': Color(0xFF4A7C59),
      'blue': Color(0xFF2D6A9F),
      'purple': Color(0xFF7C4D9F),
    };
    return colors[colorKey] ?? const Color(0xFFE8A87C);
  }
}

class DiaryEntry {
  final String id;
  String title;
  String content;
  String mood;
  DateTime date;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    this.mood = '',
    required this.date,
  });
}

const List<String> moodOptions = [
  '☀️ Great',
  '😌 Calm',
  '🤔 Focused',
  '😴 Tired',
  '😤 Stressed',
  '💪 Motivated',
  '😊 Happy',
];
