import ProjectDescription

let config = Config(
  plugins: [
    .local(path: .relativeToRoot("Plugins/DependencyPlugin")),
    .local(path: .relativeToRoot("Plugins/EnvironmentPlugin")),
  ]
)
