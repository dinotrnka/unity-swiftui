//
//  UnityEmbeddedSwift.swift
//  SeptemberUIKit
//
//  Created by Dino Trnka on 23/09/2020.
//

import Foundation
import UnityFramework

class UnityEmbeddedSwift: UIResponder, UIApplicationDelegate, UnityFrameworkListener {

  private struct UnityMessage {
    let objectName: String?
    let methodName: String?
    let messageBody: String?
  }

  private static var instance: UnityEmbeddedSwift!
  private var ufw: UnityFramework!
  private static var hostMainWindow: UIWindow! //Window to return to when exitting Unity window
  private static var launchOpts: [UIApplication.LaunchOptionsKey: Any]?

  private static var cachedMessages = [UnityMessage]()

  static func getUnityView() -> UIView! {
    return instance.ufw.appController()?.rootView
  }

  static func getUnityRootview() -> UIViewController! {
    let unityViewController = instance.ufw.appController()?.rootViewController

    unityViewController?.hidesBottomBarWhenPushed = true // Hide bottom tab bar in Unity view

    unityViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "GASI", style: .plain, target: nil, action: nil)


    return unityViewController
  }

  static func setHostMainWindow(_ hostMainWindow: UIWindow?) {
    UnityEmbeddedSwift.hostMainWindow = hostMainWindow
    let value = UIInterfaceOrientation.landscapeLeft.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
  }

  static func setLaunchingOptions(_ launchingOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    UnityEmbeddedSwift.launchOpts = launchingOptions
  }

  static func showUnity() {
    if(UnityEmbeddedSwift.instance == nil || UnityEmbeddedSwift.instance.unityIsInitialized() == false) {
      UnityEmbeddedSwift().initUnityWindow()
    }
    else {
      UnityEmbeddedSwift.instance.showUnityWindow()
    }
  }

  static func hideUnity() {
    UnityEmbeddedSwift.instance?.hideUnityWindow()
  }

  static func unloadUnity() {
    UnityEmbeddedSwift.instance?.unloadUnityWindow()
  }

  static func sendUnityMessage(_ objectName: String, methodName: String, message: String) {
    let msg: UnityMessage = UnityMessage(objectName: objectName, methodName: methodName, messageBody: message)

    // Send the message right away if Unity is initialized, else cache it
    if(UnityEmbeddedSwift.instance != nil && UnityEmbeddedSwift.instance.unityIsInitialized()) {
      UnityEmbeddedSwift.instance.ufw.sendMessageToGO(withName: msg.objectName, functionName: msg.methodName, message: msg.messageBody)
    }
    else {
      UnityEmbeddedSwift.cachedMessages.append(msg)
    }
  }

  // Callback from UnityFrameworkListener
  func unityDidUnload(_ notification: Notification!) {
    ufw.unregisterFrameworkListener(self)
    ufw = nil
    UnityEmbeddedSwift.hostMainWindow?.makeKeyAndVisible()
  }

  // Private functions called within the class
  private func unityIsInitialized() -> Bool {
    return ufw != nil && (ufw.appController() != nil)
  }

  func initUnityWindow() {
    if unityIsInitialized() {
      showUnityWindow()
      return
    }

    ufw = UnityFrameworkLoad()!
    ufw.setDataBundleId("com.unity3d.framework")
    ufw.register(self)

    ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: UnityEmbeddedSwift.launchOpts)

    sendUnityMessageToGameObject()

    UnityEmbeddedSwift.instance = self
  }

  private func showUnityWindow() {
    if unityIsInitialized() {
      ufw.showUnityWindow()
      sendUnityMessageToGameObject()
    }
  }

  private func hideUnityWindow() {
    if(UnityEmbeddedSwift.hostMainWindow == nil) {
      print("WARNING: hostMainWindow is nil! Cannot switch from Unity window to previous window")
    }
    else {
      UnityEmbeddedSwift.hostMainWindow?.makeKeyAndVisible()
    }
  }

  private func unloadUnityWindow() {
    if unityIsInitialized() {
      UnityEmbeddedSwift.cachedMessages.removeAll()
      ufw.unloadApplication()
    }
  }

  private func sendUnityMessageToGameObject() {
    if(UnityEmbeddedSwift.cachedMessages.count >= 0 && unityIsInitialized())
    {
      for msg in UnityEmbeddedSwift.cachedMessages {
        ufw.sendMessageToGO(withName: msg.objectName, functionName: msg.methodName, message: msg.messageBody)
      }

      UnityEmbeddedSwift.cachedMessages.removeAll()
    }
  }

  private func UnityFrameworkLoad() -> UnityFramework? {
    let bundlePath: String = Bundle.main.bundlePath + "/Frameworks/UnityFramework.framework"

    let bundle = Bundle(path: bundlePath)
    if bundle?.isLoaded == false {
      bundle?.load()
    }

    let ufw = bundle?.principalClass?.getInstance()
    if ufw?.appController() == nil {
      // unity is not initialized

      let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
      machineHeader.pointee = _mh_execute_header

      ufw!.setExecuteHeader(machineHeader)
    }
    return ufw
  }
}
