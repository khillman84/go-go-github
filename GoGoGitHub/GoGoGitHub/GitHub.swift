//
//  GitHub.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/3/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

typealias GitHubOAuthCompletion = (Bool)->()
typealias FetchReposCompletion = ([Repository]?)->()

enum GitHubAuthError : Error {
    case extractingCode
}

enum SaveOptions {
    case userDefaults
}

class GitHub {
    
    private var session : URLSession
    private var componenents : URLComponents
    
    let gitHubClientID = "9f80088a4d35c48fb2b0"
    let gitHubClientSecret = "ff63b151329b4757842959f8f3ed9bb24686ffa7"
    
    static let shared = GitHub()
    
    private init(){
        self.session = URLSession(configuration: .default)
        self.componenents = URLComponents()
        
        self.componenents.scheme = "https"
        self.componenents.host = "api.github.com"
        
        if let token = UserDefaults.standard.getAccessToken() {
            let queryItem = URLQueryItem(name: "access_token", value: token)
            self.componenents.queryItems = [queryItem]
        }
    }
    
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
    
    func tokenRequestFor(url: URL, saveOptions: SaveOptions, completion: @escaping GitHubOAuthCompletion){
        
        func complete(success: Bool){
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        do {
            let code = try self.getCodeFrom(url: url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(gitHubClientID)&client_secret=\(gitHubClientSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString) {
                
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    if error != nil { complete(success: false) }
                    
                    guard let data = data else { complete(success: false); return }
                    
                    if let dataString = String(data: data, encoding: .utf8) {
                        var token : String = ""
                        let components = dataString.components(separatedBy: "&")
                        
                        for component in components {
                            if component.contains("access_token") {
                                token = component.components(separatedBy: "=").last!
                                print(token)
                            }
                        }
                        
                        if UserDefaults.standard.save(accessToken: token) {
                            print("Saved successfully")
                            
                        }
                        complete(success: true)
                    }
                }).resume()
            }
        } catch {
            print(error)
            complete(success: false)
        }
    }
    
    func getRepos(completion: @escaping FetchReposCompletion) {
        
        func returnToMain(results: [Repository]?) {
            OperationQueue.main.addOperation {
                completion(results)
            }
        }
        
        self.componenents.path = "/user/repos"
        
        guard let url = self.componenents.url else {returnToMain(results: nil); return }
        
        self.session.dataTask(with: url) { (data, response, error) in
            if error != nil { returnToMain(results: nil); return }
            
            if let data = data {
                var repositories = [Repository]()
                
                do {
                    if let rootJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] {
                        print(rootJson.last ?? "No Root JSON")
                        for repositoryJSON in rootJson {
                            if let repo = Repository(json: repositoryJSON) {
                                repositories.append(repo)
                            }
                        }
                        returnToMain(results: repositories)
                    }
                } catch {
                    
                }
            }
        }.resume()
    }
}



































