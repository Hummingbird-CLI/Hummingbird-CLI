## Hummingbird CLI

[![codecov](https://codecov.io/github/Hummingbird-CLI/Hummingbird-CLI/graph/badge.svg?token=UN54CEP9GS)](https://codecov.io/github/Hummingbird-CLI/Hummingbird-CLI)
[![Discord](https://img.shields.io/discord/1154421984353067090)](https://discord.gg/3aENy3Xvdk)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter CLI tool to kickstart new projects.

---

## Getting Started 🚀

If the CLI application is available on [pub](https://pub.dev), activate globally via:

```sh
dart pub global activate hummingbird_cli
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Usage

```sh
# Sample command
$ hummingbird sample

# Sample command option
$ hummingbird sample --cyan

# Show CLI version
$ hummingbird --version

# Show usage help
$ hummingbird --help
```

## Running Tests with coverage 🧪

To run all unit tests use the following command:

```sh
$ dart pub global activate coverage 1.2.0
$ dart test --coverage=coverage
$ dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov)
.

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis