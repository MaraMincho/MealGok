import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin

public extension Project {
  
  static func makeModule(
    name: String,
    targets: [Target],
    packages: [Package] = []
  ) -> Project {
    //TODO: CI 나 Debug Relase일 때 Configuration을 다르게 설정해야 함
    let settingConfigurations: [Configuration] = [.debug(name: .debug)]
    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: settingConfigurations)
    
    let configurationName: ConfigurationName = .debug
    let schemes: [Scheme] = [.makeScheme(configuration: configurationName, name: name)]
    
    return Project(
      name: name,
      organizationName: ProjectEnvironment.default.prefixBundleID,
      options: .options(automaticSchemesOptions: .disabled, disableBundleAccessors: true, disableSynthesizedResourceAccessors: true),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  /// Scheme을 만드는 메소드
  static func makeScheme(configuration: ConfigurationName, name: String) -> Scheme {
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: configuration,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: configuration),
      archiveAction: .archiveAction(configuration: configuration),
      profileAction: .profileAction(configuration: configuration),
      analyzeAction: .analyzeAction(configuration: configuration)
    )
  }
}
