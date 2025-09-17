import ProjectDescription

let baseSettings = SettingsDictionary()
    .debugInformationFormat(.dwarfWithDsym)
    .otherLinkerFlags(["-ObjC"])
let projectSettings = Settings.settings(base: baseSettings)

let project = Project(
    name: "tuist-firebase",
    settings: projectSettings,
    targets: [
        .target(
            name: "tuist-firebase",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.tuist-firebase",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                ]
            ),
            buildableFolders: [
                "tuist-firebase/Sources",
                "tuist-firebase/Resources",
            ],
            scripts: [
                .post(
                    script: """
                    Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run
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
            ],
            dependencies: [
                .external(name: "FirebaseCrashlytics")
            ]
        ),
        .target(
            name: "tuist-firebaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.tuist-firebaseTests",
            infoPlist: .default,
            buildableFolders: [
                "tuist-firebase/Tests"
            ],
            dependencies: [.target(name: "tuist-firebase")]
        ),
    ],
    schemes: [
        .scheme(
            name: "Tuist-Firebase-Debug",
            buildAction: .buildAction(targets: [.target("tuist-firebase")]),
            runAction: .runAction(
                configuration: .debug,
                arguments: .arguments(
                    launchArguments: [.launchArgument(name: "-FIRDebugEnabled", isEnabled: true)]
                )
            ),
        ),
    ]
)
