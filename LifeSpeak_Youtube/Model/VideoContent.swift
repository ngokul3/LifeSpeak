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
    
    private var videoContents = VideoArray(){
        didSet{
            filteredVideos = videoContents
        }
    }
    private lazy var networkModel = {
        return AppDel.networkModel
    }()
    
    var filteredVideos = VideoArray()
    
    
    var currentFilter : String = ""{
        didSet{
            
            if(!currentFilter.isEmpty){
                filterVideoList(videoFilter: currentFilter)
            }
            else{
                filteredVideos = videoContents
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.videoContentAvailable), object: self))
        }
    }
}

extension VideoContentManager : VideoContentManagerProtocol{
  
    func getVideo(fromVideoArray index : Int) throws ->VideoContent{
        
        guard let videoContent = filteredVideos[safe: index]  else{
            throw VideoError.invalidRowSelection()
        }
        
        return videoContent
    }
    
    func getVideoContentsCount()->Int{
        return filteredVideos.count
    }
    
    func getNextVideo(currentVideo: VideoContent?) throws ->VideoContent?{
        let indexNumOpt = filteredVideos.index(where: {$0 == currentVideo})
        
        guard let indexNum = indexNumOpt else{
            preconditionFailure("Index is nil")
        }
        
        if(indexNum == filteredVideos.count - 1){
            return try getVideo(fromVideoArray: 0)
        }
        else{
            return try getVideo(fromVideoArray: indexNum + 1)
        }
    }
    
    func getPrevVideo(currentVideo: VideoContent?) throws ->VideoContent?{
        let indexNumOpt = filteredVideos.index(where: {$0 == currentVideo})
        
        guard let indexNum = indexNumOpt else{
            preconditionFailure("Index is nil")
        }
        
        if(indexNum == 0){
            return try getVideo(fromVideoArray: filteredVideos.count - 1)
        }
        else{
            return try getVideo(fromVideoArray: indexNum - 1)
        }
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
                video.imageURL = content["media:group","media:thumbnail"].attributes["url"]
                let givenRating = content["media:group","media:community","media:starRating"].attributes["average"] ?? "0"
                video.rating = (givenRating as NSString).integerValue
                self?.videoContents.append(video)
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.videoContentAvailable), object: self))
        })
    }
    
    func loadVideoImage(imageURLOpt: String?, imageLoaded: @escaping (Data?, HTTPURLResponse?, Error?)->Void){
        
        guard let imageURL = imageURLOpt else{
            print("Image URL was empty")
            return
        }
        
        networkModel.setThumbnailImage(forVideoImage: imageURL, imageLoaded: {(dataOpt, responseOpt, errorOpt) in
            
            guard let data = dataOpt,
                let response = responseOpt else{
                    print("Image didn't load")
                    return
            }
            
            imageLoaded(data, response, errorOpt)
        })
        
    }
}

extension VideoContentManager{
    func filterVideoList(videoFilter: String){
        guard videoContents.count > 0 else {
            preconditionFailure("Not able to filter videos as there are none")
        }
        
        filteredVideos =  videoContents.filter({(arg1) in
            let title = arg1.title ?? ""
            return title.lowercased().contains(videoFilter.lowercased())
        })
    }
}
class VideoContent: Equatable {
    var id: String?
    var title: String?
    var author: String?
    var videoURL: String?
    var imageURL: String?
    var rating: Int?
    
    var ratingImageName: String?{
        if let videoRating = rating{
            return "\(videoRating)Stars"
        }
        else{
            return nil
        }
    }
    
}

func ==(lhs: VideoContent, rhs: VideoContent) -> Bool {
    return lhs.id == rhs.id
   
}

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

