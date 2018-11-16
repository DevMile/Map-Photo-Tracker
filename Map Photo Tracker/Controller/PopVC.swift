//
//  PopVC.swift
//  Map Photo Tracker
//
//  Created by Milan Bojic on 11/16/18.
//  Copyright © 2018 Milan Bojic. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var popImageView: UIImageView!
    var passedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
        addDoubleTap()

    }
    
    func receiveData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }


}
