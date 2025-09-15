# TECH_NOTES

## Architecture
- **State Management:** Provider (`ChangeNotifier`) for simplicity and readability.
- **Networking:** Dio for consistent API handling, error catching, and easy retries.
- **Persistence:** SharedPreferences for lightweight offline caching of the fetched businesses.
- **UI:** Clean separation of UI (widgets/screens) from logic (provider + repository).
- **Composition:** Reusable `BusinessCard<T>` that can render any model with a builder.

## Data Flow
UI → BusinessProvider → BusinessRepository → Dio (local JSON)  
                         ↓  
                 SharedPreferences (cache)

## Key Trade-offs
- Used `SharedPreferences` instead of SQLite/Drift to keep setup fast and lightweight.
- Used Provider over Riverpod/BLoC to align with assignment requirements even though Riverpod offers more flexibility.
- Chose local JSON asset + Dio to simulate real network calls without backend setup.

## Improvements (given more time)
- Add pagination and pull-to-refresh.
- Add unit tests for repository and provider logic.
- Introduce proper error handling with Dio interceptors and custom exceptions.
- Move caching to a local DB (Drift/Hive) for better scalability.
- Use Riverpod or BLoC for more robust architecture on larger scale.
