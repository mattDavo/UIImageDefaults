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
    
    /**
     Loads an image from a given URL, and calls the completion handler when the image has loaded or failed.
     
     - Parameter url: The URL to load the image from.
     
     - Parameter completion: The completion handler to call when the load request is complete.
     */
    private func loadImage(url: String, completionHandler: @escaping (UIImage?) -> ()) {
        os_log("Downloading: %s", url)
        URLSession.shared.dataTask(with: URL(string: url)!) {
            (data: Data?, resposnse: URLResponse?, error: Error?) -> Void in
            guard let data = data, error == nil else {
                completionHandler(nil)
                os_log("Failed to download image: %s", (error?.localizedDescription)!)
                return
            }
            DispatchQueue.main.async {
                os_log("Successfully downloaded image data")
                if let image = UIImage(data: data) {
                    os_log("Successfully formatted data into a UIImage.")
                    completionHandler(image)
                }
                else {
                    os_log("Failed to format data into a UIImage.")
                    completionHandler(nil)
                }
            }
        }.resume()
    }
    
    /**
     Uses the user's defaults database to load a `UIImageView` with an image from a URL, with a **modified** URL used as the key.
     
     If the image is not stored in the database, it will download the image and store it in the database. If the image is stored in the database it will load the image and from the database and then optionally update with the image from the URL.
     
     - Parameter url: A url to download the image from and/or use as a key to load (and save) from the current user‘s defaults database.
     
     - Parameter checkForUpdates: Boolean whether to check for an updated image from the server. If true, will always query the server for the image. If false, will only query the server if fails to load the image from the current user's defaults database.
     */
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
    
    /**
     Uses the user's defaults database to load a `UIImageView` with an image from a provided custom loader, with a provided key.
     
     If the image is not stored in the database, it will execute loader and store it in the database. If the image is stored in the database it will load the image and from the database and then optionally update with the loader.
     
     - Parameter key: The key with which to associate the value.
     
     - Parameter checkForUpdates: Boolean whether to check for an updated image from the server. If true, will always query the server for the image. If false, will only query the server if fails to load the image from the current user's defaults database.
     
     - Paramerter loader: Handler to execute your custom image loading code. The handler must call the completionHandler provided to it as a parameter, so that the uiimageview and user's defaults database is updated with the loaded image.
     */
    public func loadCachedImage(withKey key: String, checkForUpdates: Bool, withLoader loader: @escaping (@escaping (UIImage?) -> ()) -> ()) {
        if let image = UIImage(forKey: key) {
            os_log("Successfully loaded image with key '%s' from cache", key)
            self.image = image
            if checkForUpdates {
                loader() { (image: UIImage?) -> Void in
                    if let image = image {
                        os_log("Successfully updated image with key '%s' from loader. Saving to cache.", key)
                        self.image = image
                        self.image?.saveImage(forKey: key)
                    }
                }
            }
        }
        else {
            os_log("Failed to load image with key '%s' from cache. Downloading.", key)
            loader() { (image: UIImage?) -> Void in
                if let image = image {
                    os_log("Successfully loaded image with key '%s' from loader. Saving to cache.", key)
                    self.image = image
                    self.image?.saveImage(forKey: key)
                }
            }
        }
    }
}
