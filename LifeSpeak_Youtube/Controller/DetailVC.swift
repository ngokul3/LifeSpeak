//
//  DetailVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/29/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit
//import AVKit
import YouTubePlayer_Swift

class DetailVC: UIViewController {


    public var videoURLOpt: String?
    @IBOutlet var videoPlayer: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoURL = videoURLOpt else{
            preconditionFailure("There is no URL to play")
        }
        
        guard let url = URL(string: videoURL) else{
            preconditionFailure("Invalid URL")
        }

       videoPlayer.loadVideoURL(url)
//        let player = AVPlayer(url: url)
//        let vc = AVPlayerViewController()
//        vc.player = player
//
//        present(vc, animated: true) {
//            vc.player?.play()
//        }
    }
}


