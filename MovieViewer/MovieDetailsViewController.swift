//
//  MovieDetailsViewController.swift
//  MovieViewer
//
//  Created by jason on 10/13/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var movie :NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded view controller");
        print(movie)
        titleLabel.text = movie["title"] as? String
        overview.text = movie["overview"] as? String

        // Load image:
        
        let posterPathSource = movie["poster_path"]
        
        // TODO: clear the poster iamge
        
        if let posterPath = posterPathSource as? String{
            
            print(posterPath)
            let baseURL = "https://image.tmdb.org/t/p/w500"
            
            let imgURL = NSURL(string: "\(baseURL)\(posterPath)")
            
            
            //posterImage.setImageWith(imgURL as! URL)
            let imageRequest = NSURLRequest(url: imgURL as! URL)

            
            posterImage.setImageWith(imageRequest as URLRequest,
                                          
                                                                                  
                                          placeholderImage: nil,
                                          success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                                            
                                            // smallImageResponse will be nil if the smallImage is already available
                                            // in cache (might want to do something smarter in that case).
                                            self.posterImage.alpha = 0.0
                                            self.posterImage.image = smallImage;
                                            
                                            UIView.animate(withDuration: 1.3, animations: { () -> Void in
                                                
                                                self.posterImage.alpha = 1.0
                                                
                                                }, completion: { (sucess) -> Void in
                                                    
                                                    /*
                                                     // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                     // per ImageView. This code must be in the completion block.
                                                     self.myImageView.setImageWithURLRequest(
                                                     largeImageRequest,
                                                     placeholderImage: smallImage,
                                                     success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                                     
                                                     self.myImageView.image = largeImage;
                                                     
                                                     },
                                                     failure: { (request, response, error) -> Void in
                                                     // do something for the failure condition of the large image request
                                                     // possibly setting the ImageView's image to a default image
                                                     })
                                                     */
                                            })
                },
                                          failure: { (request, response, error) -> Void in
                                            // do something for the failure condition
                                            // possibly try to get the large image
            })
            
            
        } else{
            
            // TODO CLEAR CELL XXX: crashes..
            // cell.posterImage = nil
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
