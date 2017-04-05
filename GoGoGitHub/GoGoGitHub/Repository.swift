//
//  Repository.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/4/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import Foundation

class Repository {
    
    let name : String
    let description : String?
    let language : String?
    
    init?(json: [String : Any]) {

        
        guard let name = json["name"] as? String else { return nil }
        guard let description = json["description"] as? String else { return nil }
        guard let language = json["language"] as? String else { return nil }
        
        self.name = name
        self.description = description
        self.language = language
        print(name)
    }
}
