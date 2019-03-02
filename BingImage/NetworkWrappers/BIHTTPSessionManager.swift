//
//  BIHTTPSessionManager.swift
//  BI
//

import UIKit

class BIHTTPSessionManager: BINetworkManager {

    
    /// Get binary images using search
    ///
    /// - Parameters:
    ///   - parameters: request body of the URL
    ///   - successHandler: returns JSON response of searched query
    ///   - failureHandler: returns error response with response code
    class func getBingImagesFor(_ parameters: [String: String], _ successHandler: @escaping networkSuccessHandler, _ failureHandler: @escaping networkFailureHandler) -> Void {
        let urlStr: NSString = "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=\(parameters["searchString"]!)&offset=\(parameters["offset"]!)&count=\(parameters["count"]!)&mkt=en-us" as NSString
        if let url = URL(string: urlStr.addingPercentEscapes(using: String.Encoding.utf8.rawValue) as! String) {
            self.get(url, { (response, data) in
                if data is [String: Any] {
                    let information = data as! [String: Any]
                    if let error = information["error"] as? String {
                        let nserror = NSError(domain: "BI Domain", code: -1000, userInfo: [NSLocalizedDescriptionKey: error])
                        failureHandler(response, nserror)
                    }else {
                        successHandler(response, data)
                    }
                }else {
                    print(#function)
                }
            }) { (response, error) in
                failureHandler(response, error)
            }
        }
    }
}
