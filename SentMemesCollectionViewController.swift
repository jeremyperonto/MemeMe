//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jeremy Peronto on 9/25/15.
//  Copyright © 2015 Jeremy Peronto. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var meme: Meme!
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (view.bounds.size.width - (2 * space)) / 3.0
        let heightDimension = (view.bounds.size.height - (2 * space)) / 5.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)

    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.item]
        //cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Grab the DetailVC from storyboard
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("SentMemesCollectionViewController") as! SentMemesCollectionViewController
        
        //Populate VC with data from selected item
        detailController.meme = self.memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
