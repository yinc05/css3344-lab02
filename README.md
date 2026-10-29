# CSS3344 Lab 02 — UI Fundamentals and Layout

Student: PEIGI CHAI PEI YIN  
Student ID: BCS24090055

This project continues Lab 01. It retains the student's profile image and quote,
and adds reusable location sections, adaptive layouts and four interactive pickers.

## Run

1. Install Flutter (Dart SDK >= 3.10.1).
2. Run `flutter pub get`.
3. Open the project in Android Studio or run `flutter run` with an Android device.

For the isolated Exercise 2.1 output (student details and TitleSection only), run
`flutter run -t lib/exercise_2_1.dart`. The default `lib/main.dart` runs the complete
Lab 02 app with adaptive layouts and all four pickers.

## Requirements implemented

- `StudentDetailsSection`, `TitleSection`, `ImageSection` and `PickerSection` are reusable StatelessWidgets.
- `StudentProfileScreen` is a StatefulWidget that owns the selected date and role.
- `OrientationBuilder` uses a scrollable vertical layout in portrait and two scrollable columns in landscape.
- Material `showDatePicker` and Cupertino `CupertinoDatePicker` share one date.
- Material `DropdownButton<String>` and Cupertino `CupertinoPicker` share one role.
- Cupertino sheets open at the current value and provide Cancel/Done actions.
- Both date pickers accept dates from 1950 through today.

## Validation

`flutter analyze` and `flutter test`.
Widget tests cover role changes, orientation changes, wheel synchronization,
Material date selection, Cupertino date initialization and cancellation.

## Widget tree

StudentInfoApp (StatelessWidget)
└── MaterialApp
    └── StudentProfileScreen (StatefulWidget)
        └── Scaffold
            ├── AppBar
            └── SafeArea → OrientationBuilder
                ├── Portrait: ListView
                │   ├── StudentDetailsSection → Card → Column
                │   ├── Card → TitleSection (Row → Expanded → Column) + ImageSection
                │   └── PickerSection
                └── Landscape: Row
                    ├── Expanded → SingleChildScrollView → StudentDetailsSection
                    └── Expanded → ListView → location card + PickerSection

## Image attribution

`assets/images/lake.jpg` is from the official Flutter layout tutorial example:
https://github.com/flutter/website/tree/main/examples/layout/lakes/step6

Flutter layout reference: https://docs.flutter.dev/ui/layout

The project archive excludes generated `.dart_tool`, `build`, `.idea`, local SDK
paths, signing files and machine-specific Java settings.
