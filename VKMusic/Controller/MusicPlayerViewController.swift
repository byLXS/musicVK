//
//  MusicPlayerViewController.swift
//  VKMusic
//
//  Created by Robert on 09.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class MusicPlayerViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var minTimeLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Property
    var player: AVAudioPlayer?
    var timer = Timer()
    var fetchResultC = CoreDataManager.shared.initFetchResultController(enityNmae: "Music", sortKey: "date")
    var currentIndexMusic = 0
    var music: [Music]?
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<Music>(entityName: "Music")
        do {
            let result = try CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if result.isEmpty {
                VKApi.shared.getDialogs {
                }
                getMusicInfo()
            } else {
                try fetchResultC.performFetch()
                music = fetchResultC.fetchedObjects as? [Music]
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    
    func reloadView() {
        DispatchQueue.main.async {
            if self.music != nil {
                self.nameLabel.text = self.music?[self.currentIndexMusic].title
                self.artistLabel.text = self.music?[self.currentIndexMusic].artist
                self.currentTimeSlider.value = 0.00
                self.currentTimeSlider.maximumValue = Float(self.music![self.currentIndexMusic].duration)
                self.playButton.setImage(#imageLiteral(resourceName: "stopMusic"), for: .normal)
            }
        }
    }
    
    
    
    @objc func updateSlider() {
        self.currentTimeSlider.value = Float(player!.currentTime)
        let currentTime = Int(player!.currentTime)
        let minutes = currentTime / 60
        
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        self.minTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    //MARK: Action
    @IBAction func presentDialogAction(_ sender: UIButton) {
        let dialogCV = storyboard?.instantiateViewController(withIdentifier: "dialogCV") as! DialogsCollectionViewController
        
        dialogCV.music = music![currentIndexMusic]
        
        self.addChild(dialogCV)
        self.view.addSubview(dialogCV.view)
        dialogCV.didMove(toParent: self)
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        dialogCV.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
    }
    
    
    
    @IBAction func backMusicAction(_ sender: UIButton) {
        
        
    }
    
    
    
    @IBAction func playMusicAction(_ sender: UIButton) {
        if player == nil {
            guard let item = music else { return }
            VKApi.shared.downloadMusic(url: item[0].url) { (url) in
                self.playMusic(url: url)
            }
        }
        if let audio = player {
            timer.invalidate()
            if audio.isPlaying {
                player?.stop()
                DispatchQueue.main.async {
                    self.playButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
                }
                
            } else {
                player?.currentTime = TimeInterval(currentTimeSlider.value)
                player?.play()
                DispatchQueue.main.async {
                    self.runTimer()
                    self.playButton.setImage(#imageLiteral(resourceName: "stopMusic"), for: .normal)
                }
                
            }
        }
    }
    
    @IBAction func forwardsMusicAction(_ sender: UIButton) {
        if player != nil {
            if (player?.isPlaying)! {
                player?.stop()
            }
            if music != nil {
                if (music?.count)!-1 != currentIndexMusic {
                    currentIndexMusic += 1
                    reloadView()
                    VKApi.shared.downloadMusic(url: music![currentIndexMusic].url) { (urlMusic) in
                        self.playMusic(url: urlMusic)
                    }
                } else {
                    currentIndexMusic = 0
                    reloadView()
                    VKApi.shared.downloadMusic(url: music![currentIndexMusic].url) { (urlMusic) in
                        self.playMusic(url: urlMusic)
                    }
                }
            }
            
        }
    }
    
    
    
    /// Изменение времени музыки в Label
    ///
    /// - Parameter sender: UISlider
    @IBAction func setTimeLabelAction(_ sender: UISlider) {
        if (player?.isPlaying)! {
            DispatchQueue.main.async {
                self.timer.invalidate()
            }
        }
        let currentTime = Int(player!.currentTime)
        let minutes = currentTime / 60
        
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        self.minTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    
    
    @IBAction func setCurrentTimeMusicAction(_ sender: UISlider) {
        if player != nil {
            if (player?.isPlaying)! {
                DispatchQueue.main.async {
                    self.runTimer()
                }
            }
            player?.currentTime = TimeInterval(sender.value)
            
            
        }
    }
    
    
    
    
    //MARK: Methods
    
    /// Получение и запись информации о музыке
    func getMusicInfo() {
        // Получение информации
        VKApi.shared.getMusic { (music) in
            //Запись
            let itemMusic = music[0]
            self.nameLabel.text = itemMusic.title
            self.artistLabel.text = itemMusic.artist
            self.currentTimeSlider.maximumValue = Float(itemMusic.duration)
            self.currentTimeSlider.minimumValue = 0.00
            do {
                try self.fetchResultC.performFetch()
                self.music = self.fetchResultC.fetchedObjects as? [Music]
            } catch {
                print(error.localizedDescription)
            }
            
            self.tableView.reloadData()
        }
    }
    
    
    
    /// Воспроизведение музыки
    ///
    /// - Parameter url: URL Aдрес музыки
    func playMusic(url: URL?) {
        timer.invalidate()
        do {
            player = try AVAudioPlayer(contentsOf: url! as URL)
            player?.prepareToPlay()
            if (player?.isPlaying)!  {
                player?.pause()
            } else  {
                player?.play()
                DispatchQueue.main.async {
                    self.currentTimeSlider.value = Float((self.player?.currentTime)!)
                    self.runTimer()
                }
            }
            
            let session = AVAudioSession.sharedInstance()
            
            do {
                try session.setCategory(.playback, mode: .moviePlayback, options: .defaultToSpeaker)
            } catch {
                print(error.localizedDescription)
            }
            
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    
}

//MARK: UITableViewDataSource
extension MusicPlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = music?.count else {
            return 0
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MusicTableViewCell {
            
            guard let item = music?[indexPath.row] else {
                return UITableViewCell()
                
            }
            cell.setupCell(item)
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
    
    
}

//MARK: UITableViewDelegate
extension MusicPlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = music?[indexPath.row] else { return }
        
        if player != nil {
            player?.stop()
        }
        VKApi.shared.downloadMusic(url: item.url) { (urlMusic) in
            self.playMusic(url: urlMusic)
            
            if self.music?.count != self.currentIndexMusic {
                self.currentIndexMusic = indexPath.row
            }
        }
        self.currentTimeSlider.maximumValue = Float(item.duration)
        self.nameLabel.text = item.title
        self.artistLabel.text = item.artist
        self.playButton.setImage(#imageLiteral(resourceName: "stopMusic"), for: .normal)
        self.tableView.reloadData()
        
    }
}


