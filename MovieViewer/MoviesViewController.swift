//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by jason on 10/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
        
        
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
                                                                self.errocCallback(requestError)
                                                            } else {
                                                                if let data = dataOrNil {
                                                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                        with: data, options:[]) as? NSDictionary {
                                                                        NSLog("response: \(responseDictionary)")
                                                                        self.successCallback(data: responseDictionary)
                                                                    }
                                                                }
                                                            }
        });
        task.resume()
        
        
    }
    
    func errocCallback(_ error: Error){
        // print(error);
    }
    
    func successCallback( data: NSDictionary){
        print(data);
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath);
        
        let title = self.movies?[indexPath.row]["title"]
        
        cell.textLabel?.text = title as? String;
        return cell;
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
