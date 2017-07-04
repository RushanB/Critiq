//
//  GoogleMapsViewController.swift
//  Critiq
//
//  Created by Rushan on 2017-07-04.
//  Copyright © 2017 RushanBenazir. All rights reserved.
//

import UIKit
import GoogleMaps

class CustomDestination: NSObject{
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float){
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}

class GoogleMapsViewController: UIViewController {

    var mapView: GMSMapView?
    
    //current destination
    var currentDestination: CustomDestination?
    
    //array of destinations
    let destinations = [CustomDestination(name: "University of Toronto (UTSG)", location:CLLocationCoordinate2DMake(43.662853, -79.395699) , zoom: 18), CustomDestination(name: "U of T Bookstore", location: CLLocationCoordinate2DMake(43.658777, -79.397136), zoom: 18)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(GoogleMapsViewController.nextLocation))
    }
    
    func setupMap(){
        GMSServices.provideAPIKey(GoogleMapsKey)
        //set the camera position
        let camera = GMSCameraPosition.camera(withLatitude: 43.644612, longitude: -79.395251, zoom: 15)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        //        mapView.mapType =
        mapView?.isIndoorEnabled = true //allows to see inside
        mapView?.accessibilityElementsHidden = false  //allows to see hidden elements
        mapView?.isMyLocationEnabled = true //allows to track users location
        
        self.view = mapView
        
        let currentLocation = CLLocationCoordinate2DMake(43.644612, -79.395251)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Lighthouse Labs"
        marker.map = mapView
        
    }
    
    func nextLocation(){
        
        if currentDestination == nil {
            currentDestination = destinations.first
            
        } else {
            
            if let index = destinations.index(of: currentDestination!){
                currentDestination = destinations[index + 1]
                
            }
        }
        
        setMapCamera()
    }
    
    private func setMapCamera(){
        //time it takes to move from one locaiton to another
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        
        //animate from one location to another
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: currentDestination!.location, zoom: currentDestination!.zoom))
        
        CATransaction.commit()//end of transaction
        
        let marker = GMSMarker(position: currentDestination!.location)
        marker.title = currentDestination?.name
        //marker.snippet = "St. George Campus (UTSG)"
        marker.map = mapView
    }
}
