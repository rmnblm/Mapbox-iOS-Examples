//
//  AppDelegate.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 25.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MGLAccountManager.setAccessToken(Bundle.main.valueFromPList(named: "Keys", key: "MAPBOX_ACCESS_TOKEN"))
        return true
    }
}

