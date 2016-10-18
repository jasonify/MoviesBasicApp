//
//  MovieCell.swift
//  MovieViewer
//
//  Created by jason on 10/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected){
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.red
            self.selectedBackgroundView = backgroundView
        }
        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool){
        super.setHighlighted(highlighted, animated: animated)
        
        
        if(highlighted){
            title.textColor = UIColor.yellow
            overview.textColor = UIColor.yellow
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.green
            self.backgroundColor = UIColor.black
        } else{
            self.backgroundColor = UIColor.white

            title.textColor = UIColor.black
            overview.textColor = UIColor.black
 
        }
    }

}
