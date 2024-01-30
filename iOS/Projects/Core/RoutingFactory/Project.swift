
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RoutingFactory",
  targets: .custom(
    name: "RoutingFactory",
    product: .staticFramework
  )
)
