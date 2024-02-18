
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SharedNotificationName",
  targets: .custom(
    name: "SharedNotificationName",
    product: .framework
  )
)
