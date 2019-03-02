//
//  Animal.swift
//  BingImage
//

import UIKit

public class Animal: NSObject {
    var name: String = ""
    var datePublished: String = ""
    var homePageUrl: String = ""
    var contentSize: String = ""
    var width: Double = 0
    var height: Double = 0
    var thumbnail:Thumbnail? = nil
    var imageInsightsToken: String = ""
    var insightsSourcesSummary: String = ""
    var imageId: String = ""
    var accentColor: String = ""
    var webSearchUrl: String = ""
    var thumbnailUrl: String = ""
    var encodingFormat: String = ""
    var contentUrl: String = ""
    
    override init() {
        super.init()
    }
    
    init(with animalData: [String: Any]) {
        name = animalData["name"] as? String ?? ""
        datePublished = animalData["datePublished"] as? String ?? ""
        homePageUrl = animalData["homePageUrl"] as? String ?? ""
        contentSize = animalData["contentSize"] as? String ?? ""
        width = animalData["width"] as? Double ?? 0
        height = animalData["height"] as? Double ?? 0
        thumbnail = Thumbnail.init(with: animalData["thumbnail"] as! [String : Any])
        imageInsightsToken = animalData["imageInsightsToken"] as? String ?? ""
        insightsSourcesSummary = animalData["insightsSourcesSummary"] as? String ?? ""
        imageId = animalData["imageId"] as? String ?? ""
        accentColor = animalData["accentColor"] as? String ?? ""
        webSearchUrl = animalData["webSearchUrl"] as? String ?? ""
        thumbnailUrl = animalData["thumbnailUrl"] as? String ?? ""
        encodingFormat = animalData["encodingFormat"] as? String ?? ""
        contentUrl = animalData["contentUrl"] as? String ?? ""
    }
}

class Thumbnail: NSObject {
    var width: Double = 0
    var height: Double = 0
    
    init(with thumbnailData: [String: Any]) {
        width = thumbnailData["width"] as? Double ?? 0
        height = thumbnailData["height"] as? Double ?? 0
    }
}
