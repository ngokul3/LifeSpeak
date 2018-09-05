//
//  AppDelegate.swift
//  LifeSpeak_Youtube
//
//  Created by Gokul K Narasimhan on 8/28/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit

var AppDel: AppDelegate {
    get {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var netModel = NetworkModel.getInstance()
    private var videoModelManager = VideoContentManager()
    var window: UIWindow?
    
    var networkModel: NetworkProtocol {
        get {
            return netModel
        }
    }
    
    var videoManager: VideoContentManagerProtocol{
        get{
            return videoModelManager
        }
    }
    
}

