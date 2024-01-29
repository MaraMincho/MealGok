import ProjectDescription

public struct ProjectEnvironment {
  public let appName: String
  public let targetName: String
  public let prefixBundleID: String
  public let deploymentTarget: DeploymentTarget
  public let baseSetting: SettingsDictionary

  private init(appName: String, targetName: String, prefixBundleID: String, deploymentTarget: DeploymentTarget, baseSetting: SettingsDictionary) {
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
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone, supportsMacDesignedForIOS: true),
      baseSetting: [:]
    )
  }
}
