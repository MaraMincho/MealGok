
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ProfileFeature",
  targets: .feature(
    .profile,
    product: .framework,
    testingOptions: [.unitTest],
    dependencies: [
      .designSystem,
      .combineCocoa,
      .routerFactory,
      .sharedNotificationName,
      .thirdParty,
      .feature(.profileHamburger),
    ],
    testDependencies: [],
    resources: "Resources/**"
  )
)
