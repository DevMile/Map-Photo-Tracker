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
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    var passedImage: UIImage!
    var passedTitle = ""
    var passedDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
        imageTitle.text = passedTitle
        imageDescription.text = passedDescription
        addDoubleTap()

    }
    
    func receiveData(forImage image: UIImage, imageTitle title: String, imageDescription description: String) {
        self.passedImage = image
        self.passedTitle = title
        self.passedDescription = description
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
