import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ThirdParty",
  targets: .custom(
    name: "ThirdParty",
    product: .framework, 
    dependencies: [
      .Realm,
      .RealmSwift
    ],
    resources: "Resources/**"
  ),
  packages: [
    .remote(url: "https://github.com/realm/realm-swift",requirement: .upToNextMajor(from: "10.42.0"))
  ]
)
