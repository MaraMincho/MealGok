import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: ProjectEnvironment.default.appName,
  targets: .app(
    name: ProjectEnvironment.default.appName,
    entitlements: nil,
    dependencies: [
      .designSystem,
      .routerFactory,
      .sharedNotificationName,
      .feature(.profile),
      .feature(.mealTimer),
    ],
    infoPlist: [
      "NSCameraUsageDescription": "카메라에 접근합니다",
      "BGTaskSchedulerPermittedIdentifiers": "com.maramincho.mealgok",
      "CFBundleShortVersionString": "0.0.2",
      "CFBundleVersion": "0.0.2",
      "UIUserInterfaceStyle": "Light",
    ]
  ),
  packages: []
)
