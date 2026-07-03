<h1 align="center">🃏 SkruMate</h1>

<p align="center">
  <strong>Your ultimate card game score tracker — built with Flutter.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/State_Management-Bloc-blueviolet" alt="Bloc" />
  <img src="https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite&logoColor=white" alt="SQLite" />
  <img src="https://img.shields.io/badge/Architecture-Clean_Architecture-green" alt="Clean Architecture" />
</p>

---

## 📖 About

**SkruMate** is a sleek, premium score-tracking app designed for the popular Egyptian card game **Screw (اسكرو)**. It helps you and your friends keep track of scores round by round, manage player profiles, view game history, and see who reigns supreme on the leaderboard — all wrapped in a beautiful, dark-themed UI.

---

## ✨ Features

- **🎮 Game Management** — Set up games with a custom number of players and rounds using an intuitive animated selector.
- **📝 Round-by-Round Scoring** — Add scores for each player per round with quick-tap buttons or manual input via a premium custom dialog.
- **🏆 Leaderboard** — Track all-time player stats including games played, wins, and win rate with ranked podium display.
- **📜 Game History** — Browse all previously played games, view detailed results, and delete games with swipe-to-delete.
- **👤 Player Profiles** — View individual player stats, game history per player, and manage player data.
- **🎨 Theme Support** — Switch between Dark and Light themes seamlessly, with preference persistence via SharedPreferences.
- **🎯 Winner Detection** — Automatic winner detection with celebratory confetti animation on the results screen.
- **💾 Offline First** — All data stored locally using SQLite — no internet required.

---

## 🏗️ Architecture

The project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
├── core/
│   ├── database/          # SQLite database, shared models & entities
│   ├── errors/            # Error handling
│   ├── helpers/           # DI, extensions, utilities
│   ├── routing/           # Named routes & AppRouter
│   ├── theming/           # Design system (palette, themes, decorations)
│   └── widgets/           # Reusable UI components
│
├── features/
│   ├── game/              # Game setup, gameplay, home screen
│   │   ├── data/          # Models, repos implementation
│   │   ├── domain/        # Repo contracts, use cases
│   │   └── presentation/  # Views, widgets, cubits
│   │
│   ├── games_history/     # Past games & results
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── players/           # Player management & stats
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── main.dart
└── screw_mate.dart        # App root widget
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.12+ |
| **State Management** | flutter_bloc / Cubit |
| **Dependency Injection** | get_it |
| **Local Database** | sqflite (SQLite) |
| **Theming** | Custom design system with `ColorsManager`, `AppPalette`, `AppDecorations` |
| **UI Components** | flutter_screenutil, google_fonts, gap, flutter_animate, flutter_slidable |
| **Preferences** | shared_preferences |
| **Functional Programming** | dartz (Either type for error handling) |

---

## 🎨 Design System

SkruMate features a fully custom **Gaming Violet** design system:

- **Color Palette** — Deep purple gradients (`#7B2FF2` → `#C961DE`) with 4-level dark surfaces.
- **Light & Dark Themes** — Full `ThemeData` for both modes, managed by `ThemeCubit`.
- **Glassmorphism Decorations** — Reusable glass, gradient, and glow card styles via `AppDecorations`.
- **Premium Buttons** — Gradient background with scale press animation and haptic feedback.
- **Unified Dialogs & Bottom Sheets** — All presented via static `show()` methods for consistency.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.12.1`
- Dart SDK `^3.12.1`

### Installation

```bash
# Clone the repository
git clone https://github.com/moo-elsayed/SkruMate.git
cd SkruMate

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📂 Key Screens

| Screen | Description |
|--------|-------------|
| **Home** | Game setup with animated player/round selectors and quick stats |
| **Add Players** | Select from existing players or create new ones before starting a game |
| **Game View** | Round-by-round score entry with live ranking and player cards |
| **Game Results** | Winner reveal with confetti, final standings, and detailed scores |
| **Leaderboard** | All-time player rankings with win rate and games played |
| **Player Profile** | Individual stats, game history timeline, and management options |
| **History** | List of all past games with swipe-to-delete functionality |

---

## 📄 License

This project is for personal use.

---

<p align="center">
  Made with ❤️ and Flutter
</p>
