//
//  ViewController.swift
//  SitePoint-UICollectionView
//
//  Created by Klevis Davidhi on 11/6/16.
//  Copyright © 2016 Klevis Davidhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let screenSize: CGRect = UIScreen.main.bounds
    var foodArray : [UIImage] = [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage()]
    
    let url : String = "https://s-media-cache-ak0.pinimg.com/736x/19/d0/35/19d0354e13202322f8c84e4d459667d5.jpg"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // print(urlArray.count)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
      
            
            getDataFromUrl(url: URL(string: url)!) { (data, response, error)  in
                guard let data = data, error == nil else {
                    return
                }
                 for index in 0...4{
                self.foodArray[index]  =  UIImage(data: data)!
                }
                DispatchQueue.main.async() { () -> Void in
                    self.collectionView.reloadData()
                }
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let foodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! collectionViewCell
        
        foodCell.foodImage.image = foodArray[indexPath.row]
        
        return foodCell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            getDataFromUrl(url: URL(string: url)!) { (data, response, error)  in
                guard let data = data, error == nil else {
                    return
                }
                //DispatchQueue.main.async() { () -> Void in
                self.foodArray[indexPath.row]  =  UIImage(data: data)!
                //}
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            self.foodArray[indexPath.row] = UIImage()
        }
    }

     func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width:screenSize.width ,height: screenSize.height * 0.3)
    }
    
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
