//
//  MapVC.swift
//  Map Photo Tracker
//
//  Created by Milan Bojic on 11/12/18.
//  Copyright © 2018 Milan Bojic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpViewHeight: NSLayoutConstraint!
    // location service
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    // map
    let regionRadius: Double = 1000
    var spinner: UIActivityIndicatorView?
    var progressLabel: UILabel?
    let screenSize = UIScreen.main.bounds
    // photos
    var imageUrlArray = [String]()
    // collection view
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
        // setting up collection view
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        pullUpView.addSubview(collectionView!)
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)
    }
    // MARK: - pullUpView methods
    func animateViewUp() {
        pullUpViewHeight.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        pullUpViewHeight.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLabel() {
        progressLabel = UILabel()
        progressLabel?.frame = CGRect(x: (screenSize.width / 2) - 125, y: 175, width: 250, height: 40)
        progressLabel?.font = UIFont(name: "Avenir Next", size: 18)
        progressLabel?.textColor = #colorLiteral(red: 0.1780119724, green: 0.1927374526, blue: 0.2141299175, alpha: 1)
        progressLabel?.textAlignment = .center
        progressLabel?.text = "12/40 PHOTOS LOADED"
        collectionView?.addSubview(progressLabel!)
    }
    
    func removeProgressLabel() {
        if progressLabel != nil {
            progressLabel?.removeFromSuperview()
        }
    }
    
    @IBAction func mapBtn(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    // MARK: - Alamofire requests
    func retreiveUrls(forAnnotation annotation: DroppablePin, handler: @escaping (_ status: Bool) -> ()) {
        imageUrlArray = []
        Alamofire.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, andNumberOfPhotos: 20)).responseJSON { (response) in
            guard let json = response.result.value as? [String:AnyObject] else {return}
            let photosDict = json["photos"] as! [String:AnyObject]
            let photosDictArray = photosDict["photo"] as! [[String:AnyObject]]
            for photo in photosDictArray {
                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!).jpg"
                self.imageUrlArray.append(postUrl)
            }
            handler(true)
        }
    }
    
}

extension MapVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin() // remove previous pin from the map
        removeSpinner()
        removeProgressLabel()
        animateViewUp() // pull up bottom view when drop pin
        addSwipe()
        addSpinner()
        addProgressLabel()
        let touchPoint = sender.location(in: mapView) // x,y coordinates on mapView
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView) // converted in lat,long coordinates
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation) // add pin
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius) // centers map to new pin location
        mapView.setRegion(coordinateRegion, animated: true)
        // get photos url's for pinned location
        retreiveUrls(forAnnotation: annotation) { (true) in
            print(self.imageUrlArray)
        }
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    // customize color and behaviour of pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // prevents modification of default starter pin
        if annotation is MKUserLocation {
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pin.pinTintColor = #colorLiteral(red: 0.929251269, green: 0.7077665773, blue: 0.2200084208, alpha: 1)
        pin.animatesDrop = true
        return pin
    }
}

extension MapVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // take items from array
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        return cell
    }
    
    
}
