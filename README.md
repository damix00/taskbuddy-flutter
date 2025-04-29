# TaskBuddy - Mobile App (Flutter)

TaskBuddy is a mobile app designed to help users post and manage errands/jobs in an easy and efficient way. Whether you need something done or want to help others, TaskBuddy connects people in need with those willing to assist.

🏆 1st Place Winner in the national computer science competition in the Software Development category in Croatia, 2024.

You can also check out the [backend](https://github.com/damix00/taskbuddy-backend) and [admin panel](https://github.com/damix00/taskbuddy-admin) repos.

## Features

- **Post Tasks**: Users can easily create tasks, specifying details such as task description, location, and reward.
- **Browse Tasks**: View available tasks in your area and filter based on type, urgency and reward. The app also has a recommendation algorithm.
- **Task Management**: Users can manage tasks they have posted or accepted, including marking tasks as complete.
- **User Profiles**: Each user has a profile that includes their posted tasks, as well as ratings from others.
- **In-app Chat**: Communicate directly with other users regarding listings.

## Installation

Follow these steps to set up TaskBuddy on your local machine for development and testing.

### Prerequisites

Make sure you have the following installed:

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK: Installed automatically with Flutter.
- Android Studio (or another IDE of your choice).
- Xcode (for iOS development) - **not officially supported**.

### Clone the repository

```bash
git clone https://github.com/damix00/taskbuddy-flutter
cd taskbuddy-flutter
```

### Install dependencies

In the root directory of the project, run:

```bash
flutter pub get
```

### Run the app

To run the app on an Android emulator or physical device:

```bash
flutter run
```

## Technologies Used

- **Flutter**: Cross-platform mobile framework for building natively compiled applications for mobile.
- **Firebase**: For notifications and remote config.
- **Provider**: State management solution for efficient data flow and UI updates.
- **OpenStreetView API**: For location-based features (e.g., displaying task locations).
