
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RouterFactory",
  targets: .custom(
    name: "RouterFactory",
    product: .staticLibrary
  )
)
