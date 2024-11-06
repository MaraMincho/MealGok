import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ThirdParty",
  targets: .custom(
    name: "ThirdParty",
    product: .framework,
    dependencies: [
      .external(name: "RealmSwift"),
      .external(name: "Realm"),
      .MealGokCacher,
      .commonExtensions,
    ],
    resources: "Resources/**"
  ),
  packages: [
    .package(url: "https://github.com/realm/realm-swift.git", from: "10.46.0"),
  ]
)
