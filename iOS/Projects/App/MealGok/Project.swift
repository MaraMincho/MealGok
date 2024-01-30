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
      .feature(.mealTimer)
    ],
    infoPlist: [:]
  ),
  packages: []
)
