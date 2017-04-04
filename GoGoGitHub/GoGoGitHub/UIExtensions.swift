//
//  UIExtensions.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/4/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
