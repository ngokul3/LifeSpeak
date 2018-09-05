//
//  DetailVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokul K Narasimhan on 8/29/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import WebKit
import YouTubePlayer_Swift
class DetailVC: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var videoTextTitle: UITextView!
    @IBOutlet weak var webView: WKWebView! // Without YouTubePlayerView
    
    public var videoContentOpt: VideoContent?
    public var delegate : VideoNavigationDelegate?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
       // playWithWebKit()
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

//Can directly do this without additional Pod
extension DetailVC{
    
    func playWithWebKit() {
        
        guard let videoContent = videoContentOpt else{
            preconditionFailure("There is no URL to play")
        }
        
        guard let videoURL = URL(string: videoContent.videoURL ?? "") else{
            preconditionFailure("Invalid URL")
        }
 
        let requestObj = URLRequest(url: videoURL)
        webView.load(requestObj)
    }
}


