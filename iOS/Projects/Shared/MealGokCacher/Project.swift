
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "MealGokCacher",
  targets: .custom(
    name: "MealGokCacher",
    product: .framework
  )
)
