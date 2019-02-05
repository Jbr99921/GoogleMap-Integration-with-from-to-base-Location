//
//  Destination.swift
//  MapView
//
//  Created by Mac Mini Old on 07/12/18.
//  Copyright © 2018 Mac Mini Old. All rights reserved.
//

import Foundation
import MapKit

class Destination:NSObject,MKAnnotation{
    let title: String?
    let locationName:String
    let discipline:String
    let coordinate: CLLocationCoordinate2D
    
    init(title:String,locationName:String,discipline:String,coordinate:CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    var subtitle: String?{
    return locationName
    }
}
