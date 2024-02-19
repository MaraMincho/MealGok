import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ThirdParty",
  targets: .custom(
    name: "ThirdParty",
    product: .framework,
    dependencies: [
      .Realm,
      .RealmSwift,
      .imageManager,
      .commonExtensions,
    ],
    resources: "Resources/**"
  )
)
