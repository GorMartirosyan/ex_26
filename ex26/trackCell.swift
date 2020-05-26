//
//  trackCell.swift
//  ex26
//
//  Created by Gor on 5/26/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit
import AVFoundation

struct Track: Codable {

    let previewUrl: URL
    let artworkUrl100: URL
}

class TrackCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func convertImageUrl(url: URL) -> URL {
        let urlString = url.absoluteString.replacingOccurrences(of: "100x100",with: "250x250")
        return URL(string: urlString)!
    }
    
    func setImage(with track: Track) {
        let url = convertImageUrl(url: track.artworkUrl100)
        if self.imageView.image == nil { self.imageView.image = .none }
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {return}
            DispatchQueue.main.async(execute: { () -> Void in
                guard let data = data else {return}
                let image = UIImage(data: data)
                self.imageView.image = image
            })
        }).resume()
    }
}

    
    



