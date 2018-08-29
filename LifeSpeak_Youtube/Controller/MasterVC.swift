//
//  MasterVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/28/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class MasterVC: UIViewController {

    private var videoManager = AppDel.videoManager
    private static var modelObserver: NSObjectProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        videoManager.loadVideos()
        
        MasterVC.modelObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:   Messages.videoContentArrived), object: nil, queue: OperationQueue.main) {
            [weak self] (notification: Notification) in
            
            if let s = self {
                s.updateUI()
            }
        }
        
        super.viewDidLoad()
    }
}

extension MasterVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? VideoCell else{
            preconditionFailure("Incorrect Cell provided")
        }
        
        var videoContentOpt: VideoContent?
        
        do{
            videoContentOpt = try videoManager.getVideo(fromVideoArray: indexPath.row)
        }
        catch{
            print("Unexpected Error while framing cell")
        }
        
        guard let videoContent = videoContentOpt else{
            preconditionFailure("Video content not available")
        }
        cell.title.text = videoContent.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoManager.getVideoContentsCount()
        
    }
}

extension MasterVC{
    func updateUI(){
        self.tableView.reloadData()
    }
}
