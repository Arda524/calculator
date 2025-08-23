# Flutter Calculator

A modern, feature-rich calculator app built with Flutter that provides basic arithmetic operations with a clean and intuitive user interface.

## Features

- **Basic Arithmetic Operations**: Addition (+), Subtraction (-), Multiplication (×), Division (÷)
- **Advanced Functions**: 
  - Percentage calculations (%)
  - Decimal point support
  - Double zero (00) input for faster entry
- **User Interface**:
  - Clean, modern design with rounded buttons
  - Real-time equation display
  - Large, easy-to-read result display
  - Responsive button layout
- **Functionality**:
  - Clear all (AC) function
  - Backspace (⌫) for correcting input
  - Error handling for invalid expressions
  - Fullscreen toggle mode
  - History menu (placeholder for future implementation)

## Screenshots

The calculator features a clean interface with:
- Display area showing both the current equation and result
- Number pad with digits 0-9
- Operation buttons with distinctive orange styling
- Function buttons for clear, backspace, and percentage

## Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd calculator
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

### Runtime Dependencies
- **flutter**: The Flutter SDK
- **math_expressions**: ^2.4.0 - For parsing and evaluating mathematical expressions
- **cupertino_icons**: ^1.0.8 - iOS-style icons

### Development Dependencies
- **flutter_test**: Flutter testing framework
- **flutter_lints**: ^5.0.0 - Recommended lints for Flutter projects

### Environment
- **Dart SDK**: ^3.7.2
- **Flutter**: Compatible with Flutter 3.7.2+

## Project Structure

```
calculator/
├── android/               # Android-specific files
├── ios/                   # iOS-specific files  
├── linux/                 # Linux-specific files
├── windows/               # Windows-specific files
├── lib/                   # Main Dart source code
│   ├── main.dart          # Main application entry point
│   ├── buttons/
│   │   └── button.dart    # Custom button widgets
│   └── history.dart       # History page (placeholder)
├── test/                  # Unit and widget tests
├── pubspec.yaml           # Project dependencies and metadata
├── pubspec.lock           # Locked dependency versions
├── analysis_options.yaml # Dart analysis configuration
├── .gitignore            # Git ignore rules
└── README.md             # Project documentation
```

## Ignored Files and Directories

This project uses a comprehensive `.gitignore` file to exclude:

### Build and Generated Files
- `build/` - Flutter build outputs
- `.dart_tool/` - Dart tooling cache
- `*.iml` - IntelliJ module files
- Generated plugin registrant files

### IDE and Editor Files
- `.idea/` - IntelliJ IDEA configuration
- `.vscode/` (optional) - VS Code configuration
- `.DS_Store` - macOS system files

### Platform-Specific Build Artifacts
- Android: `/android/app/debug`, `/android/app/profile`, `/android/app/release`
- iOS: DerivedData, Pods, xcuserdata, and other Xcode artifacts
- Windows/Linux: Generated plugin files

### Dependencies and Cache
- `.packages` - Package resolution cache
- `.pub-cache/` - Pub package cache
- `pubspec.lock` is tracked but build artifacts are ignored

### Custom Additions
- `.qodo/` - Qodo AI assistant files
- `.env*` - Environment configuration files
- `*.tmp`, `*.temp` - Temporary files

## Key Components

### Main Calculator (`main.dart`)
- Contains the main calculator logic and UI
- Handles button press events and calculations
- Manages state for equation display and results
- Implements error handling for invalid expressions

### Custom Buttons (`buttons/button.dart`)
- `CustomRawMaterialButton`: Standard number buttons
- `CustomRawMaterialButton2`: Operation buttons with orange styling
- `CustomRawMaterialButton3`: Equals button with filled orange background

### History Page (`history.dart`)
- Placeholder for calculation history feature
- Currently displays "Nothing To Show Here"

## How It Works

1. **Input Handling**: Users tap buttons to input numbers and operations
2. **Expression Building**: The app builds a mathematical expression string
3. **Real-time Display**: Shows both the current equation and result
4. **Calculation**: Uses the `math_expressions` package to parse and evaluate expressions
5. **Result Display**: Shows the calculated result with proper decimal handling

## Features in Detail

### Percentage Calculation
- Converts the last entered number to its percentage equivalent
- Works with both standalone numbers and numbers in expressions

### Smart Input Handling
- Prevents multiple consecutive operators
- Handles decimal point input validation
- Supports continuing calculations with previous results

### Error Handling
- Displays "Error" for invalid mathematical expressions
- Gracefully handles division by zero and other edge cases

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

## Future Enhancements

- [ ] Implement calculation history storage and display
- [ ] Add scientific calculator functions
- [ ] Theme customization options
- [ ] Memory functions (M+, M-, MR, MC)
- [ ] Keyboard input support
- [ ] Landscape mode optimization

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

If you encounter any issues or have suggestions for improvements, please create an issue in the repository.

---

Built with ❤️ using Flutter