
# Books Flutter App

This is a Flutter application for browsing books. It allows users to search for books and view detailed information. The app fetches book data from a remote server and caches results locally.

## How to Build and Run

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/books.git
   ```

2. Navigate into the project directory:

   ```bash
   cd books
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

## Design Decisions

- The app uses the **BLoC pattern** for state management, which makes it easier to separate logic and UI.
- **Hive** is used for local storage, providing fast and efficient data handling.
- **Dio** is used for network calls, as it offers powerful features like interceptors, global configurations, and more.

## Notes

- The app fetches book data from a remote server and uses local storage to cache results.
- Real-time search suggestions are based on the user’s input, and results are filtered as you type.
