
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ImageManager",
  targets: .custom(
    name: "ImageManager",
    product: .framework
  )
)
