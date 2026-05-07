# Foodie Finder

Flutter app with Firebase Authentication and Firestore persistence for:
- user login/signup
- profile data
- booking history
- order history

## Firebase Integration Setup (Required)

### 1. Create Firebase project
1. Go to Firebase Console.
2. Create project.
3. Enable:
   - Authentication
   - Cloud Firestore

### 2. Enable auth methods
In Authentication -> Sign-in method:
- Enable Email/Password
- Enable Phone

### 3. Add Android app
1. Register Android app with package name:
   - `com.example.foodie_finder` (or update app id and match it here)
2. Download `google-services.json`
3. Put file at:
   - `android/app/google-services.json`

### 4. Add iOS app (if running on iOS)
1. Register iOS app.
2. Download `GoogleService-Info.plist`
3. Put file in:
   - `ios/Runner/GoogleService-Info.plist`
4. Ensure plist is added to Runner target in Xcode.

### 5. Install and run
```bash
flutter pub get
flutter run
```

## Firestore Rules (Dev)
Use these temporary rules during development:
```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Notes
- If Firebase files are missing, app initializes but Firebase features remain inactive.
- Phone OTP requires valid phone auth configuration in Firebase Console.
