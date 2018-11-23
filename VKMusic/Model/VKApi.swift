//
//  VKApi.swift
//  VKMusic
//
//  Created by Robert on 08.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//


import Foundation
import SwiftyVK

class VKApi  {
    static let shared = VKApi()
    
    
    var session = URLSession(configuration: .default)
    var downloadTask: URLSessionDownloadTask?
    
    var id: String?
    var token: String?
    var isDownloading = false
    
    
    //MARK: API Method
    
    func getMusic(completion: @escaping ([Music]) -> Void) {
        guard let accessToken = token else { return }
        guard let userID = id else { return }

        let urlString = "https://api.vk.com/method/messages.getHistory?user_id=\(userID),count=100&v=5.87&access_token=\(accessToken)"
        
//        VK.API.Messages.getHistory([.count : "100", .userId: userID])
//            .onSuccess { (data) in
//                let array = self.parsingMusicData(data: data)
//                if array != nil {
//                    DispatchQueue.main.async {
//                        completion(array!)
//                    }
//                }
//            }
//            .onError {
//                print("SwiftyVK: Messages.getHistory failed with \n \($0)")
//
//
//            }.send()
        
        guard let urlStr = URL(string: urlString) else { return }

        let request = session.dataTask(with: urlStr) { (data, response, error) in
            print(Thread.current)
            if data != nil {

                let array = self.parsingMusicData(data: data!)
                if array != nil {
                    DispatchQueue.main.async {
                        completion(array!)
                    }
                }
            }
        }
        request.resume()
    }
    
    
    func getDialogs(completion: @escaping () -> Void) {
        guard let accessToken = token else { return }
        
        let urlString = "https://api.vk.com/method/messages.getConversations?extended=1,count=100&v=5.87&access_token=\(accessToken)"
        
       
        
        guard let url = URL(string: urlString) else { return }
        
        let request = session.dataTask(with: url) { (data, response, error) in
            if data != nil {
                self.parsingDialogData(data: data!)
            }
        }
        request.resume()
        
    }
    
    
    func sendMessages(id: [String],message: String) {
        guard let accessToken = token else { return }
        
        for i in id {
            
            let urlString = "https://api.vk.com/method/messages.send?user_ids=\(i)&message=\(message)&v=5.87&access_token=\(accessToken)"
            
            guard let url = URL(string: urlString) else { return }
            
            let request = session.dataTask(with: url) { (data, response, error) in
                guard let dataR = data else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: dataR, options: [])
                    print(json)
                } catch {
                    print(error)
                }
                
                
                }.resume()
        }
        
        
    }
    
    

    
    
    //MARK: Parsing
    func parsingMusicData(data: Data) -> [Music]?  {
        guard let json = try? JSONDecoder().decode(CodableMessageHistory.self, from: data) else {
            print("Decoder Music error")
            return nil
        }
        
        var array: [Music] = []
        let response = json.response
        for i in response.items {
            for attachments in i.attachments {
                if let audio = attachments.audio {
                    let items = Music(artist: audio.artist, title: audio.title, url: audio.url, duration: Int64(audio.duration), id: Int64(audio.id))
                    array.append(items)
                    print(Thread.current)
                    CoreDataManager.shared.saveContext()
                    
                    
                }
            }
        }
        return array
        
        
    }
    
    
    
    func parsingDialogData(data: Data) {
        guard let json = try? JSONDecoder().decode(CodableDialog.self, from: data) else {
            print("Decoder Dialog Error")
            return }
        let response = json.response
        let items = response.items
        breakId:for i in items {
            let id = i.conversation.peer.localID
            if let c = i.conversation.chatSettings {
                let itemDialog = Dialog()
                itemDialog.firstName = c.title
                itemDialog.lastName = nil
                itemDialog.id = Int64(id)
                do {
                    itemDialog.photo = try NSData(contentsOf: URL(string: c.photo.photo100)!)
                } catch {
                    print(error)
                }                
                CoreDataManager.shared.saveContext()
                continue
            }
            for p in response.profiles {
                if id == p.id {
                    let itemDialog = Dialog()
                    itemDialog.firstName =  p.firstName
                    itemDialog.lastName =  p.lastName
                    itemDialog.id = Int64(id)
                    do {
                       itemDialog.photo =  try NSData(contentsOf: URL(string: p.photo100)!)
                    } catch {
                        print(error)
                    }
                    CoreDataManager.shared.saveContext()
                    continue breakId
                }
            }
            for g in response.groups {
                if id == g.id {
                    let itemDialog = Dialog()
                    itemDialog.firstName = g.name
                    itemDialog.lastName = nil
                    itemDialog.id = Int64(id)
                    do {
                        itemDialog.photo = try NSData(contentsOf: URL(string: g.photo100)!)
                    } catch {
                        print(error)
                    }
                    CoreDataManager.shared.saveContext()
                    break
                } else {
                    continue
                }
            }
        }
    }
    
    
    
    //DownloadMusic
    func downloadMusic(url: String,completion: @escaping (URL) -> Void) {
        if let url = URL(string: url) {
            downloadTask?.cancel()
            downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] (urlMusic, response, error) in
                guard error == nil else {return }
                completion(urlMusic!)
            })
            downloadTask?.resume()
        }
        
    }
   
}



