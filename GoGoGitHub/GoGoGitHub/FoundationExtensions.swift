//
//  FoundationExtensions.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/3/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func getAccessToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else { return nil }
        return token
    }
    
    func save(accessToken: String) -> Bool {
        UserDefaults.standard.set(accessToken, forKey: "access_token")
        return UserDefaults.standard.synchronize()
    }
}
