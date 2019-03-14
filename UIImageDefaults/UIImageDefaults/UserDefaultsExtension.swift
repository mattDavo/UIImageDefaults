//
//  UserDefaultsExtension.swift
//  UIImageDefaults
//
//  Created by Matthew Davidson on 14/3/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    public func set(value: UIImage, forKey key: String) {
        value.saveImage(forKey: key)
    }
    
    public func uiimage(forKey key: String) -> UIImage? {
        return UIImage.getImage(forKey: key)
    }
    
    public func removeImage(forKey key: String) {
        UIImage.removeImage(forKey: key)
    }
    
    public func removeImages() {
        UIImage.removeImages()
    }
}

