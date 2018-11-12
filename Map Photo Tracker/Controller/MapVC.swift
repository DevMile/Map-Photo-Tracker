//
//  MapVC.swift
//  Map Photo Tracker
//
//  Created by Milan Bojic on 11/12/18.
//  Copyright © 2018 Milan Bojic. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    @IBAction func mapBtn(_ sender: Any) {
    }


}

extension MapVC: MKMapViewDelegate {
    
}
