# Campus Circle - Flutter Signup Form Quest

**Course:** MAD 4360 - Mobile App Development  
**Activity:** In-Class Activity 10: Flutter Signup Form Quest  
**Track:** Graduate  
**Completed tasks:** Task A (Local Signup Tip Simulation) and Task C (Confirm & Celebrate)  
**Team members:** Harshit Jain and **[ADD SECOND PARTNER'S FULL NAME]**

## Project Overview

Campus Circle is a Flutter demo signup application for a pretend student community. A user can enter a name, email, password, and confirmation password. The app checks the fields locally and shows a personalized welcome message when the form is valid. It does not create or store a real account.

The app also includes a Local Signup Coach that displays preset password tips. The coach works with fixed data stored in the application, not a live AI model or external server.

## Implemented Features

- Four form fields: Full Name, Email Address, Password, and Confirm Password.
- Required-field validation for all four fields.
- Email-format check, minimum six-character password check, and matching-password check.
- A password visibility toggle.
- Personalized green success SnackBar using the name entered in the form.
- A custom purple Material Design theme with a scrollable, width-constrained layout.
- Local Signup Coach with preset tips, a short loading state, and a clear **"Preset demo tip—not live AI"** label.
- Simulated local error and missing-tip cases, each with a Retry button.
- Local tip text limited to 240 characters.
- No form values are passed to the tip feature.

## Form Design and Validation

The signup page is a `StatefulWidget` because it needs to respond to user input and changes in the tip display. A `Form` is linked to a `GlobalKey<FormState>` so pressing **Sign Up** can run the field validators together.

The name must not be blank. The email must follow a basic email pattern. The password must have at least six characters, and the confirmation must match the original password. When all validators pass, a green SnackBar displays a message such as **"Welcome, Harry! Demo signup completed successfully."**

The controllers are disposed of when the signup page is removed. The demonstration does not send or store passwords.

## Task A: Local Signup Tip Simulation

**Fixed category:** `password_help`

The app stores a small list of password tips locally. When the user selects **Get a signup tip**, it first shows a loading state, then selects a preset tip in a repeatable order. The result is plain text, labeled as preset demo content rather than live AI output.

For error testing, the app provides **Test local error** and **Test missing tips** buttons. These cause a simulated failure or empty-data result. The error card displays a **Retry** action, which starts the normal local lookup again. The tip feature does not examine the name, email, password, or confirmation fields and never decides whether signup is valid.

## Task C: Confirm & Celebrate

The **Confirm Password** field must exactly match the **Password** field. A mismatch displays **"Passwords do not match"** and prevents the success message. When all validation checks pass, the app displays a welcome message using the entered name.

## Testing and Evidence

The following outcomes are visible in screenshots captured while running the app:

| Test case | Expected result | Observed result | Status |
| --- | --- | --- | --- |
| Empty required fields | Required-field messages | Messages shown below the empty fields | Passed |
| Email without `@` | Invalid email message | "Please enter a valid email" displayed | Passed |
| Password shorter than six characters | Password-length message | Minimum six-character error displayed | Passed |
| Confirmation different from password | Block signup and show mismatch | "Passwords do not match" displayed | Passed |
| Valid details and matching passwords | Personalized signup feedback | Green welcome SnackBar displayed | Passed |
| Request a preset tip | Display a labeled tip | Local password tips shown with demo label | Passed |
| Simulate missing tips | Display an error and Retry | Missing-tip error card and Retry visible | Passed |
| Simulate a local error | Display an error and Retry | Local error card and Retry visible | Passed |
| Tap Retry after an error | Return to successful local tip | **[RECORD RESULT AFTER TESTING]** | Not yet documented |
| Observe loading indicator | Show loading before result | **[RECORD RESULT AFTER TESTING]** | Not yet documented |
| Request tip while offline | Continue working without network | **[RECORD RESULT AFTER TESTING]** | Not yet documented |

Screenshots can be added to a `screenshots/` folder in this repository. Only include images of the demo app and avoid exposing real personal information.

## Graduate Reflection - Harshit Jain

### 1. Identify one privacy boundary in the local tip feature. What information does it keep out of the feature, and why?

The signup tip feature only uses the fixed `password_help` category and the preset tips inside the app. It does not read the name, email, password, or confirm-password fields. This separation matters because a simple help feature has no reason to access someone's private signup details. It also keeps the tips independent from the form validation.

### 2. What should the UI do when local tip data is empty or missing? Explain your error and retry behavior.

When tip data is missing, the app displays a clear error instead of showing an empty area or pretending it found a tip. The user can see a Retry button below the message. The demo includes a button to reproduce this case, which makes it easier to check the error screen. Retry starts another local lookup, and the normal preset tips remain available afterward.

### 3. Why should preset tips be clearly labeled and kept separate from form validation?

The tips are fixed messages, not answers generated by a real AI system. The label tells users exactly what the feature is doing, so they do not mistake it for a live service. The signup form uses its own validators to check entered information. A suggestion about passwords should never approve or reject a signup by itself.

### Design trade-off and improvement

Using local preset tips is simple, private, and reliable even without internet access, but the advice is limited to a small set of fixed messages. A useful future improvement would be to organize more tips by topic and add automated tests for each category and failure state. I would keep the tip data separate from personal form input.

### Individual contribution

**[EDIT TO DESCRIBE YOUR ACTUAL WORK AND TESTS, NOT JUST THE SHARED APP FEATURES.]**

## Graduate Reflection - [SECOND PARTNER'S NAME]

Each student must provide **three individual answers of 3-5 sentences** to any three graduate reflection questions from the activity. Add the second partner's own observations here.

### Question 1: [Chosen question]

[Second partner's own answer]

### Question 2: [Chosen question]

[Second partner's own answer]

### Question 3: [Chosen question]

[Second partner's own answer]

### Design trade-off and improvement

[Second partner's own trade-off and suggested improvement]

### Individual contribution

[Second partner's actual work and tests]

## How to Run

Requirements: Flutter SDK and a supported device or emulator.

From the project directory:

```bash
flutter pub get
flutter run
```

To check the code and run available tests:

```bash
dart format lib
flutter analyze
flutter test
```

> Note: If the original generated `test/widget_test.dart` still tests Flutter's counter demo, replace it with tests relevant to this signup screen before reporting that the automated test suite passes.

## Building the Android APK

Run the preferred release build from the project root:

```bash
flutter build apk --release
```

Expected output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

If release building is blocked, the activity permits a debug APK:

```bash
flutter build apk --debug
```

Expected debug output:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

**APK build verification:** **[ADD THE ACTUAL BUILD RESULT AFTER RUNNING THE COMMAND.]**

## Limitations

This is a classroom demonstration. It does not create accounts, save credentials, use a backend, or connect to a live AI service. Its email check is a basic format check, not proof that an address exists. The tips are stored locally and are general guidance, not a guarantee of password security.

## Submission

Submit the public GitHub repository URL and the successfully generated Android APK together, according to the course instructions. Make sure both partners can explain their individual contributions and the main validation and local-tip code paths.
