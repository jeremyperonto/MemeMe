//
//  SentMemesTableAndCollectionViewController.swift
//  MemeMe
//
//  Created by Jeremy Peronto on 9/25/15.
//  Copyright © 2015 Jeremy Peronto. All rights reserved.
//

import UIKit
import Foundation

var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
}