//
//  PlayerHelper.swift
//  VKMusic
//
//  Created by Robert on 26.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import Foundation
import AVFoundation

class PlayerHelper {
    

    func back(player: AVAudioPlayer?, music: [Music]?, index: Int, competion: () -> Void) {
        if player != nil {
            if music != nil {
                if index != 0 {
                    competion()
                }
            }
        }
    }
    
    func start(player: AVAudioPlayer?,completionIsPlaying: (Bool) -> Void, completionPlayer: () -> Void ) {
        if player != nil {
            if player!.isPlaying {
                completionIsPlaying(true)
                
            } else {
                completionIsPlaying(false)
            }
            
        } else {
            completionPlayer()
        }
    }
    
    func forwards(player: AVAudioPlayer?, music: [Music]?, index: Int, competion: (Bool) -> Void) {
        if player != nil {
            if music != nil {
                if music!.count-1 != index {
                    competion(true)
                } else {
                    competion(false)
                }
            }
        }
        
        
    }
    
    
  
}
