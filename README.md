# The Haunted Creature Registry

MAD 4360 Mobile App Development · In-Class Activity 11 · Graduate Track

Selected extension: **Task C — The Guarded Crypt**

A Halloween-themed Flutter registration demo extending the Activity 10 Campus Circle app. Register a creature through three connected screens, with dark purple backgrounds, orange accents, a typewriter welcome, and celebratory confetti. Registration is simulated locally; no account is created.

## Structure

```text
lib/
├── main.dart                  # App, global theme, initial screen
└── screens/
    ├── welcome_screen.dart    # Typewriter introduction and entry button
    ├── signup_screen.dart     # Form, date picker, local coach, submission guards
    └── success_screen.dart    # Personalized confirmation and confetti
```

`pubspec.yaml` and `pubspec.lock` include `animated_text_kit` and `confetti`. No `shared_preferences` or Task B persistence is used.

## Features and navigation

- Welcome → Signup uses `Navigator.push()`. Android Back from signup returns to the welcome foyer.
- Signup preserves the Activity 10 name, email, password, confirmation validators, and password visibility toggle. Passwords require at least six characters.
- A required creature dropdown offers Ghost, Bat, Black Cat, Pumpkin Spirit, and Witch.
- A required read-only Birth Date field opens `showDatePicker()`, with today as the latest permitted date.
- Valid registration disables the button and shows a progress indicator during a two-second simulated delay. The trimmed name and selected creature are passed through required constructor arguments.
- Signup → Success uses `Navigator.pushReplacement()`, removing the completed form. Success displays the name and creature and starts confetti once.
- Success intercepts system Back with `PopScope`. Both Back and **Back to the Foyer** open a fresh welcome route and clear the previous stack.
- The Local Signup Coach retains preset tips, loading, demo error/missing-data states, and retry. It does not read registration inputs or participate in validation.
- Scrollable, width-constrained layouts keep forms usable in smaller windows and with the keyboard open.

## Local state and Task C lifecycle protection

Signup keeps its controllers, nullable creature selection, selected date, and loading flags in widget state. All five text controllers are disposed. The coach has independent state and checks `mounted` after its delay.

Registration validates before setting a synchronous `_submissionStarted` guard. That guard remains set through navigation, so invoking a saved callback twice cannot start a second operation even before the disabled button rebuilds. Name and creature are captured before the delay. Afterward, the handler checks both `mounted` and whether the signup route is still current before navigating. The route check also handles a Back transition while the outgoing screen is still mounted. The delayed future can finish harmlessly after departure; it does not update state or navigate.

Success rejects empty or whitespace-only names or creature types without rendering registration information. A single post-frame callback redirects to a fresh welcome screen, avoiding navigation during build and redirect loops. Its `ConfettiController` starts once after the first frame and is disposed when the screen leaves.

## Run and verify

With Flutter installed and a supported device available:

```bash
flutter pub get
flutter run
```

```bash
dart format lib test
flutter analyze
flutter test
flutter build apk --release
```

Actual automated results on October 30, 2026, using Flutter 3.47.2 / Dart 3.13.2:

| Check | Result |
| --- | --- |
| `dart format lib test` | Completed successfully |
| `flutter analyze` | No issues found |
| `flutter test` | All 16 widget tests passed |
| `flutter build apk --release` | Succeeded; reported 49.7 MB APK |

APK: `build/app/outputs/flutter-apk/app-release.apk`.

Tests cover welcome/entry/Back navigation; all required fields; invalid email, short password, and mismatched confirmation; password visibility; a valid registration and its two-second loading state; duplicate callback protection; personalized success; both foyer return paths; four invalid success-data cases; leaving during loading and during the exit transition; compact layout with keyboard insets; and coach error/retry recovery. Success tests advance controlled frames instead of waiting for confetti to settle.

## Manual checks and limitations

Install the APK on an Android device or emulator and check physical/gesture Back behavior, keyboard scrolling, date selection/cancellation and future-date restriction, typewriter appearance, confetti, large text, landscape layout, and the coach's missing-tip/retry flow. Capture your own screenshots and observations for the Ghost Hunt Word document. No manual device testing or screenshots are claimed here.

This is a classroom demo with no backend, authentication, saved registrations, or age restriction. Email validation checks format only. Tips are fixed local messages, not live AI. The original Android signing configuration still uses the debug key for release builds; this APK is suitable for classroom testing, not a store release. Flutter Doctor reported unknown Android license status and duplicate adb installations, but the release build completed successfully. No Android device was connected during verification.

Work remains on `activity-11`; the Activity 10 implementation and README are preserved in Git history (pre-change commit `793c128`). Nothing was force-pushed or pushed automatically.
