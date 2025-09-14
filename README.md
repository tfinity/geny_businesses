# Geny Flutter Mini App

A simple Flutter mini-app built as part of the Geny pre-qualification test.  
Displays a list of businesses with search, detail screens, offline caching, and error/retry handling.

---

## ✨ Features

- Provider-based state management
- Dio for networking (even with local JSON)
- Offline persistence using SharedPreferences
- Search functionality
- Business detail screen
- Clear loading, empty, and error states with retry
- Reusable `BusinessCard<T>` widget (composition/generics)

---

## 📂 Project Structure

- lib/
- models/ # Domain models
- repository/ # Data layer (Dio + cache)
- providers/ # App state (Provider)
- screens/ # UI screens (list, detail)
- widgets/ # Reusable widgets
- main.dart # Entry point
- assets/
- data/businesses.json # Local mock data


---

## 💾 Offline Behavior

- First load: fetches from local JSON via Dio and saves to SharedPreferences
- Next launches: loads cached data instantly (offline support)
- Use `forceNetwork = true` on retry to bypass cache

---

## ⚙️ Setup

1. Clone the repository  
2. Run `flutter pub get`  
3. Run with `flutter run`

---

## 📑 Notes

See [`TECH_NOTES.md`](TECH_NOTES.md) for architecture overview, design decisions, and improvement plans.

---

## 🧑 Author

**Muhammad Talha Riaz (@tfinity)**  
Email: talhariaz.dev@gmail.com
