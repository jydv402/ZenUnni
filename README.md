# Zenunni – AI Scheduler & Student Assistant App

Zenunni is an all-in-one productivity app designed for college students and working professionals. It combines task management, AI assistance, habit and mood tracking, Pomodoro focus tools, and a chatbot named "Unni".



## ✨ Features
- 🔔 Smart Task Manager with Priorities & Recurrence
- ⏱️ Pomodoro Timer
- 🤖 AI Chatbot (Gemini API)
- 📊 Mood & Habit Tracker
- 🌙 Dark & Light Theme Modes
- 🔐 Firebase Auth & Firestore DB

## 🧠 Tech Stack
- Flutter + Dart
- Firebase (Auth, Firestore, Storage)
- Riverpod for State Management
- Gemini API for AI Chatbot

## 📸 Screenshots




## 🔧 Installation Guide for Zenunni

### 1. Clone the Repo
```bash
git clone https://github.com/<jydv402>/zenunni.git
cd zenunni
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Firebase
- Use `flutterfire configure` to generate `firebase_options.dart`
- Add `.env` with your keys

### 4. Run App
```bash
flutter run
```

## 🧱 Zenunni Architecture

### 🔨 Folder Structure (lib/)
- `auth_pages/`: Registration, login, verification
- `components/`: UI widgets (toasts, dialogs)
- `models/`: Data models (TodoModel, UserModel)
- `screens/`: Main app screens (Chat, Home, Pomodoro)
- `services/`: Business logic + Firestore interaction
- `theme/`: Light & dark themes
- `utils/`: Helper functions
- `zen_barrel.dart`: Barrel file to re-export all

### 🧠 State Management
- Using Riverpod (`flutter_riverpod`) for global states like theme, user info, task list

### ☁️ Firebase Services
- Auth for login/register/email verification
- Firestore for storing user data and tasks
- Firebase Cloud Messaging and Local Notifications

 
## 🙌 Contribute to Zenunni

Thanks for your interest! Follow these steps:

### 1. Fork and Clone
```bash
git clone https://github.com/<jydv402>/zenunni.git
```

### 2. Create Branch
```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes
Push commits with meaningful messages.

### 4. Create Pull Request

## Guidelines
- Use clear variable names
- Follow existing UI patterns
- Test before pushing
---

© 2025 Team Zenunni
