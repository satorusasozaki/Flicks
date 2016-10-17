//
//  FlicksTableViewController.swift
//  Flicks
//
//  Created by Satoru Sasozaki on 10/17/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
//import AFNetworking
import MBProgressHUD
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}


class MoviesMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var tableView : UITableView?
    var mainCellIdentifier : String?
    var movies : [NSDictionary]?
    var refreshControl : UIRefreshControl?
    var endpoint : String?
    var searchBar : UISearchBar?
    var isSearching : Bool?
    var moviesFound : [Movie]?
    var errorMessageView : ErrorMessageView?
    var isNetworkError : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCellIdentifier = "mainCell"
        
        // Setup tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.plain)
        tableView?.rowHeight = 150
        tableView?.delegate = self
        tableView?.dataSource = self
        self.tableView?.register(FlicksTableViewCell.self, forCellReuseIdentifier: mainCellIdentifier!)
        self.view.addSubview(tableView!)
        
        // Setup refreshControl
        // https://guides.codepath.com/ios/Table-View-Guide#adding-pull-to-refresh
        refreshControl =  UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(MoviesMainViewController.refreshTableView(_:)), for: UIControlEvents.valueChanged)
        tableView?.insertSubview(refreshControl!, at: 0)
        
        // Search Bar
        configureSearchBar()
        isSearching = false
        moviesFound = []
        
        // Configure error message view
        errorMessageView = ErrorMessageView(frame: CGRect(x: 0,y: 64, width: self.view.frame.width, height: 20))
        errorMessageView?.isHidden = true
        self.view.addSubview(errorMessageView!)
        isNetworkError = false
        
        getMovies(1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.endEditing(true)
        searchBar?.endEditing(true)
    }
    
    // MARK: TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearching!) {
            return moviesFound!.count
        } else {
            if let movies = movies {
                return movies.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier!, for: indexPath) as! FlicksTableViewCell
        
        if(isSearching! && moviesFound!.count != 0) {
            let movieFound = moviesFound![indexPath.row]
            cell.configureMovieInfo(movieInfo: movieFound)
        } else {
            let movie = Movie(fromDictionary: movies![indexPath.row])
            cell.configureMovieInfo(movieInfo: movie)
        }
        
        return cell
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let flicksDetailsController = FlicksDetailsController()
        let cell = tableView.cellForRow(at: indexPath) as! FlicksTableViewCell
        flicksDetailsController.movie = cell.movie
        self.navigationController?.pushViewController(flicksDetailsController, animated: true)
    }
    
    // MARK: Refresh Control
    // Do not forget to pass sender object when implement target action method
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        getMovies(2)
        if(isNetworkError!) {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: Search Bar
    func configureSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: 20))
        searchBar?.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView: searchBar!)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isNetworkError! {
            print("Network Error")
        } else if searchBar.text!.isEmpty {
            isSearching = false
            moviesFound?.removeAll()
            searchBar.endEditing(true)
            tableView!.reloadData()
        } else {
            isSearching = true
            moviesFound?.removeAll()
            for i in 0..<(movies?.count)! {
                let movieAsDictionary = movies![i]
                let currentMovie = Movie(fromDictionary: movieAsDictionary)
                let currentTitle = currentMovie.title
                if currentTitle?.lowercased().range(of: searchText.lowercased()) != nil {
                    moviesFound?.append(currentMovie)
                }
            }
            tableView!.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true;
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.view.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        isSearching = false;
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //self.view.endEditing(true)
        moviesFound?.removeAll()
        searchBar.endEditing(true)
        isSearching = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.view.endEditing(true)
        searchBar.endEditing(true)
        isSearching = false;
    }
    
    // MARK: Configure segmentedControl
    
    // MARK: API Call
    func getMovies(_ whichCall : Int) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        // Show progress HUD
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request,
                                                         completionHandler:  { (dataOrNil, response, error) in
                                                            if(error != nil){
                                                                self.errorMessageView?.isHidden = false
                                                                self.isNetworkError = true
                                                            }
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                                                    NSLog("response: \(responseDictionary)")
                                                                    switch whichCall {
                                                                    case 1:
                                                                        self.movies = responseDictionary["results"] as? [NSDictionary]
                                                                    case 2:
                                                                        self.movies = responseDictionary["results"] as? [NSDictionary]
                                                                        self.refreshControl?.endRefreshing()
                                                                    default:
                                                                        NSLog("In default of switch statement")
                                                                    }
                                                                    // Hide progress HUD
                                                                    self.errorMessageView?.isHidden = true
                                                                    self.isNetworkError = false
                                                                    
                                                                }
                                                            }
                                                            
                                                            MBProgressHUD.hide(for: self.view, animated: true)
                                                            self.tableView?.reloadData()
        });
        task.resume()
    }
}

