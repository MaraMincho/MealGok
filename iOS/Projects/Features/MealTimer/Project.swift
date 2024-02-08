
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "MealTimerFeature",
  targets: .feature(
    .mealTimer,
    product: .framework,
    testingOptions: [.unitTest],
    dependencies: [
      .designSystem,
      .routerFactory,
      .combineCocoa,
      .Realm,
      .RealmSwift,
    ],
    testDependencies: []
  )
)
