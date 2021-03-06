//
//  DialogsCollectionViewController.swift
//  VKMusic
//
//  Created by Robert on 14.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit
import CoreData
import ESTMusicIndicator

class DialogCollectionViewController: UIViewController {
    
    let sendMessageView = SendMessageContainerView()
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let reuseIdentifier = "cellDialog"
    var music = Music()
    var dialogs: [Dialog]?
    
    var ids = [Int]()
    
    var fetchResultC = CoreDataManager.shared.initFetchResultController(enityNmae: "Dialog", sortKey: "firstName")
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

               
        
        let fetchRequest = NSFetchRequest<Dialog>(entityName: "Dialog")
        do {
            let result = try CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if result.isEmpty {
                NetworkHelper.shared.getDialogs {
                }
            } else {
                try fetchResultC.performFetch()
                dialogs = fetchResultC.fetchedObjects as? [Dialog]
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        view.layer.cornerRadius = 30
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(target:)))
        gesture.delegate = self
        
        self.view.addGestureRecognizer(gesture)
        sendMessageView.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: 100)
        view.addSubview(sendMessageView)
        sendMessageView.isHidden = true
//         Do any additional setup after loading the view.
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            let frame = self.view.frame
            let yComp = UIScreen.main.bounds.height - 150
            self.view.frame = CGRect(x: 0, y: yComp, width: frame.width, height: frame.height - 100)
        }
    }
    
    
    @objc func panGesture(target: UIPanGestureRecognizer) {
        let translation = target.translation(in: self.view)
        let velocity = target.velocity(in: self.view)
        let y = self.view.frame.minY
        
        let p = UIScreen.main.bounds.height - 150
        
        if (y + translation.y >= 200) && (y + translation.y <= p) {
            view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            target.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if target.state == .ended {
            var duration = velocity.y < 0 ? Double((y - 100) / -velocity.y) : Double((p - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: {
                if velocity.y  >=  0 {
                    self.view.frame = CGRect(x: 0, y: p + 200, width: self.view.frame.width, height: self.view.frame.height)
                    self.removeFromParent()
                    self.view.removeFromSuperview()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBlurView"), object: nil)
                } else {
                    self.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }) { (_) in
                if (velocity.y < 0) {
                    self.collectionView.isScrollEnabled = true
                }
            }
        }
    }
    
    @objc func sendMessage() {
        guard let text = sendMessageView.inputMessage.text else { return }
        NetworkHelper.shared.sendMessages(ids: ids, randomId: String(music.date+1000), message: text, attachment: "audio\(music.ownerId)_\(music.id)")
        UIView.animate(withDuration: 0.8) {
            self.view.frame = CGRect(x: 0, y:  UIScreen.main.bounds.height - 150 + 200, width: self.view.frame.width, height: self.view.frame.height)
            self.removeFromParent()
            self.view.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBlurView"), object: nil)
        }
        sendMessageView.inputMessage.text = nil
    }
    
}


// MARK: UICollectionViewDataSource
extension DialogCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchResultC.sections else { return 0 }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DialogCollectionViewCell {
            guard let item = dialogs?[indexPath.row] else { return UICollectionViewCell() }
            cell.setup(item)
            
            return cell
            
        }
        return UICollectionViewCell()
    }
    
}


//MARK: UICollectionViewDelegate
extension DialogCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DialogCollectionViewCell
        if sendMessageView.isHidden {
            sendMessageView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                cell?.selectedCellImageView.isHidden = false
                cell?.dialogImageView.layer.borderWidth = 4.0
                cell?.dialogImageView.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                self.ids.append(Int(self.dialogs![indexPath.row].id))
                self.sendMessageView.frame.origin.y -= 200
                
            }
        } else {
            if !(cell?.selectedCellImageView.isHidden)! {
                UIView.animate(withDuration: 0.5) {
                    cell?.selectedCellImageView.isHidden = true
                    cell?.dialogImageView.layer.borderWidth = 0.0
                    if let index = self.ids.index(of: Int(self.dialogs![indexPath.row].id)) {
                        self.ids.remove(at: index)
                        if self.ids.isEmpty {
                            self.sendMessageView.frame.origin.y += 200
                            self.sendMessageView.isHidden = true
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    cell?.selectedCellImageView.isHidden = false
                    cell?.dialogImageView.layer.borderWidth = 4.0
                    cell?.dialogImageView.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                    self.ids.append(Int(self.dialogs![indexPath.row].id))
                }
            }
            
        }
    }
    
}

//MARK: UIGestureRecognizerDelegate
extension DialogCollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { 
        let gestureR = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gestureR.velocity(in: self.view).y
        
        let y = view.frame.minY
        
        if (y == 100 && collectionView.contentOffset.y == 0 && direction > 0) || (y ==  UIScreen.main.bounds.height - 150) {
            collectionView.isScrollEnabled = false
        } else {
           
            collectionView.isScrollEnabled = true
        }
        
        return false
    }
}
