# Flutter To-Do App

A simple To-Do app built with Flutter, allowing users to create tasks with a title and a due date. It fetches a dummy list of tasks from an API and saves tasks locally using SharedPreferences. The app uses `Provider` for state management.

## Features

- Create a task with a title and due date.
- Fetch a dummy list of tasks from an API (https://jsonplaceholder.typicode.com/todos) by clicking the download icon in the app bar.
- Save tasks locally using SharedPreferences.
- Manage state with the `Provider` package.

## Screenshots

- Main screen showing a list of tasks.
  <img src="https://github.com/user-attachments/assets/e5c272cf-b71c-4a34-9453-d885304985a8" >

## Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   ```

2. **Navigate to the project directory:**

   ```bash
   cd flutter-todo-app
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the app:**

   ```bash
   flutter run
   ```

## Technologies Used

- **Flutter**: Framework for building the app.
- **SharedPreferences**: For local data storage.
- **Provider**: For state management.
- **DIO**: For making API calls to fetch the to-do list.

## How It Works

1. **Create Task:**

   - Users can add a new task with a title and due date through a simple form.
   - The task is saved locally using `SharedPreferences`.

2. **Fetch Tasks:**

   - When the download icon in the app bar is clicked, an API call is made to fetch a list of tasks from `https://jsonplaceholder.typicode.com/todos`.
   - The tasks are displayed in a list on the screen.

3. **State Management:**
   - The app uses `Provider` to manage the state of the tasks.
   - Tasks fetched from the API or saved locally are stored in a shared state and updated across the app.

## Dependencies

- `provider`: For state management.
- `dio`: To make API calls.
- `shared_preferences`: For local storage of tasks.
