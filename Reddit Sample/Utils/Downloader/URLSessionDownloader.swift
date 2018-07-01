//
//  URLSessionDownloader.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class URLSessionDownloader: DownloaderAbstract {
    override func get(url: String, onSuccess: @escaping ([String: Any])->(), onFailure: ((_ failure: () throws -> ()) -> Void)? = nil, onFailureGeneral: ((Error)->())? = nil) {
        
        guard let url = URL(string: url) else {
            onFailure?({ throw APIErrors.invalidURL })
            onFailureGeneral?(APIErrors.invalidURL)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        onFailure?({ throw error })
                        onFailureGeneral?(error)
                    }
                    return
                }
                
                guard let responseData = data else {
                    DispatchQueue.main.async {
                        onFailure?({ throw APIErrors.invalidResponse })
                        onFailureGeneral?(APIErrors.invalidResponse)
                    }
                    return
                }
                
                do {
                    guard let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        DispatchQueue.main.async {
                            onFailure?({ throw APIErrors.invalidResponse })
                            onFailureGeneral?(APIErrors.invalidResponse)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        onSuccess(jsonDict)
                    }
                    
                } catch  {
                    DispatchQueue.main.async {
                        onFailure?({ throw APIErrors.invalidResponse })
                        onFailureGeneral?(APIErrors.invalidResponse)
                    }
                    return
                }
            }
            task.resume()
        }
    }
}
