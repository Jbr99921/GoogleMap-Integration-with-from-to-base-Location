//
//  GoogleMapViewController.swift
//  MapView
//
//  Created by Mac Mini Old on 07/12/18.
//  Copyright © 2018 Mac Mini Old. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Location {
    case startLocation
    case destinationLocation
}

class GoogleMapViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate{
  
    @IBOutlet var GoogleMaps: GMSMapView!
    @IBOutlet var BtnPickUp: UIButton!
    @IBOutlet var BtnDropOff: UIButton!
    @IBOutlet var BtnShowDirection: UIButton!
    @IBOutlet var txtPickUp: UITextField!
    @IBOutlet var txtdrop: UITextField!
    
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    var markerSquirtFrom = GMSMarker()
    let markerSquirtTo = GMSMarker()
    let markerCars = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Your map initiation code
//        let camera = GMSCameraPosition.camera(withLatitude: 23.033863, longitude: 72.585022, zoom: 15.0)
//
//        self.GoogleMaps.camera = camera
        self.GoogleMaps.delegate = self
        self.GoogleMaps?.isMyLocationEnabled = true
        self.GoogleMaps.settings.myLocationButton = true
        self.GoogleMaps.settings.compassButton = true
        self.GoogleMaps.settings.zoomGestures = true
        
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = GoogleMaps
    }
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        let LocationR = locations.last
       // let location = locations.last
    
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10.0)
        
       // let locationX = CLLocation(latitude: 23.033863, longitude: 72.585022)
        
        createMarker(titleMarker: "Current", iconMarker:#imageLiteral(resourceName: "location-pinS") , latitude: (LocationR?.coordinate.latitude)!, longitude: (LocationR?.coordinate.longitude)!)
        
        createMarker(titleMarker: "New Location", iconMarker: #imageLiteral(resourceName: "location-pinS") , latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        
        drawPath(startLocation: location!, endLocation: LocationR!)
        
      
        self.GoogleMaps.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        GoogleMaps.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        GoogleMaps.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        GoogleMaps.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        GoogleMaps.isMyLocationEnabled = true
        GoogleMaps.selectedMarker = nil
        return false
    }
    
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
       // self.GoogleMaps.clear()
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
    
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDZajknK0aWEFpqbOnHah7Ji9rp6aW4EMo"
        
        request(url).responseJSON { response in
            
            let json = response.result.value
            print(json!)
            let polyline1 = GMSPolyline()
            polyline1.map = nil
            
            let routes = (json as AnyObject).value(forKey: "routes") as! NSArray
            let path = GMSPath.init(fromEncodedPath: "")
            
            let polyline = GMSPolyline.init(path: path)
            polyline.map = self.GoogleMaps
            
            for route in routes
            {
                let routeOverviewPolyline = (route as AnyObject) .value(forKey: "overview_polyline") as! NSDictionary
                let points = (routeOverviewPolyline  as AnyObject) .value(forKey: "points") as! String
                let path = GMSPath.init(fromEncodedPath: points)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor.init(red: 0.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                polyline.map = self.GoogleMaps
            }
            let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origin)&destinations=\(destination)&key=AIzaSyAkllRid8_jVeIaq-OW6ilaYWURbn59GoE"
            
            request(url).responseJSON { response in
             
                let json = response.result.value
                print(json!)
               
                let routes = (json as AnyObject).value(forKey: "rows") as! NSArray
                if routes.count>0
                {
                    let dic = routes[0] as! NSDictionary
                    let arr = dic.object(forKey: "elements") as! NSArray
                    
                    let str : String  = ((arr[0] as AnyObject).value(forKey: "status") as! String)
                    
                    if str != "NOT_FOUND" && str != "ZERO_RESULTS"
                    {
                        let distance = ((arr[0] as AnyObject).value(forKey: "distance") as AnyObject).value(forKey: "text") as! String
                    
                        self.markerSquirtTo.title = distance
                        
                    }
                    else
                    {
                        print(str)
                        
                    }
                }
                var bounds = GMSCoordinateBounds()
                bounds = bounds.includingCoordinate(self.markerSquirtFrom.position)
                bounds = bounds.includingCoordinate(self.markerSquirtTo.position)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
                self.GoogleMaps.animate(with: update)
                
            }
    }
//        Alamofire.request(url).responseJSON { response in
//
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // HTTP URL response
//            print(response.data as Any)     // server data
//            print(response.result as Any)   // result of response serialization
//
//            let json = try! JSON(data: response.data!)
////            let routes = json["routes"].arrayValue
//            let routes = json["routes"].arrayValue
//            // print route using Polyline
//
//
//            for route in routes
//            {
//                let routeOverviewPolyline = route["overview_polyline"].dictionary
//                let points = routeOverviewPolyline?["points"]?.stringValue
//                let path = GMSPath.init(fromEncodedPath: points!)
//
//                let polyline = GMSPolyline(path: path)
//                polyline.strokeColor = .gray
//                polyline.strokeWidth = 4.0
//                polyline.map = self.GoogleMaps
//
//            }
        
}
    @IBAction func BtnPickUP(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    @IBAction func BtnDrop(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .destinationLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func BtnShowDirection(_ sender: UIButton) {

        self.drawPath(startLocation: locationStart, endLocation:locationEnd)
    }
    
    
    //MARK:- ============================ MAP VIEW ==========================
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error \(error)")
        
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        
        if locationSelected == .startLocation {
            txtPickUp.text = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "PickUp", iconMarker: #imageLiteral(resourceName: "location-pinS"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        } else {
            txtdrop.text = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "DropOff", iconMarker: #imageLiteral(resourceName: "location-pinS"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        self.GoogleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
public extension UISearchBar {
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
