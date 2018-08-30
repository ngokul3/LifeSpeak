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
    func getNextVideo(currentVideo: VideoContent?) throws ->VideoContent?
    func getPrevVideo(currentVideo: VideoContent?) throws ->VideoContent?
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
}

struct Messages {
    static let videoContentArrived = "Video list from Network"
    
}

enum VideoError: Error{
    case invalidRowSelection()
    case invalidXMLFile()
}


