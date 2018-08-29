//
//  NetworkLayer.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/28/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXMLParser

protocol NetworkProtocol {
    static func getInstance() -> NetworkProtocol
    func loadFromNetwork(finished: @escaping (_ xmlData: XML.Accessor?, _ errorMsg: String?)  -> ())
}

class NetworkModel: NetworkProtocol{
    
    private var youtubeOptId : String?
    private static var instance: NetworkProtocol?
    
    init()
    {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRootOpt = NSDictionary(contentsOfFile: path)
            
            guard let dict = dictRootOpt else{
                preconditionFailure("Info file is not available")
            }
            
            youtubeOptId = dict["YoutubeChannelId"] as? String
            
        }
    }
}

extension NetworkModel{
    
    static func getInstance() -> NetworkProtocol {
        
        if let inst = NetworkModel.instance {
            return inst
        }
        let inst = NetworkModel()
        NetworkModel.instance = inst
        return inst
    }
}

extension NetworkModel{
 
    func loadFromNetwork(finished: @escaping (_ xmlData: XML.Accessor?, _ errorMsg: String?)  -> ()){
        guard let youtubeId = youtubeOptId else{
            preconditionFailure("Youtube channel is not available")
        }
        
        var youtubeChannelURL : String
        youtubeChannelURL = Consts.YOUTUBEURL + youtubeId
        
        if let url = URL(string: youtubeChannelURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
           // urlRequest.addValue(myKey, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(youtubeChannelURL)
                .responseData { response in
                    if let data = response.data {
                        let xml = XML.parse(data)
                        print("XML loaded")
                        print(xml)
                        finished(xml, nil)
                    }
                    else{
                        finished(nil, "Invalid Content")
                    }
            }

        }
    }
}
