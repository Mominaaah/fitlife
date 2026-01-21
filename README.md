# FitLife - Fitness Tracking Application

A comprehensive fitness tracking application built with Flutter and Firebase that helps users monitor their health, track workouts, and achieve their fitness goals.

## Table of Contents

- [About](#about)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Firebase Setup](#firebase-setup)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## About

FitLife is a cross-platform fitness tracking application designed to help users monitor their daily activities, track workout progress, and achieve their health and fitness goals. The app provides a comprehensive dashboard with real-time statistics, customizable fitness goals, and detailed progress tracking.

## Features

### Authentication & User Management
- Secure email/password authentication
- User registration with validation
- Password reset functionality
- Profile management with editable information

### Dashboard & Analytics
- Real-time fitness statistics
- Daily, weekly, and monthly views
- Visual progress charts
- Activity tracking (steps, heart rate, calories, sleep, water intake)
- Workout summary cards

### Workout Tracking
- Pre-defined workout plans
- Workout completion tracking
- Exercise details (sets, reps, rest time)
- Automatic calorie calculation
- Workout history with timestamps
- Difficulty levels (Beginner, Intermediate, Advanced)

### Health Data Monitoring
- Daily health metrics tracking
- Heart rate monitoring
- Step counter
- Water intake tracking
- Sleep duration tracking
- Weight monitoring
- Click-to-update functionality for all metrics

### Goal Setting & Progress
- Create custom fitness goals
- Goal types: Weight Loss, Muscle Gain, Maintain Weight
- Set target weight and timelines
- Daily targets (calories, steps, workouts per week)
- Visual progress tracking with percentage completion
- Update current weight to track progress
- Goal activation/deactivation

### Progress Analytics
- Comprehensive workout history
- Weekly activity breakdown
- Period-based statistics (Week/Month)
- Total calories burned
- Total active minutes
- Recent workout list with details
- Visual progress bars and charts

### Settings & Preferences
- Notification preferences (toggleable)
- Privacy and security settings
- Help and support resources
- Account management

## Tech Stack

### Frontend
- **Framework**: Flutter 3.35.6
- **Language**: Dart 3.9.2
- **UI Design**: Material 3
- **Typography**: Google Fonts (Inter)

### Backend
- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **Hosting**: Firebase Hosting (Web)

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.13.6
```

## Installation

### Prerequisites
- Flutter SDK 3.35.6 or higher
- Dart SDK 3.9.2 or higher
- Firebase account
- Git

### Setup Steps

1. Clone the repository
```bash
git clone https://github.com/yourusername/fitlife.git
cd fitlife
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase (see Firebase Setup section below)

4. Run the application
```bash
# For Web
flutter run -d chrome

# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Windows
flutter run -d windows
```

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add Project"
3. Enter project name (e.g., "fitlife")
4. Follow the setup wizard

### 2. Enable Authentication

1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. Click **Save**

### 3. Create Firestore Database

1. Go to **Firestore Database**
2. Click **Create database**
3. Select **Start in test mode** (for development)
4. Choose your preferred location
5. Click **Enable**

### 4. Configure Firebase for Your Platform

#### Web Configuration

Update `lib/main.dart` with your Firebase credentials:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID",
  ),
);
```

Get these values from:
- Firebase Console → Project Settings → General → Your apps → Web app

#### Android Configuration

1. Download `google-services.json`
2. Place it in `android/app/`

#### iOS Configuration

1. Download `GoogleService-Info.plist`
2. Place it in `ios/Runner/`

### 5. Set Firestore Security Rules

Go to **Firestore Database** → **Rules** tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /workouts/{workoutId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    match /health_data/{dataId} {
      allow read, write: if request.auth != null && request.resource.data.userId == request.auth.uid;
    }
    
    match /goals/{goalId} {
      allow read, write: if request.auth != null && request.resource.data.userId == request.auth.uid;
    }
  }
}
```

Click **Publish**

## Project Structure

```
lib/
├── main.dart                           # Application entry point
├── core/                               # Core functionality
│   └── theme/
│       └── app_theme.dart             # Theme and color definitions
│
├── features/                           # Feature modules
│   ├── auth/                          # Authentication
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   └── widgets/
│   │       └── custom_text_field.dart
│   │
│   ├── home/                          # Dashboard
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── stat_card.dart
│   │       ├── tab_button.dart
│   │       ├── bar_chart.dart
│   │       └── update_health_dialog.dart
│   │
│   ├── workouts/                      # Workout features
│   │   ├── screens/
│   │   │   ├── workouts_screen.dart
│   │   │   └── workout_detail_screen.dart
│   │   ├── widgets/
│   │   │   ├── workout_card.dart
│   │   │   ├── exercise_card.dart
│   │   │   └── info_chip.dart
│   │   ├── models/
│   │   │   ├── workout_model.dart
│   │   │   ├── exercise_model.dart
│   │   │   └── workout_session_model.dart
│   │   └── services/
│   │       └── workout_service.dart
│   │
│   └── profile/                       # User profile & settings
│       ├── screens/
│       │   ├── profile_screen.dart
│       │   ├── edit_profile_screen.dart
│       │   ├── goals_screen.dart
│       │   ├── create_goal_screen.dart
│       │   ├── my_progress_screen.dart
│       │   ├── health_data_screen.dart
│       │   ├── notifications_screen.dart
│       │   ├── privacy_security_screen.dart
│       │   └── help_support_screen.dart
│       ├── widgets/
│       │   ├── profile_stat_card.dart
│       │   └── profile_menu_item.dart
│       ├── models/
│       │   ├── user_model.dart
│       │   ├── health_data_model.dart
│       │   └── goal_model.dart
│       └── services/
│           ├── user_service.dart
│           ├── health_service.dart
│           └── goal_service.dart
│
└── shared/                            # Shared components
    └── widgets/
        └── main_screen.dart           # Bottom navigation
```

## Usage

### Getting Started

1. **Create an Account**
   - Launch the app
   - Complete onboarding screens
   - Click "Sign Up"
   - Enter your details (name, email, password)
   - Click "Sign Up"

2. **Update Your Profile**
   - Go to Profile tab
   - Click "Edit Profile"
   - Enter your weight, height, and age
   - Click "Save Changes"

3. **Set a Fitness Goal**
   - Go to Profile tab
   - Click "My Goals"
   - Click "Create Goal"
   - Select goal type (Weight Loss/Muscle Gain/Maintain)
   - Enter current and target weight
   - Set daily targets
   - Click "Create Goal"

4. **Track Health Metrics**
   - Go to Home tab (Dashboard)
   - Click on any stat card (Heart, Steps, Water, Sleep)
   - Enter your value
   - Click "Update"

5. **Complete Workouts**
   - Go to Workouts tab
   - Select a workout plan
   - Review exercises
   - Click "Complete Workout"
   - Your progress is automatically saved

6. **View Progress**
   - Go to Profile tab
   - Click "My Progress"
   - Toggle between Week/Month view
   - See your workout history and statistics

## Data Storage

### Firestore Collections

| Collection | Description | Fields |
|------------|-------------|--------|
| `users` | User profiles | uid, name, email, weight, height, age, createdAt, updatedAt |
| `workouts` | Completed workout sessions | id, userId, workoutName, duration, caloriesBurned, completedAt, exercises |
| `health_data` | Daily health metrics | id, userId, date, steps, heartRate, waterIntake, sleepMinutes |
| `goals` | Fitness goals | id, userId, goalType, currentWeight, targetWeight, targetCalories, targetSteps, targetWorkoutsPerWeek |

### Data Security

- All data is protected by Firestore security rules
- Users can only access their own data
- Authentication required for all operations
- Secure email/password authentication with Firebase

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Guidelines

- Follow Dart and Flutter best practices
- Use meaningful variable and function names
- Add comments for complex logic
- Test your changes thoroughly
- Maintain consistent code formatting

## Troubleshooting

### Common Issues

**Firebase initialization error on web:**
- Ensure you've added your Firebase config in `main.dart`
- Check that all Firebase credentials are correct

**Firestore index error:**
- Click the link in the error message to create the required index
- Wait 2-3 minutes for the index to build

**Email not updating:**
- Logout and login again before changing email
- Firebase requires recent authentication to change email

**Data not showing on dashboard:**
- Complete at least one workout to see data
- Update health metrics by clicking on stat cards
- Pull down to refresh the screen

## License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2024 FitLife

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Contact

**Developer:** Momina Ramzan

**Email:** mominaramzaan@gmail.com
---

Made with Flutter and Firebase
