//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Jeremy Peronto on 10/1/15.
//  Copyright © 2015 Jeremy Peronto. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        imageView!.image = meme.memedImage
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

}
