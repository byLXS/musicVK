//
//  MusicPlayerViewController.swift
//  VKMusic
//
//  Created by Robert on 10.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import ESTMusicIndicator

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
    var playerHelper = PlayerHelper()
    var timer = Timer()
    var fetchResultC = CoreDataManager.shared.initFetchResultController(enityNmae: "Music", sortKey: "date")
    var currentIndexMusic = 0 {
        didSet {
            if oldValue != currentIndexMusic {
                didSelect()
            }
        }
    }
    var music: [Music]?
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<Music>(entityName: "Music")
        do {
            let result = try CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if result.isEmpty {
                NetworkHelper.shared.getDialogs {
                }
                getMusicInfo()
            } else {
                try fetchResultC.performFetch()
                music = fetchResultC.fetchedObjects as? [Music]
                setupInfo()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func setupView(model: Music) {
        self.nameLabel.text = model.title
        self.artistLabel.text = model.artist
        self.currentTimeSlider.value = 0.00
        self.currentTimeSlider.maximumValue = Float(model.duration)
        self.maxTimeLabel.text = updateTimeLabelText(Int(model.duration))
        self.playButton.setImage(#imageLiteral(resourceName: "stopMusic"), for: .normal)
        self.tableView.reloadData()
    }
    
    
    
    @objc func updateSlider() {
        if minTimeLabel.text == maxTimeLabel.text {
            timer.invalidate()
            if (music?.count)!-1 != currentIndexMusic {
                currentIndexMusic += 1
            } else {
                currentIndexMusic = 0
            }
        }
        self.currentTimeSlider.value = Float(player!.currentTime)
        self.minTimeLabel.text = updateTimeLabelText(Int((player?.currentTime)!))
    }
    
    //MARK: Action
    @IBAction func presentDialogAction(_ sender: UIButton) {
        let dialogCV = storyboard?.instantiateViewController(withIdentifier: "dialogCV") as! DialogCollectionViewController
        
        dialogCV.music = music![currentIndexMusic]
        
        self.addChild(dialogCV)
        self.view.addSubview(dialogCV.view)
        dialogCV.didMove(toParent: self)
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        dialogCV.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        
    }
    
    
    
    @IBAction func backMusicAction(_ sender: UIButton) {
        playerHelper.back(player: player, music: music, index: currentIndexMusic) {
            currentIndexMusic -= 1
        }
    }
    
    
    
    @IBAction func playMusicAction(_ sender: UIButton) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: currentIndexMusic, section: 0)) as? MusicTableViewCell
        playerHelper.start(player: player, completionIsPlaying: { (state) in
            if state {
                timer.invalidate()
                player?.stop()
                playButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            } else {
                player?.currentTime = TimeInterval(currentTimeSlider.value)
                player?.play()
                runTimer()
                playButton.setImage(#imageLiteral(resourceName: "stopMusic"), for: .normal)
            }
        }) {
            didSelect()
        }
    }
    
    @IBAction func forwardsMusicAction(_ sender: UIButton) {
        playerHelper.forwards(player: player, music: music, index: currentIndexMusic) { (state) in
            if state {
                currentIndexMusic += 1
            } else {
                currentIndexMusic = 0
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
        self.minTimeLabel.text = updateTimeLabelText(Int((player?.currentTime)!))
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
    
    
    func downloadAndPlayMusic(urlString: String) {
        NetworkHelper.shared.downloadMusic(url: urlString) { (urlMusic) in
            self.playMusic(url: urlMusic)
        }
    }
    
    
    /// Получение и запись информации о музыке
    func getMusicInfo() {
        // Получение информации
        NetworkHelper.shared.getMusic { (music) in
            do {
                try self.fetchResultC.performFetch()
                self.music = self.fetchResultC.fetchedObjects as? [Music]
            } catch {
                print(error.localizedDescription)
            }
            //Запись
            self.setupInfo()
            
            self.tableView.reloadData()
        }
    }
    
    func setupInfo() {
        guard let item = music else { return }
        if !item.isEmpty {
            let itemMusic = item[0]
            self.nameLabel.text = itemMusic.title
            self.artistLabel.text = itemMusic.artist
            self.maxTimeLabel.text = updateTimeLabelText(Int(itemMusic.duration))
            self.currentTimeSlider.maximumValue = Float(itemMusic.duration)
            self.currentTimeSlider.minimumValue = 0.00
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Аудиозаписи в диалоге не найдены", preferredStyle: .actionSheet)
            let getMusicAlertAction = UIAlertAction(title: "Обновить", style: .default) { (action) in
                self.getMusicInfo()
            }
            let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(getMusicAlertAction)
            alert.addAction(cancelAlertAction)
            present(alert, animated: true, completion: nil)
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
    
    func updateTimeLabelText(_ time: Int) -> String {
        let currentTime = time
        let minutes = currentTime / 60
        
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        let strTime = NSString(format: "%02d:%02d", minutes,seconds) as String
        return strTime
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
            
            cell.playerState = currentIndexMusic == indexPath.row ? .playing : .stopped
            
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
        
        if self.music?.count != self.currentIndexMusic {
            self.currentIndexMusic = indexPath.row
        }
        
    }
    
    private func didSelect(_ row: Int? = nil) {
        let indexPath = IndexPath.init(item: row ?? currentIndexMusic, section: 0)
        
        guard let item = music?[indexPath.row] else { return }
        
        if player != nil {
            player?.stop()
        }
        
        NetworkHelper.shared.downloadMusic(url: item.url) { (urlMusic) in
            self.playMusic(url: urlMusic)
            
            if self.music?.count != self.currentIndexMusic {
                self.currentIndexMusic = indexPath.row
                DispatchQueue.main.async {
                    self.setupView(model: item)
                }
            }
        }
        
    }
    
}


