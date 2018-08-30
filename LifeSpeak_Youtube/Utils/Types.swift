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
}

protocol VideoNavigationDelegate{
    func navigateToAnotherVideo(currentVideoIndex: Int, navigationMode: NavigationMode )
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


