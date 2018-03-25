//
//  NetworkManager.swift
//  CurrencyRates
//
//  Created by Shantanu Khanwalkar on 25/03/18.
//  Copyright © 2018 Shantanu Khanwalkar. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    // Creating a shared instance of the network manager
    static let shared = NetworkManager()
    private init() {}
    
    /// this function makes the api call to the server. it checks if the response received is valid or invalid.
    func makeServerCall(toAPI: String, callbackResponse: @escaping (_ dataResponse: DataResponse<Any>, _ success: Bool, _ errorMessage: String) -> Void) {
        Alamofire.request(toAPI).responseJSON { (response) in
            if let serverResponse = response.response {
                let status = serverResponse.statusCode
                let result = response.result
                
                // Check status code to verify that the api call was success
                if 200 ... 299 ~= status {
                    if result.isSuccess {
                        // if result is success, send the callback with the response
                        callbackResponse(response, true, "")
                    } else {
                        // if the result is a failure, send the callback with error message
                        if let error = result.error {
                            callbackResponse(response, false, (error.localizedDescription))
                        }
                    }
                } else {
                    // Handle all failures (400 ~ 500)
                }
            }
        }
    }
    
}
