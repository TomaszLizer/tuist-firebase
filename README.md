# tuist-firebase
This repository demonstrates how to integrate Firebase into an iOS project managed with [Tuist](https://tuist.io/).

## Firebase Integration (via Xcode SPM)
Firebase can be integrated by defining it as a remote package in the Tuist project manifest (`Project.swift`). Tuist then generates the Xcode project with the correct Swift Package Manager (SPM) configuration automatically.

## Firebase Integration (via Xcode SPM)
Firebase can also be integrated by defining it as a remote package in the Tuist project manifest (`Project.swift`). Tuist then generates the Xcode project with the correct Swift Package Manager (SPM) configuration automatically.

Steps to integrate Firebase via Xcode SPM with Tuist:

1. Add Firebase as a remote package in `Project.swift`:
   ```swift
    // Project.swift
    Project(
        [...]
        packages: [
            .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .exact("12.3.0"))
        ]
    )
   ```
2. Add the required Firebase products to your app target dependencies, e.g.:
   ```swift
    // Project.swift
    Project(
        [...]
        targets: [
            .target(
                [...]
                dependencies: [
                    .package(product: "FirebaseCrashlytics")
                ]
            )
        ]
    )
   ```
3. Place your `GoogleService-Info.plist` in `tuist-firebase/Resources/Firebase/` so it is bundled with the app.
4. The project uses `dwarfWithDsym` for debug info to generate dSYM files for symbolication:
    ```swift
    // Project.swift
    let baseSettings = SettingsDictionary()
        .debugInformationFormat(.dwarfWithDsym)
    let projectSettings = Settings.settings(base: baseSettings)
    let project = Project(
        name: "tuist-firebase",
        settings: projectSettings,
    [...]
    ```
5. A post-build script uploads dSYM files to Crashlytics automatically:
   ```swift
    // Project.swift
    Project(
        [...]
        targets: [
            .target(
                [...]
                scripts: [
                    .post(
                        script: """
                        ${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run
                        """,
                        name: "Upload Symbols to Crashlytics",
                        inputPaths: [
                            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
                            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
                            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
                            "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
                            "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
                        ]
                    )
                ]
            )
        ]
    )
   ```
6. Run `tuist generate` to produce the Xcode project. Tuist will handle SPM setup for you.

### Note
This method uses standard Xcode SPM for third party dependency integration. By using such we lose most benefits of Tuist and this is not the recommended method.

# References
- [Firebase Crashlytics iOS documentation](https://firebase.google.com/docs/crashlytics/get-started?platform=ios)
- [Tuist documentation](https://docs.tuist.io/).
