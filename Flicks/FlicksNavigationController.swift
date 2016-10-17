//
//  FlicksViewController.swift
//  Flicks
//
//  Created by Satoru Sasozaki on 10/17/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class FlicksNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
    }
}
