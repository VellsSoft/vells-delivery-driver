# Contributing to Vells Delivery Driver App

First off, thank you for considering contributing to Vells Delivery! It's people like you that make this app better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples to demonstrate the steps**
* **Describe the behavior you observed after following the steps**
* **Explain which behavior you expected to see instead and why**
* **Include screenshots if possible**
* **Include your environment details** (OS, Flutter version, device, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a step-by-step description of the suggested enhancement**
* **Provide specific examples to demonstrate the steps**
* **Describe the current behavior and explain the behavior you expected to see**
* **Explain why this enhancement would be useful**

### Pull Requests

* Fill in the required template
* Do not include issue numbers in the PR title
* Follow the Dart/Flutter style guide
* Include screenshots and animated GIFs in your pull request whenever possible
* End all files with a newline
* Avoid platform-dependent code

## Development Setup

1. **Fork and clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/delivery_boy.git
cd delivery_boy
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Create a branch**
```bash
git checkout -b feature/your-feature-name
```

4. **Make your changes**
   - Write clean, readable code
   - Follow Flutter best practices
   - Add comments for complex logic
   - Update documentation if needed

5. **Test your changes**
```bash
flutter test
flutter analyze
```

6. **Commit your changes**
```bash
git add .
git commit -m "Add: Brief description of your changes"
```

Use conventional commit messages:
- `Add:` for new features
- `Fix:` for bug fixes
- `Update:` for updates to existing features
- `Remove:` for removing code/files
- `Docs:` for documentation changes

7. **Push to your fork**
```bash
git push origin feature/your-feature-name
```

8. **Create a Pull Request**

## Style Guide

### Dart Code Style

* Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
* Use `flutter format` before committing
* Maximum line length: 80 characters
* Use meaningful variable and function names
* Add comments for complex logic

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

### Flutter Best Practices

* Use `const` constructors where possible
* Avoid deep widget trees - extract widgets into separate classes
* Use meaningful widget names
* Handle errors gracefully
* Add loading states for async operations
* Use proper state management

## Project Structure

```
lib/
├── main.dart              # App entry point
├── screens/               # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── order_detail_screen.dart
└── services/              # Business logic
    └── api_service.dart
```

## Testing

* Write unit tests for business logic
* Write widget tests for UI components
* Ensure all tests pass before submitting PR
* Aim for >80% code coverage

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Documentation

* Update README.md if you change functionality
* Add inline comments for complex code
* Update CHANGELOG.md for notable changes
* Document all public APIs

## Questions?

Feel free to open an issue with your question or contact the maintainers directly.

## Recognition

Contributors will be recognized in the project README and release notes.

Thank you for contributing! 🎉
