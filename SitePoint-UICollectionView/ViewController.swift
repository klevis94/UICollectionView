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
    
    
    struct food{
        
        var image_array : [UIImage]?
        var source_array : [URL]?
        
        init(url: String){
            self.image_array = [UIImage](repeating: UIImage(), count: 30)
            self.source_array = [URL](repeating: URL(string: url)!,count: 30)
        }
    }
    
    
    var food_instance = food(url: "https://placehold.it")
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        

        for index in 0...4{
    
            let base_url = food_instance.source_array?[index]
            
           
            let url = url_components(baseUrl: base_url!, index: index)
            
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                self.food_instance.image_array?[index] = UIImage(data: data)!
                self.collectionView.reloadData()
            }
            }
              task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func url_components(baseUrl:URL, index: Int) -> URL {
        
        var url_components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        url_components?.path = "/\(screenSize.width)x\(screenSize.height * 0.3)"
        url_components?.query = "text=food \(index)"
        return (url_components?.url)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return food_instance.image_array!.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let foodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! collectionViewCell
        
        foodCell.foodImage.image = food_instance.image_array?[indexPath.row]
        
        return foodCell
    }

    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            
            let base_url = food_instance.source_array?[indexPath.row]
            let url = url_components(baseUrl: base_url!, index: indexPath.row)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
               
                     self.food_instance.image_array?[indexPath.row] = UIImage(data: data)!
            }
            
            task.resume()

        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            self.food_instance.image_array?[indexPath.row] = UIImage()
        }
    }
    
    
     func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width:screenSize.width ,height: screenSize.height * 0.3)
    }
    
}

