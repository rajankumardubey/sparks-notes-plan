# ✦ Archival — Daily Planner, Notes & Diary

A beautiful Flutter mobile app for daily planning, note-taking, and journaling.
Inspired by the clean paper-meets-digital Archival design.

---

## 📱 Screenshots Overview

**4 screens via bottom navigation:**
- **Today** — Date header with mood selector, stats, task panel, quick note, recent diary
- **Tasks** — Full task manager with High/Med/Low priority and filters
- **Notes** — Masonry grid of color-accented note cards
- **Diary** — Chronological journal with date badges and mood tags

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0 (https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code with Flutter extension
- Android emulator / physical device OR Xcode for iOS

### 1. Clone or unzip the project
```bash
cd archival_app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run the app
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web (optional)
flutter run -d chrome
```

---

## 🏗 Project Structure

```
lib/
├── main.dart                  # App entry point, MainShell with bottom nav
├── theme/
│   └── app_theme.dart         # Colors, typography, ThemeData
├── models/
│   ├── models.dart            # Task, Note, DiaryEntry data classes
│   └── app_state.dart         # ChangeNotifier state management
├── widgets/
│   └── widgets.dart           # Reusable UI components
└── screens/
    ├── today_screen.dart      # Home / Today view
    ├── tasks_screen.dart      # Task manager
    ├── notes_screen.dart      # Notes grid
    ├── diary_screen.dart      # Diary list
    └── editor_screen.dart     # Create/Edit notes & diary entries
```

---

## ✨ Features

### Today Screen
- Live date display with greeting
- Mood selector (swipeable chips)
- Stats row: tasks / notes / diary count
- Task panel with priority dots (🔴🟡🟢) and progress bar
- Quick Note pad with ruled-paper aesthetic
  - Save as Note or Diary Entry
- Recent diary entries preview

### Tasks Screen
- Stats: Total / Completed / Progress %
- Filter: All / Pending / Done
- Priority-sorted list
- Swipe-style with add form
- Priority selector (High / Medium / Low)

### Notes Screen
- 2-column grid layout
- Color-coded accent bar per note (Red/Yellow/Green/Blue/Purple)
- Tap to open full editor
- FAB to create new note

### Diary Screen
- Date badge (day number + month)
- Mood tag display
- Swipe-to-delete
- Chronological ordering
- FAB to create new entry

### Editor Screen
- Serif title input
- Mood picker (diary only)
- Quick insert toolbar: • List, → Point, ★ Star, 💡 Idea, 📌 Note
- Ruled paper background with left margin line
- Color picker (notes only)
- Word count footer
- Save / Delete actions

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary font | Lora (serif) |
| UI font | DM Sans |
| Handwriting | Caveat |
| Accent | `#C84B31` (terracotta) |
| Accent light | `#E8A87C` (warm sand) |
| Sidebar | `#1A1A2E` (deep navy) |
| Paper | `#FAF9F6` |
| Paper 2 | `#F3F1EB` |

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `google_fonts` | Lora, DM Sans fonts |
| `uuid` | Unique IDs for entries |
| `intl` | Date formatting |

---

## 🔮 Future Enhancements (Roadmap)

- [ ] Hive / SQLite local persistence
- [ ] Push notifications / reminders
- [ ] Cloud backup (Firebase)
- [ ] Dark mode
- [ ] Calendar view with entry dots
- [ ] Productivity analytics
- [ ] Export diary as PDF
- [ ] Rich text (bold, italic, highlights)
- [ ] Tags and search
- [ ] Widget for home screen

---

## 📄 License

Open-source — for educational and personal use.
