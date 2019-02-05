//
//  LocationSearchTable.swift
//  MapView
//
//  Created by Mac Mini Old on 07/12/18.
//  Copyright © 2018 Mac Mini Old. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController{
  
//    var resultSearchController:UISearchController? = nil
//    var matchingItems:[MKMapItem] = []
//    var mapView: MKMapView? = nil
//    var handleMapSearchDelegate:HandleMapSearch? = nil
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController?.searchResultsUpdater = locationSearchTable
//        locationSearchTable.mapView = mapView
//        locationSearchTable.handleMapSearchDelegate = self as! HandleMapSearch
    }
//    func parseAddress(selectedItem:MKPlacemark) -> String {
//        // put a space between "4" and "Melrose Place"
//        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
//        // put a comma between street and city/state
//        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
//        // put a space between "Washington" and "DC"
//        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
//        let addressLine = String(
//            format:"%@%@%@%@%@%@%@",
//            // street number
//            selectedItem.subThoroughfare ?? "",
//            firstSpace,
//            // street name
//            selectedItem.thoroughfare ?? "",
//            comma,
//            // city
//            selectedItem.locality ?? "",
//            secondSpace,
//            // state
//            selectedItem.administrativeArea ?? ""
//        )
//        return addressLine
//    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return matchingItems.count
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       let cell = tableView.dequeueReusableCell(withIdentifier: "TblCell", for: indexPath) as! TblCell
//
//        let selectedItem = matchingItems[indexPath.row].placemark
//        cell.LblLocationname.text = selectedItem.name
//        cell.textLabel?.text = selectedItem.name
//        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
//     //   cell.detailTextLabel?.text = ""
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedItem = matchingItems[indexPath.row].placemark
////        HandleMapSearch.dropPinZoomIn(selectedItem)
//
//       self.dismiss(animated: true, completion: nil)
//
//    }
//
//}
//extension LocationSearchTable : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let mapView = mapView,
//            let searchBarText = searchController.searchBar.text else { return }
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = searchBarText
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            self.matchingItems = response.mapItems
//            self.tableView.reloadData()
//        }
//    }
}
