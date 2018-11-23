//
//  Player.swift
//  VKMusic
//
//  Created by Robert on 10.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import AVFoundation

class Player {
    var audio: AVAudioPlayer?
    
    var session = URLSession(configuration: .default)
    var downloadTask: URLSessionDownloadTask?
    var isDownloading = false
    
    func playMusic(url:NSURL?) {
        do {
            audio = try AVAudioPlayer(contentsOf: url! as URL)
            audio?.prepareToPlay()
            audio?.volume = 5.0
            if (audio?.isPlaying)!  {
                audio?.pause()
            } else  {
                audio?.play()
            }
            
            
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    
    func downloadMusic(urlString: String,completion: @escaping (Any) -> Void) {
        if let url = URL(string: urlString) {
            downloadTask?.cancel()
            downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] (urlMusic, response, error) in
                guard error == nil else {return }
                let player = Player()
                player.playMusic(url: urlMusic as? NSURL)
                completion(player)
            })
            downloadTask?.resume()
        }
        
    }
    
    
   
    
}
