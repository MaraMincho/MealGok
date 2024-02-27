import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: ProjectEnvironment.default.appName,
  targets: .app(
    name: ProjectEnvironment.default.appName,
    entitlements: .file(path: .relativeToApp("MealGok/MealGok.entitlements")),
    dependencies: [
      .designSystem,
      .routerFactory,
      .sharedNotificationName,
      .feature(.profile),
      .feature(.mealTimer),
    ],
    infoPlist: [
      "NSCameraUsageDescription": "카메라에 접근합니다",
      "CFBundleShortVersionString": "0.2.0",
      "CFBundleVersion": "0.2.0",
      "BGTaskSchedulerPermittedIdentifiers": "com.maramincho.mealgok",
      "CFBundleShortVersionString": "0.1.0",
      "CFBundleVersion": "0.1.0",
      "UIUserInterfaceStyle": "Light",
    ]
  ),
  packages: []
)
