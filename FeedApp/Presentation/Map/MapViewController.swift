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

        // Do any additional setup after loading the view.
    }
}
