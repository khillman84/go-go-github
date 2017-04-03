//
//  GitHub.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/3/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

enum GitHubAuthError : Error {
    case extractingCode
}

class GitHub {
    
    let gitHubClientID = "9f80088a4d35c48fb2b0"
    let gitHubClientSecret = "51189c94cd370a0b3ae01410467951e9616d4715"
    
    static let shared = GitHub()
    
    func oAuthRequestWith(parameters: [String : String]){
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(gitHubClientID)\(parametersString)"){
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
        }
    }
    
    func getCodeFrom(url: URL) throws -> String {
        
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw GitHubAuthError.extractingCode
        }
        return code
    }
}
