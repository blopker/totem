# totem

## Requirements
- flutter
- xcode
- fastlane

## Release Mobile

1. Switch to 'main' branch.
1. Edit `pubspec.yaml` to increase the version number. At minimum bump the build number (after the `+`).
1. Create a commit with your changes.
1. Run `make release`.

## Release Web

1. Run `make build-web`
1. Run `make publish-web`