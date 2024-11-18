import EnvironmentPlugin
import Foundation
import ProjectDescription

private let isCI = ProcessInfo.processInfo.environment["TUIST_CI"] != nil

public extension Project {
  static func makeModule(
    name: String,
    targets: [Target],
    packages: [Package] = []
  ) -> Project {
    let settingConfiguration: [Configuration] =
    if isCI { [.debug(name: .debug)] }
    else { [.debug(name: .debug, xcconfig: Path.relativeToXCConfig("Server/Debug")),
            .release(name: .release, xcconfig: Path.relativeToXCConfig("Server/Release"))] }

    let settings: Settings = .settings(
      base: [
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
        "SWIFT_EMIT_LOC_STRINGS": "YES",
        "OTHER_LDFLAGS": [
          "-ObjC",
          "-lc++",  // Realm은 C++ 라이브러리를 필요로 함
          "-lz",
          "-framework Realm",
          "-framework RealmSwift"
        ]

      ],
      configurations: settingConfiguration
    )

    let schemes: [Scheme] = [.makeScheme(name: name)]

    return Project(
      name: name,
      organizationName: ProjectEnvironment.default.prefixBundleID,
      options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko",
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
      ),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  /// Scheme을 만드는 메소드
  static func makeScheme(name: String) -> Scheme {
    return Scheme.scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: .debug,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: .debug),
      archiveAction: .archiveAction(configuration: .release),
      profileAction: .profileAction(configuration: .debug),
      analyzeAction: .analyzeAction(configuration: .debug)
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
