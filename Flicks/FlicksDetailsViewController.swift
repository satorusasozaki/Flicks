//
//  FlicksDetailsViewController.swift
//  Flicks
//
//  Created by Satoru Sasozaki on 10/17/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import AFNetworking

class FlicksDetailsController: UIViewController {
    var movie : Movie?
    var imageUrl : URL?
    var posterView : UIImageView?
    var detailView : UIView?
    var titleLabel : UILabel?
    var overviewLabel : UILabel?
    var scrollView : UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        self.view.backgroundColor = UIColor.black
        configurePosterView()
        configureScrollView()
        configureDetailView()
        configureTitleLabel()
        configureOverViewLabel()
    }
    
    // MARK: View Components
    func configurePosterView() {
        // Configure posterView
        posterView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        //posterView?.setImageWith(movie!.imageUrl!)
        if let imageUrl = movie?.imageUrl {
            posterView?.setImageWith(imageUrl)
        } else {
            posterView?.image = nil
        }
        self.view.addSubview(posterView!)
    }
    
    func configureScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 35, y: 250, width: 300, height: 400))
        scrollView?.contentSize = CGSize(width:0, height: 600)
        scrollView?.contentOffset = CGPoint(x: 0, y: 0)
        //scrollView?.backgroundColor = UIColor.blueColor()
        scrollView?.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView!)
    }
    
    func configureDetailView() {
        // Configure detail generic as a container for titleLabel and overViewLabel
        detailView = UIView(frame: CGRect(x: 0, y: 325, width: 300, height: 250))
        detailView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.scrollView!.addSubview(detailView!)
    }
    
    func configureTitleLabel() {
        // Configure titleLabel
        titleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: self.detailView!.frame.width-10, height: 30))
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel?.textColor = UIColor.white
        //titleLabel?.adjustsFontSizeToFitWidth
        self.detailView!.addSubview(titleLabel!)
        titleLabel?.text = movie?.title
    }
    
    func configureOverViewLabel() {
        let font = UIFont(name: "Helvetica", size: 15)
        // Calculate UILabel height to fit to text
        let height = heightForView((movie?.overview)!, font: font!, width: self.detailView!.frame.width-10)
        // Configure overviewLabel
        overviewLabel = UILabel(frame: CGRect(x: 5, y: 30, width: self.detailView!.frame.width-10, height: height))
        overviewLabel?.textColor = UIColor.white
        overviewLabel?.font = UIFont.systemFont(ofSize: 15)
        self.detailView!.addSubview(overviewLabel!)
        overviewLabel?.text = movie?.overview
        overviewLabel?.numberOfLines = 0
    }
    
    // Get UILabel height from the size of a string
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height+20
    }
    
}
