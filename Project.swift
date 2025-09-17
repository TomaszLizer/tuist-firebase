import ProjectDescription

let project = Project(
    name: "tuist-firebase",
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
                ]
            ),
            buildableFolders: [
                "tuist-firebase/Sources",
                "tuist-firebase/Resources",
            ],
            dependencies: []
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
    ]
)
