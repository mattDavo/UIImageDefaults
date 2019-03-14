//
//  ViewController.swift
//  UIImageDefaultsExample
//
//  Created by Matthew Davidson on 14/3/19.
//  Copyright © 2019 MatthewDavidson. All rights reserved.
//

import UIKit
import UIImageDefaults

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.loadCachedImage(withUrl: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png", checkForUpdates: true)
    }
}
