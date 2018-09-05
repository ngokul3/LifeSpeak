//
//  MasterVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokul K Narasimhan on 8/28/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class MasterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var videoManager = AppDel.videoManager
    private static var modelObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        videoManager.loadVideos()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        MasterVC.modelObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:   Messages.videoContentAvailable), object: nil, queue: OperationQueue.main) {
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
        cell.titleTextView.text = videoContent.title
        let ratingImageName = videoContent.ratingImageName ?? ""
        cell.imgRating.image = UIImage(named: ratingImageName)

        if(!(videoContent.imageURL ?? "").isEmpty){
            videoManager.loadVideoImage(imageURLOpt: videoContent.imageURL, imageLoaded: ({(data, response, error) in
                
                OperationQueue.main.addOperation {
                    if let e = error {
                        print("HTTP request failed: \(e.localizedDescription)")
                    }
                    else{
                        if let httpResponse = response {
                            print("http response code: \(httpResponse.statusCode)")
                            
                            let HTTP_OK = 200
                            if(httpResponse.statusCode == HTTP_OK ){
                                
                                if let imageData = data{
                                    print("urlArrivedCallback operation: Now on thread: \(Thread.current)")
                                    cell.imgVideo.image = UIImage(data: imageData)
                                }
                                else{
                                    cell.imgVideo.image = nil
                                    print("Image data not available")
                                }
                            }
                            else{
                                cell.imgVideo.image = nil
                                print("HTTP Error \(httpResponse.statusCode)")
                            }
                        }
                        else{
                            cell.imgVideo.image = nil
                            print("Can't parse imageresponse")
                        }
                    }
                }
            })
            )
        }
        else{
            cell.imgVideo.image = nil
        }
        
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
                segueToVC?.delegate = self
            }
            catch{
                alertUser = "Video not available"
            }
            
        default:  break
        }
    }
}


extension MasterVC: VideoNavigationDelegate{
    func navigateToAnotherVideo(currentVideo: VideoContent?, navigationMode: NavigationMode)->VideoContent? {
        do{
            let navigatedVideo: VideoContent?
            switch navigationMode{
            case .next:
                navigatedVideo = try videoManager.getNextVideo(currentVideo: currentVideo)
            case .prev:
                navigatedVideo = try videoManager.getPrevVideo(currentVideo: currentVideo)
            }
            
            if let video = navigatedVideo{
                let videoIndexRow = videoManager.getVideoContentIndex(videoContent: video)
                let indexPath = IndexPath(row: videoIndexRow, section: 0)
                
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
            }
            
            return navigatedVideo

        }
        catch{
            alertUser = "Cannot be navigated to another video"
            return nil
        }
    }
}

extension MasterVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(videoManager.currentFilter != searchText){
            videoManager.currentFilter = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MasterVC{
    func updateUI(){
        self.tableView.reloadData()
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
