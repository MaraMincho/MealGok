
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ProfileHamburgerFeature",
  targets: .feature(
    .profileHamburger,
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
