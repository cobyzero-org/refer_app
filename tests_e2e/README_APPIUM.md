# Appium Testing for Flutter (Refer App)

This directory contains the E2E UI testing setup for the Refer App using **Appium** and **WebdriverIO**.

## Prerequisites

1.  **Node.js**: Ensure you have Node.js installed.
2.  **Appium Server**: Install Appium globally:
    ```bash
    npm install -g appium
    ```
3.  **Appium Drivers**:
    ```bash
    # For Android
    appium driver install --source=npm appium-flutter-driver
    # For iOS
    appium driver install xcuitest
    ```
4.  **Flutter Driver Extension**: The app must be built with the Flutter Driver extension enabled. I have already created `lib/main_test.dart` for this purpose.

## Setup

1.  Install dependencies:
    ```bash
    cd tests_e2e
    yarn install
    ```

2.  Build the app for testing:
    ```bash
    # iOS (Simulator)
    flutter build ios --debug --simulator -t lib/main_test.dart

    # Android
    flutter build apk --debug -t lib/main_test.dart
    ```

3.  Configure `wdio.conf.ts`:
    Ensure the `appium:app` path in `wdio.conf.ts` points to your built `.app` (iOS) or `.apk` (Android).

## Running Tests

1.  Start the Appium Server:
    ```bash
    appium
    ```

2.  Run the tests:
    ```bash
    cd tests_e2e
    npm test
    ```

## Writing Tests

Use `appium-flutter-finder` to find elements:
- `findByText('Some Text')`
- `findByValueKey('my_key')`
- `findByType('Text')`

Example:
```typescript
import { findByText } from 'appium-flutter-finder';
const el = findByText('Hello');
await $(el).click();
```
