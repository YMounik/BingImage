//
//  BINetworkManager.swift
//  BI
//

import UIKit

typealias networkSuccessHandler = (_ response: URLResponse?, _ json: Any) -> Void
typealias networkFailureHandler = (_ response: URLResponse?, _ error: Error?) -> Void

public class BINetworkManager: NSObject {
    
    /// this method can be used to get the resource from the web service
    ///
    /// - Parameters:
    ///   - url: resource of the path
    ///   - completionHandler: transfer the json data through success completion block if web service is success
    ///   - failureHandler: returns the failure reason if any web service is failed to get data
    
    class func get(_ url: URL, _ successHandler: @escaping networkSuccessHandler, _ failureHandler: @escaping networkFailureHandler) -> Void {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url)
        request.addValue("ce071517b1e14fa2957dccdc75b8fb8f", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request) { (data, response, error) in
            if let errorMessage = error {
                failureHandler(response, errorMessage)
                debugPrint(errorMessage)
            }else {
                do {
                    if let jsonData = data {
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                        successHandler(response, jsonObject as Any)
                    }else {
                        failureHandler(response, error)
                    }
                }catch let error {
                    failureHandler(response, error)
                    debugPrint(error)
                }
            }
        }.resume()
    }
}
