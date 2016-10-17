//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by jason on 10/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var networkError: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkError.isHidden = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
        
        self.activityIndicator()
        
        
        
        //
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.tintColor = UIColor.yellow

        
        self.navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont(name: "BradleyHandITCTT-Bold", size: 36)!,
              NSForegroundColorAttributeName: UIColor.yellow])

        
        

        self.loadData()
     
        // Pull to refresh
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        //     tableView.insertSubview(refreshControl, atIndex: 0)

    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 50, height: 50) ) // CGRect(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func loadData(_ doneLoading: (() -> Void )! = nil ){
        print("SHOW INDICATOR")
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        
        
        let clientId = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        // Make sure there is no leading or trailing spaces, probably not wise to force unwrap via !:
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")
        
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,
                                                         completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                                                            if let requestError = errorOrNil {
                                                                print("NETWORK ERROR")
                                                                self.errocCallback(requestError)
                                                                self.indicator.stopAnimating()
                                                                self.indicator.hidesWhenStopped = true
                                                                self.networkError.isHidden = false
                                                                if(doneLoading != nil){
                                                                    doneLoading()
                                                                }
                                                                
                                                            } else {
                                                                self.networkError.isHidden = true
                                                                self.indicator.stopAnimating()
                                                                self.indicator.hidesWhenStopped = true
                                                                if let data = dataOrNil {
                                                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                        with: data, options:[]) as? NSDictionary {
                                                                       // NSLog("response: \(responseDictionary)")
                                                                        self.successCallback(data: responseDictionary)
                                                                    }
                                                                }
                                                                if(doneLoading != nil){
                                                                    doneLoading()
                                                                }
                                                            }
        });
        task.resume()
        
    }
    
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        print("REFRESSHING")
        self.loadData({() -> Void in
            self.refreshControl.endRefreshing() // TODO: move to right place
            
        })
      
    }
    
    /*
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.red
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.black
        cell?.contentView.backgroundColor = UIColor.yellow
    }

    */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func errocCallback(_ error: Error){
        // print(error);
    }
    
    func successCallback( data: NSDictionary){
        //print(data);
        self.movies = data["results"] as? [NSDictionary]
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = self.movies{
            return movies.count
        } else{
            return 0;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = backgroundView
        
        //
        
        // cell.setHighlighted(true, animated: true)
        //
        
        let title = self.movies?[indexPath.row]["title"]
        let overview = self.movies?[indexPath.row]["overview"] as? String
        
        let posterPathSource = self.movies?[indexPath.row]["poster_path"]
        
        // TODO: clear the poster iamge
        
        if let posterPath = posterPathSource as? String{
        
            print(posterPath)
            let baseURL = "https://image.tmdb.org/t/p/w500"
            
            let imgURL = NSURL(string: "\(baseURL)\(posterPath)")
            print(imgURL)
            let imageRequest = NSURLRequest(url: imgURL as! URL)

            
            cell.posterImage.setImageWith(imageRequest as URLRequest,
                                          
                                          
                                          
                                          placeholderImage: nil,
                                          success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                                            
                                            // smallImageResponse will be nil if the smallImage is already available
                                            // in cache (might want to do something smarter in that case).
                                             cell.posterImage.alpha = 0.0
                                             cell.posterImage.image = smallImage;
                                            
                                            UIView.animate(withDuration: 1.3, animations: { () -> Void in
                                                
                                                cell.posterImage.alpha = 1.0
                                                
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
        
        
        
        cell.title?.text = title as? String;
        cell.overview?.text = overview
        
        return cell;
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("About to segue")
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        
        let movie = movies![indexPath!.row]
        let detailsViewControlelr = segue.destination as! MovieDetailsViewController
        detailsViewControlelr.movie = movie
        
        
        
     }
    
    
}
