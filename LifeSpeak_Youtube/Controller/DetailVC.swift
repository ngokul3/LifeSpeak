//
//  DetailVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/29/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import AVFoundation
import YouTubePlayer_Swift

class DetailVC: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var videoTextTitle: UITextView!
    
    public var videoContentOpt: VideoContent?
    public var delegate : VideoNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()

    }
}

extension DetailVC{
    
    private func playVideo(){
        guard let videoContent = videoContentOpt else{
            preconditionFailure("There is no URL to play")
        }
        
        guard let url = URL(string: videoContent.videoURL ?? "") else{
            preconditionFailure("Invalid URL")
        }
        
        videoTextTitle.text = videoContent.title
    //    self.navigationItem.title = videoContent.title

        videoPlayer.loadVideoURL(url)
    }
}

extension DetailVC{
    
    @IBAction func btnBackClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        videoContentOpt = delegate?.navigateToAnotherVideo(currentVideo: self.videoContentOpt, navigationMode: .next)
        playVideo()
    }
    
    @IBAction func btnPrevClick(_ sender: UIButton) {
        videoContentOpt = delegate?.navigateToAnotherVideo(currentVideo: self.videoContentOpt, navigationMode: .prev)
        playVideo()
    }
    
}


