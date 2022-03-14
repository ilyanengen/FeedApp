//
//  MapViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 14.03.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    
    private let feedItem: FeedItem
    
    init(feedItem: FeedItem) {
        self.feedItem = feedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.title = feedItem.name
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: feedItem.lat,
            longitude: feedItem.lon
        )
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: Constants.Map.radiusInMeters,
            longitudinalMeters: Constants.Map.radiusInMeters
        )
        mapView.setRegion(region, animated: true)
    }
}
