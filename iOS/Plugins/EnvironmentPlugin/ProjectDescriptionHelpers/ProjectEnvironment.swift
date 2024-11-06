import ProjectDescription

public struct ProjectEnvironment {
  public let appName: String
  public let targetName: String
  public let prefixBundleID: String
  public let deploymentTarget: DeploymentTargets
  public let baseSetting: SettingsDictionary

  private init(appName: String, targetName: String, prefixBundleID: String, deploymentTarget: DeploymentTargets, baseSetting: SettingsDictionary) {
    self.appName = appName
    self.targetName = targetName
    self.prefixBundleID = prefixBundleID
    self.deploymentTarget = deploymentTarget
    self.baseSetting = baseSetting
  }

  public static var `default`: ProjectEnvironment {
    ProjectEnvironment(
      appName: "MealGok",
      targetName: "MealGok",
      prefixBundleID: "com.maramincho",
      deploymentTarget: .iOS("16.0"),
      baseSetting: [:]
    )
  }
}
