//
//  DroppablePin.swift
//  Map Photo Tracker
//
//  Created by Milan Bojic on 11/13/18.
//  Copyright © 2018 Milan Bojic. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
