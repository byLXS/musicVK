//
//  VKDelegateExample.swift
//  VKMusic
//
//  Created by Robert on 20.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//
import UIKit
import SwiftyVK

final class VKDelegateExample: SwiftyVKDelegate {
    
    let appId = "6757585"
    let scopes: Scopes = [.messages,.offline]
    
    init() {
        VK.setUp(appId: appId, delegate: self)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        // This code works only for simplest cases and one screen applications
        // If you have application with two or more screens, you should use different implementation
        // HINT: google it - get top most UIViewController
        #if os(macOS)
        if let contentController = NSApplication.shared.keyWindow?.contentViewController {
            contentController.presentViewControllerAsSheet(viewController)
        }
        #elseif os(iOS)
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true)
        }
        #endif
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        let token = info["access_token"]
        let id = info["user_id"]
        
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(id, forKey: "id")
        VKApi.shared.token = token
        VKApi.shared.id = id
        print("token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
    
    
}
