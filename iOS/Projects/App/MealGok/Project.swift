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
      "BGTaskSchedulerPermittedIdentifiers": "com.maramincho.mealgok",
      "CFBundleShortVersionString": "1.1.1",
      "CFBundleVersion": "202403046",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
    ]
  ),
  packages: []
)
