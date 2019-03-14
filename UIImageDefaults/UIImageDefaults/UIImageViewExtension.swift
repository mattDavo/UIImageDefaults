//
//  UIImageViewExtension.swift
//  UIImageDefaults
//
//  Created by Matthew Davidson on 14/3/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import Foundation
import os.log

public extension UIImageView {
    
    private func loadImage(url: String, completion: @escaping (UIImage?) -> ()) {
        os_log("Downloading: %s", url)
        URLSession.shared.dataTask(with: URL(string: url)!) {
            (data: Data?, resposnse: URLResponse?, error: Error?) -> Void in
            guard let data = data, error == nil else {
                completion(nil)
                os_log("Failed to download image: %s", (error?.localizedDescription)!)
                return
            }
            DispatchQueue.main.async {
                os_log("Successfully downloaded image data")
                if let image = UIImage(data: data) {
                    os_log("Successfully formatted data into a UIImage.")
                    completion(image)
                }
                else {
                    os_log("Failed to format data into a UIImage.")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    public func loadCachedImage(withUrl url: String, checkForUpdates: Bool) {
        if let image = UIImage(forKey: url) {
            os_log("Successfully loaded image with url '%s' from cache", url)
            self.image = image
            if checkForUpdates {
                loadImage(url: url) { image in
                    if let image = image {
                        os_log("Successfully updated image with url '%s' from server. Saving to cache.", url)
                        self.image = image
                        self.image?.saveImage(forKey: url)
                    }
                }
            }
        }
        else {
            os_log("Failed to load image with url '%s' from cache. Downloading.", url)
            loadImage(url: url) { image in
                if let image = image {
                    os_log("Successfully downloaded image with url '%s' from server. Saving to cache.", url)
                    self.image = image
                    self.image?.saveImage(forKey: url)
                }
            }
        }
    }
}
