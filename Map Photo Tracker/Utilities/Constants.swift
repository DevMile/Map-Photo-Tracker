//
//  Constants.swift
//  Map Photo Tracker
//
//  Created by Milan Bojic on 11/14/18.
//  Copyright © 2018 Milan Bojic. All rights reserved.
//

import Foundation

let apiKey = "957767c9c7566ae9b4381e404230828a"

func flickrUrl(forApiKey apiKey: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=0.5&radius_units=km&per_page=\(number)&extras=description&format=json&nojsoncallback=1"
}
