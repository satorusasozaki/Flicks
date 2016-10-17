//
//  FlicksTableViewCell.swift
//  Flicks
//
//  Created by Satoru Sasozaki on 10/17/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
// import AFNetworking

class FlicksTableViewCell : UITableViewCell {
    
    var titleLabel : UILabel?
    var overviewLabel : UILabel?
    var posterView : UIImageView?
    var imageUrl : URL?
    var movie : Movie?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        configureTitleLabel()
        configureOverviewLable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitleLabel() {
        titleLabel = UILabel(frame: CGRect(x: 110, y: 0, width: 250, height: 40))
        titleLabel?.numberOfLines = 1
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.contentView.addSubview(titleLabel!)
    }
    
    func configureOverviewLable() {
        overviewLabel = UILabel(frame: CGRect(x: 110, y: 40, width: 250,height: 100))
        overviewLabel?.numberOfLines = 0
        overviewLabel?.font = overviewLabel?.font.withSize(10)
        self.contentView.addSubview(overviewLabel!)
    }
    
    func configurePosterView(_ url : URL) {
        imageUrl = url
        posterView = UIImageView(frame: CGRect(x: 0, y: 5, width: 100, height: 140))
        posterView?.setImageWith(url)
        self.addSubview(posterView!)
    }
    
    func configureMovieInfo(movieInfo movie: Movie) {
        self.movie = movie
        self.titleLabel?.text = movie.title
        self.overviewLabel?.text = movie.overview
        if let imageUrl = movie.imageUrl {
            self.configurePosterView(imageUrl)
        }
    }
}
