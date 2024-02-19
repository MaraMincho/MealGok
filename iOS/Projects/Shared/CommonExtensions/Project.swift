
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CommonExtensions",
  targets: .custom(
    name: "CommonExtensions",
    product: .framework
  )
)

