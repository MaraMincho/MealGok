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
      "NSCameraUsageDescription": "밀꼭이 사진 또는 카메라에 접근하여, 밀꼭 챌린지 기록 등 기능을 사용하기 위해 카메라에 접근하는 것을 허용합니다.",
      "BGTaskSchedulerPermittedIdentifiers": "com.maramincho.mealgok",
      "CFBundleShortVersionString": "1.1.1",
      "CFBundleVersion": "202403049",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
    ]
  ),
  packages: []
)
