//
//  ErrorMessageView.swift
//  Flicks
//
//  Created by Satoru Sasozaki on 10/17/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class ErrorMessageView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        configureLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        let textLabel = UILabel(frame: CGRect(x: 120, y: 0, width: self.frame.width - 60, height: 20))
        textLabel.text = "Networking Error"
        textLabel.textColor = UIColor.white
        textLabel.backgroundColor = self.backgroundColor
        self.addSubview(textLabel)
    }
}
