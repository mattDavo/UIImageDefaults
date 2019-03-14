//
//  ViewController.swift
//  UIImageDefaultsExample
//
//  Created by Matthew Davidson on 14/3/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import UIKit
import UIImageDefaults
import os.log

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Use the default url loader
//        imageView.loadCachedImage(withUrl: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png", checkForUpdates: true)
        
        // Or use your own loader
        imageView.loadCachedImage(withKey: "google", checkForUpdates: true) { (done: @escaping (UIImage?) -> Void) in
            URLSession.shared.dataTask(with: URL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")!) {
                (data: Data?, resposnse: URLResponse?, error: Error?) -> Void in
                guard let data = data, error == nil else {
                    // Call the completion handler when you've failed
                    done(nil)
                    os_log("Failed to download image: %s", (error?.localizedDescription)!)
                    return
                }
                DispatchQueue.main.async {
                    // And call the completion handler when you've succeded
                    done(UIImage(data: data))
                }
            }.resume()
        }
    }
}
