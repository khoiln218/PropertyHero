//
//  MapProductCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapProductCell: PageTableCell {
    private var mapView: GMSMapView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewmodel: Product) {
        self.address.text = viewmodel.Address
        let camera = GMSCameraPosition.camera(withLatitude: viewmodel.Latitude, longitude: viewmodel.Longitude, zoom: 15)
        
        self.mapView = GMSMapView.map(withFrame: self.container.frame, camera: camera)
        self.container.insertSubview(mapView, at: 0)
        
        let circ = GMSCircle(position: CLLocationCoordinate2D(latitude: viewmodel.Latitude, longitude: viewmodel.Longitude), radius: 80)
        circ.fillColor = UIColor(hex: "#FFC000")
        circ.strokeColor = .white
        circ.strokeWidth = 3;
        circ.map = self.mapView;
        updateMapView()
    }
    
    func updateMapView() {
        self.mapView.frame.size.width = Dimension.SCREEN_WIDTH
        self.mapView.frame.size.height = Dimension.SCREEN_WIDTH * 2 / 3
    }
}
