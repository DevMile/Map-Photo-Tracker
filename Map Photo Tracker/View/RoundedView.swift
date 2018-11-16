//
//  RoundedView.swift
//  Map Photo Tracker
//
//  Created by Milan Bojic on 11/16/18.
//  Copyright © 2018 Milan Bojic. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    var cornerRadius: CGFloat = 5.0 {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
