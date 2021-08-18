//
//  AppDelegate.swift
//  EcoCDN
//
//  Created by An Binh on 17/08/2021.
//

import UIKit
import SwarmCloudSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = SWCP2pConfig.defaultConfiguration()
        config.logLevel = SWCLogLevel.debug
        SWCP2pEngine.sharedInstance().start(token: "luK3-_tMR", p2pConfig: config)
        return true
    }

}

