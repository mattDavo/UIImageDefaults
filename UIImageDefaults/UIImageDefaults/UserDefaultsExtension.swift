//
//  UserDefaultsExtension.swift
//  UIImageDefaults
//
//  Created by Matthew Davidson on 14/3/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    /**
     Stores the image with the given key.
     
     - Parameter value: The `UIImage` to store in the defaults database.
     - Parameter key: The key with which to associate the value.
     */
    public func set(value: UIImage, forKey key: String) {
        value.saveImage(forKey: key)
    }
    
    /**
     Returns the uiimage value associated with the specified key.
     
     - Parameter key: A key in the current user‘s defaults database.
     
     - Returns: The uiimage value associated with the specified key. If the key doesn‘t exist, this method returns nil.
     */
    public func uiimage(forKey key: String) -> UIImage? {
        return UIImage.getImage(forKey: key)
    }
    
    /**
     Removes the uiimage of the specified key.
     
     - Parameter key: A key in the current user‘s defaults database.
     
     */
    public func removeImage(forKey key: String) {
        UIImage.removeImage(forKey: key)
    }
    
    /**
     Removes the all uiimages from the current user's defaults database.
     */
    public func removeImages() {
        UIImage.removeImages()
    }
}

