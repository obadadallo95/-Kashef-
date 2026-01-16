# Contributing to Kashef (كاشف)

Thank you for your interest in contributing to Kashef! This project is an open-source tool dedicated to digital rights and content safety. We welcome contributors from all backgrounds.

## Code of Conduct
By participating in this project, you agree to abide by our Code of Conduct. Please treat everyone with respect and kindness.

## How to Contribute

### Reporting Bugs
If you find a bug, please create an issue on GitHub with the following details:
- **Description**: What happened?
- **Steps to Reproduce**: How can we see the bug ourselves?
- **Expected Behavior**: What should have happened?
- **Screenshots/Logs**: Any visual aids or error logs.

### Suggesting Features
We welcome ideas for new features, especially improvements to the content analysis logic (e.g., new words to flag).
- Open an issue with the tag `enhancement`.
- Explain why this feature is important for user safety or privacy.

### Development Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/kashef.git
    cd kashef
    ```

2.  **Environment Variables:**
    **Critical:** You must create a `.env` file in the root directory to run the app locally.
    ```bash
    cp .env.example .env
    ```
    Populate `.env` with your own API keys (e.g., Gemini API, Local Auth secrets, etc.).

3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Run the App:**
    ```bash
    flutter run
    ```

## Coding Standards
- Follow the **Clean Architecture** structure used in the project.
- Use `flutter_riverpod` for state management.
- Ensure all new UI text is localized in `assets/translations/ar.json` and `assets/translations/en.json`.
- Run `flutter analyze` before submitting a Pull Request.

## Pull Requests
1.  Fork the repo and create your branch from `main`.
2.  Descriptive PR titles are helpful (e.g., `feat: Add new analysis rules`).
3.  Ensure your code builds and passes analysis.

Thank you for helping keep users safe!
