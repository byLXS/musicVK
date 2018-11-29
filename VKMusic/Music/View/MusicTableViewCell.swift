//
//  MusicTableViewCell.swift
//  VKMusic
//
//  Created by Robert on 10.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit
import ESTMusicIndicator


enum PlayerState {
    case stopped
    case playing
    case paused
}

class MusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var nameMusicLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var musicESIndicator: ESTMusicIndicatorView!
    
    var playerState: PlayerState = .stopped
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateState()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setupCell(_ model: Music) {
        updateState()
        self.nameMusicLabel.text = model.title
        self.artistLabel.text = model.artist
        
    }
    
    func updateState() {
        switch playerState {
        case .stopped:
            musicESIndicator.state = .stopped
        case .playing:
            musicESIndicator.state = .playing
        case .paused:
            musicESIndicator.state = .paused
        }
    }
    
}
