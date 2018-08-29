//
//  VideoContent.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/28/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import Foundation
typealias VideoArray = [VideoContent]

class VideoContentManager{
    
   // private static var instance: VideoContentProtocol?
    private var videoContents = VideoArray()
    private lazy var networkModel = {
        return AppDel.networkModel
    }()
}

extension VideoContentManager : VideoContentManagerProtocol{
  
    func getVideo(fromVideoArray index : Int) throws ->VideoContent{
        
        guard let videoContent = videoContents[safe: index]  else{
            throw VideoError.invalidRowSelection()
        }
        
        return videoContent
    }
    
    func getVideoContentsCount()->Int{
        return videoContents.count
    }
}

extension VideoContentManager{
    func loadVideos(){
        networkModel.loadFromNetwork(finished: {[weak self](xmlContent , error) in
            
            guard let content = xmlContent else{
                preconditionFailure(error ?? "")
            }
            
            for content in content["feed", "entry"] {
                let video = VideoContent()
                video.title = content["title"].text
                video.id = content["id"].text
                video.videoURL = content["link"].attributes["href"]
                self?.videoContents.append(video)
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.videoContentArrived), object: self))
        })
    }
}
class VideoContent{
    var id: String?
    var title: String?
    var author: String?
    var videoURL: String?
    var imageURL: String?
    
//    init(_id: String, _title: String, _author: String, _videoURL: String, _imageURL: String) {
//        id = _id
//        title = _title
//        author = _author
//        videoURL = _videoURL
//        imageURL = _imageURL
//    }
}

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

