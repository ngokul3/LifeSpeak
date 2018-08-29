//
//  DetailVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/29/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import AVKit

class DetailVC: UIViewController {

    public var videoURLOpt: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoURL = videoURLOpt else{
            preconditionFailure("There is no URL to play")
        }
        
        guard let url = URL(string: videoURL) else{
            preconditionFailure("Invalid URL")
        }

        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}


