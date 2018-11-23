//
//  ViewController.swift
//  VKMusic
//
//  Created by Robert on 10.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit
import SwiftyVK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: Action
    @IBAction func showAuth(_ sender: Any) {
        VK.sessions.default.logIn(
            onSuccess: { _ in
                DispatchQueue.global().async {
                    let token = UserDefaults.standard.value(forKey: "token")
                    let id = UserDefaults.standard.value(forKey: "id")
                    
                    VKApi.shared.token = token as? String
                    VKApi.shared.id = id as? String
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showAudio", sender: self)
                }
                
                
        },
            onError: { _ in
                let alertC = UIAlertController(title: "Ошибка", message: "Повторите попытку", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertC.addAction(action)
                self.present(alertC, animated: true, completion: nil)
        }
        )
    }
}






