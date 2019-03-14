//
//  UIImageExtension.swift
//  UIImageDefaults
//
//  Created by Matthew Davidson on 14/3/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import Foundation
import os.log

private let imagesDir = "UIImageDefaultsImages"

fileprivate func isKeyEmpty(_ key: String) -> Bool {
    if key == "" {
        os_log(.error, "Image key cannot be empty.")
        return true
    }
    return false
}

fileprivate func escapeKey(_ key: String) -> String {
    let escapedKey = key.replacingOccurrences(of: "/", with: "\\")
    if key.contains("/") {
        os_log(.info, "WARNING: Your key contains '/' characters, we have changed these to '\'. Your image will be stored with the key: '%s'.", escapedKey)
        
    }
    return escapedKey
}

public extension UIImage {
    
    public convenience init?(forKey: String) {
        let key = escapeKey(forKey)
        if isKeyEmpty(key) {
            return nil
        }
        
        if let data = UIImage.getImageData(forKey: key) {
            self.init(data: data)
        }
        else {
            return nil
        }
    }
    
    private static var imagesPath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0] as NSString
        return documentPath.appendingPathComponent(imagesDir)
    }
    
    public class func removeImage(forKey: String) {
        let key = escapeKey(forKey)
        if isKeyEmpty(key) {
            return
        }
        
        let fullPath = (UIImage.imagesPath as NSString).appendingPathComponent(key)
        
        // Remove old image if it exists
        if UIImage(contentsOfFile: fullPath) != nil  {
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: fullPath)
                os_log("Successfully removed image with key '%s'.", key)
            } catch {
                os_log(.error, "Failed to delete image with key: '%s'. Error: %s", key, error.localizedDescription)
            }
        }
        else {
            os_log(.error, "Could not remove image with key '%s' as it does not exist.", key)
        }
    }
    
    public class func removeImages() {
        let fileManager = FileManager.default
        do {
            let directoryContents: NSArray = try fileManager.contentsOfDirectory(atPath: UIImage.imagesPath) as NSArray
            
            for path in directoryContents {
                let fullPath = (UIImage.imagesPath as NSString).appendingPathComponent(path as! String)
                try fileManager.removeItem(atPath: fullPath)
            }
            os_log("Successfully removed all images from storage.")
        }
        catch {
            os_log(.error, "Failed to remove images: ", error.localizedDescription)
        }
    }
    
    public func saveImage(forKey: String) {
        let key = escapeKey(forKey)
        if isKeyEmpty(key) {
            return
        }
        
        let fullPath = (UIImage.imagesPath as NSString).appendingPathComponent(key)
        
        let fileManager = FileManager.default
        
        // First check if there is a folder to put just our images in. If not, create it.
        var isDir : ObjCBool = false
        if !(fileManager.fileExists(atPath: UIImage.imagesPath, isDirectory:&isDir) && isDir.boolValue) {
            do {
                try fileManager.createDirectory(atPath: UIImage.imagesPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                os_log(.error, "Failed to create %s directory: %s", imagesDir, error.localizedDescription)
            }
        }
        
        // Remove old image if it exists
        if UIImage(contentsOfFile: fullPath) != nil  {
            do {
                try fileManager.removeItem(atPath: fullPath)
            } catch {
                os_log(.error, "Failed to delete image with key: '%s'. Error: %s", key, error.localizedDescription)
            }
        }
        
        let imageData = self.jpegData(compressionQuality: 1)
        do {
            try imageData?.write(to: URL(fileURLWithPath: fullPath))
            os_log("Successfully wrote image with key '%s' to cache", key)
        } catch {
            os_log(.error, "Failed to write image: %s", error.localizedDescription)
        }
    }
    
    private class func getImageData(forKey relativePath: String) -> Data? {
        do {
            let fullPath = (self.imagesPath as NSString).appendingPathComponent(relativePath)
            return try NSData(contentsOfFile: fullPath) as Data
        }
        catch {
            os_log(.error, "Failed to load image: %s", error.localizedDescription)
            return nil
        }
    }
    
    public class func getImage(forKey: String) -> UIImage? {
        let key = escapeKey(forKey)
        if isKeyEmpty(key) {
            return nil
        }
        
        if let data = UIImage.getImageData(forKey: key) {
            os_log("Successfully retrieved image data from storage.")
            if let image = UIImage(data: data) {
                os_log("Successfully formatted data into a UIImage.")
                return image
            }
            else {
                os_log("Failed to format data into a UIImage.")
                return nil
            }
        }
        else {
            return nil
        }
    }
}
