//
//  ViewController.swift
//  ex26
//
//  Created by Gor on 5/26/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,AVAudioPlayerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var musicPlayer = AVAudioPlayer()
    var tracks = [Track]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        NetworkManager.instance.getTracks { [weak self] tracks in
            guard let tracks = tracks else { return }
            DispatchQueue.main.async {
                self?.tracks = tracks
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCell",
                                                            for: indexPath) as? TrackCell else { return UICollectionViewCell() }
        cell.setImage(with: tracks[indexPath.row])
        cell.playPauseButton.tag = indexPath.row
        cell.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func loadMusic(with index : Int){
        let fileURL = tracks[index].previewUrl
        let songData = try! Data(contentsOf: fileURL)
        self.musicPlayer = try! AVAudioPlayer(data: songData)
        musicPlayer.delegate = self
        musicPlayer.prepareToPlay()
    }
    var isPlaying: Bool = true {
        didSet {
            if isPlaying {
                musicPlayer.play()
            }else{
                self.musicPlayer.pause()
            }
        }
    }
    
    @objc func playPauseButtonTapped(_ sender: UIButton) {
        musicPlayer = .init()
        loadMusic(with: sender.tag)
        isPlaying.toggle()
    }
}

