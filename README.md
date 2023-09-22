# Unlock'd bluetooth emulator

[![Unlock'd][logo_white]][unlockd_link_dark]
[![Unlock'd][logo_black]][unlockd_link_light]

Developed with 💙 by [Unlock'd][unlockd_link] 🔓

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter Starter Project created by the [Unlock'd Team][unlockd_link].

---

## Installation 💻

**❗ In order to start using Unlockd Bluetooth you must have the [Flutter SDK][flutter_install_link] installed on your
machine.**

Add `unlockd_bluetooth` to your `pubspec.yaml`:

```yaml
dependencies:
  unlockd_bluetooth:
```

Install it:

```sh
flutter packages get
```

---

## Continuous Integration 🤖

Unlockd Bluetooth comes with a built-in [GitHub Actions workflow][github_actions_link] powered
by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code
remains consistent and behaves correctly as you add functionality or make changes. The project
uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage
is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

For first time users, install the [unlockd_cli_link][unlockd_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[mason_link]: https://github.com/felangel/mason
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows

[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/Unlock-d/unlockd_brand/main/RGB/PNG/Logo_unlockd_color_tiber_x3.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/Unlock-d/unlockd_brand/main/RGB/PNG/Logo_unlockd_white_x3.png#gh-dark-mode-only
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[unlockd_cli_link]: https://github.com/Unlock-d/unlockd_cli
[unlockd_link_dark]: https://unlockd.be#gh-dark-mode-only
[unlockd_link]: https://unlockd.be
[unlockd_link_light]: https://unlockd.be#gh-light-mode-only