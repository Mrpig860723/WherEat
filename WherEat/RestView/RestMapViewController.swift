//
//  RestMapViewController.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/9.
//

import UIKit
import MapKit
import CoreLocation

class RestMapViewController: UIViewController {
    
    var lat: CGFloat = 0.00
    var lng: CGFloat = 0.00
    var name: String = ""
    var mainMap = MKMapView()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        mainMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mainMap.showsUserLocation = true
        setAnnotation()
        setBackBtn()
        navigationItem.title = "\(name)"
    }
   
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainMap.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        self.view.addSubview(mainMap)
    }
    
    func setAnnotation() {
        let mainAnnotation = MKPointAnnotation()
        mainAnnotation.title = name
        mainAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mainMap.addAnnotation(mainAnnotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    
}

extension RestMapViewController: MKMapViewDelegate {
    
}

extension RestMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]) {
        let currentLocation :CLLocation =
              locations[0] as CLLocation
        //總縮放範圍
        let range:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

        //自身
        let myLocation = currentLocation.coordinate
        let appearRegion:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: range)
        
        //在地圖上顯示
        mainMap.setRegion(appearRegion, animated: true)
    }
}
