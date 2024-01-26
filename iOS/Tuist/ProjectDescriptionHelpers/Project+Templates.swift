import ProjectDescription
import EnvironmentPlugin
import Foundation

private let isCI = ProcessInfo.processInfo.environment["TUIST_CI"] != nil
private let isDebug = ProcessInfo.processInfo.environment["TUIST_SCHEME"] == "DEBUG"

public extension Project {
  
  static func makeModule(
    name: String,
    targets: [Target],
    packages: [Package] = []
  ) -> Project {
    
    print("is Debug = \(isDebug)")
    
    let settingConfiguration: Configuration =
    if isCI { .debug(name: .debug) }
    else if isDebug { .debug(name: .debug, xcconfig: Path.relativeToRoot("XCConfig/server/Debug.xcconfig")) }
    else { .debug(name: .release, xcconfig: Path.relativeToXCConfig("Server/Relase")) }
    
    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: [settingConfiguration])
    
    let configurationName: ConfigurationName = isDebug || isCI ? .debug : .release
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

public extension Path {
  static func relativeToXCConfig(_ path: String = "Shared") -> Path {
    print("XCConfig/\(path).xcconfig")
    return .relativeToRoot("XCConfig/\(path).xcconfig")
  }
  static func relativeToXCConfigString(_ path: String = "Shared") -> String {
    return "XCConfig/\(path).xcconfig"
  }
}
