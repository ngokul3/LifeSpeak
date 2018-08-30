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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        guard let identifier = segue.identifier else{
            preconditionFailure("No segue identifier")
        }
        
        let segueToVC = segue.destination as? DetailVC
        
        //switch not really needed as we have only 1 segue
        
        switch identifier{
        case "detailIdentifier" :
            let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedRow = selectedIndex?.row ?? 0
            
            do{
                let video = try videoManager.getVideo(fromVideoArray: selectedRow)
                segueToVC?.videoContentOpt = video
//                segueToVC?.videoURLOpt = video.videoURL
//                segueToVC?.videoTitle.text = video.title
                segueToVC?.videoFromIndexOpt = selectedRow
            }
            catch{
                alertUser = "Video not available"
            }
            
        default:  break
        }
    }
}
extension MasterVC{
    func updateUI(){
        self.tableView.reloadData()
    }
}

extension MasterVC: VideoNavigationDelegate{
    func navigateToAnotherVideo(currentVideoIndex: Int, navigationMode: NavigationMode) {
        
        let totalVideoCount = videoManager.getVideoContentsCount()
        switch navigationMode{
        case .next:
            if(currentVideoIndex == totalVideoCount - 1){
                
            }else{
                //let video = try videoManager.getVideo(fromVideoArray: currentVideoIndex + 1)
                
            }
        
        case .prev:
            if(currentVideoIndex == 0){
                
            }else{
                
            }
        }
    }
    
    
}

extension MasterVC{
    
    var alertUser :  String{
        get{
            preconditionFailure("You cannot read from this object")
        }
        set{
            let alert = UIAlertController(title: "Attention", message: newValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
