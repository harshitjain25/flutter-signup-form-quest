# Campus Circle

**MAD 4360 – Mobile App Development**  
**In-Class Activity 10: Flutter Signup Form Quest**  
**Track:** Graduate  
**Tasks:** Task A (Local Signup Tip Simulation) and Task C (Confirm & Celebrate)  
**Student:** Harshit Jain

## About the App

Campus Circle is a Flutter signup demo for a student community. The form asks for a full name, email address, password, and password confirmation. It checks the inputs before showing a welcome message with the user's name. This is a demo, so it doesn't create an actual account.

I also added a Local Signup Coach. It gives short password tips from a list saved in the app, without contacting a server or using a live AI model.

## Features

- A signup form with four fields and clear validation messages.
- Email format checking and a minimum password length of six characters.
- A confirm-password field that blocks signup if the passwords don't match.
- A show/hide password button and a welcome message using the entered name.
- A purple Material Design theme and a scrollable layout.
- Preset password tips with loading, success, error, and retry states.
- Buttons to demonstrate a local error and missing-tip situation.

## How It Works

### Signup Form

The signup screen is a `StatefulWidget` because the visible content changes as the user interacts with it. I use a `Form` with a `GlobalKey<FormState>` to run the field validators when **Sign Up** is pressed. Invalid input shows a message under the relevant field. If every field is valid and both passwords match, a green SnackBar welcomes the user by name.

The text controllers are disposed of when the page is removed. No account details are sent to a backend or stored by the app.

### Task A: Local Signup Tip Simulation

The fixed category is `password_help`. The app has three short tips stored locally and displays them in a repeatable order. Selecting **Get a signup tip** briefly shows a loading indicator before displaying a tip as plain text. The result is labeled **“Preset demo tip—not live AI”** and stays under 240 characters.

The **Test local error** and **Test missing tips** buttons demonstrate the failure states. The missing-tip button simulates unavailable data; it does not delete the stored tips. In both cases, the app shows an error and a **Retry** button. Retrying starts another lookup and can show a valid tip again.

The tip feature only uses its fixed category and stored tips. It does not read the name, email, password, or password confirmation, and it never decides whether the signup form is valid.

### Task C: Confirm & Celebrate

I added a **Confirm Password** field. If the two passwords are different, the form displays **“Passwords do not match”** and prevents successful submission. When the fields pass validation, the green SnackBar displays a message such as **“Welcome, Harry! Demo signup completed successfully.”**

## Testing

I tested the form and the Local Signup Coach, including the error and recovery paths.

| Test | Result |
| --- | --- |
| Submit with empty fields | Required-field messages appeared. Passed. |
| Enter an invalid email | Email validation message appeared. Passed. |
| Enter a password shorter than six characters | Password-length message appeared. Passed. |
| Enter different passwords | Mismatch message appeared and signup was blocked. Passed. |
| Enter valid details with matching passwords | Personalized green welcome message appeared. Passed. |
| Request a signup tip | A labeled preset tip appeared. Passed. |
| Observe loading before the tip | Loading state displayed. Passed. |
| Simulate a local error | Error message and Retry button appeared. Passed. |
| Simulate missing tips | Missing-tip message and Retry button appeared. Passed. |
| Retry after an error | Error cleared and a preset tip appeared. Passed. |
| Request a tip offline | The local tip feature continued working. Passed. |
| Run Flutter widget tests | Tests completed successfully. Passed. |

I also ran `flutter analyze`, which reported no issues. Screenshots captured during testing show the validation messages, welcome SnackBar, preset tips, and error states.

## Graduate Reflection

### 1. Identify one privacy boundary in the local tip feature. What information does it keep out of the feature, and why?

The signup tip feature uses only the fixed `password_help` category and the tips saved in the app. It does not read the name, email, password, or confirmation fields. This matters because the tips are general advice and don't need anyone's personal information. Keeping the two parts separate also makes the app easier to understand and test.

### 2. What should the UI do when local tip data is empty or missing? Explain your error and retry behavior.

If the tip data is missing, the app shows an error message instead of an empty result. A Retry button is displayed so the user can try again. I added a **Test missing tips** button to reproduce this case without removing the actual tips. After Retry, the app makes a normal local lookup and displays a preset tip.

### 3. Why should preset tips be clearly labeled and kept separate from form validation?

The tips are fixed messages, not responses from a live AI model. The label makes that clear to anyone using the app. Form validation is handled separately by the name, email, and password validators. A tip can help someone choose a password, but it should not decide whether their signup is accepted.

### Trade-off and Improvement

Using preset tips keeps the feature simple and usable without internet access. The downside is that it can only show a small number of general tips. I would improve it by adding more useful categories and writing more widget tests for the different tip states. I would still keep the tip feature separate from personal form data.

### My Contribution

I worked on this activity individually. I built and customized the signup screen, added form validation and password confirmation, and implemented the local tip feature with loading, error, and retry behavior. I tested the valid and invalid form cases, checked the tip recovery flow, ran Flutter checks, pushed the project to GitHub, and generated the Android release APK.

## Run the Project

Make sure Flutter is installed and a supported device or emulator is available. In the project directory, run:

```bash
flutter pub get
flutter run
```

To check the project:

```bash
flutter analyze
flutter test
```

## Android APK

I generated the release APK with:

```bash
flutter build apk --release
```

The generated file is located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Limitations

Campus Circle is a classroom demo, not a full registration system. It does not create accounts or save credentials. The email validator checks the format, not whether the address exists. The Local Signup Coach provides preset advice rather than personalized or live AI responses.
