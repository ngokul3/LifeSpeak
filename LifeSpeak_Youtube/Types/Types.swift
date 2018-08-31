//
//  Utils.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/28/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import Foundation

protocol VideoContentManagerProtocol {
    func getVideo(fromVideoArray index : Int) throws ->VideoContent
    func getVideoContentsCount()->Int
    func loadVideos()
    func loadVideoImage(imageURLOpt: String?, imageLoaded: @escaping (Data?, HTTPURLResponse?, Error?)->Void)
    func getNextVideo(currentVideo: VideoContent?) throws ->VideoContent?
    func getPrevVideo(currentVideo: VideoContent?) throws ->VideoContent?
    var currentFilter : String {get set}
    func getVideoContentIndex(videoContent: VideoContent)->Int
}

protocol VideoNavigationDelegate{
    func navigateToAnotherVideo(currentVideo: VideoContent?, navigationMode: NavigationMode )-> VideoContent?
}

enum NavigationMode{
    case next
    case prev
}
struct Consts {
    static let YOUTUBEURL = "https://www.youtube.com/feeds/videos.xml?channel_id="
    static let MinRatingToDisplayImage = 0
    static let MaxRatingToDisplayImage = 5
}

struct Messages {
    static let videoContentAvailable = "Video list from Network"
    
}

enum VideoError: Error{
    case invalidRowSelection()
    case invalidXMLFile()
}


