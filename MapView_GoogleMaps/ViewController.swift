//
//  ViewController.swift
//  MapView_GoogleMaps
//
//  Created by Timothy Hull on 2/26/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import WebKit


class ViewController: UIViewController, GMSMapViewDelegate, WKNavigationDelegate, CLLocationManagerDelegate {
    

    var webView: WKWebView!
    var placesClient: GMSPlacesClient!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        webView = WKWebView()

        
        // Start camera @ TurnToTech
        let camera = GMSCameraPosition.camera(withLatitude: 40.708637, longitude: -74.014839, zoom: 18)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        navigationItem.title = "TurnToTech"

        view = mapView
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        

    
        // Markers
        let tttMarker = GMSMarker()
        tttMarker.position = CLLocationCoordinate2D(latitude: 40.708637, longitude: -74.014839)
        tttMarker.title = "TurnToTech"
        tttMarker.snippet = "iOS Development School"
        tttMarker.map = mapView
        
        let fridaysMarker = GMSMarker()
        fridaysMarker.position = CLLocationCoordinate2D(latitude: 40.706729, longitude: -74.013032)
        fridaysMarker.title = "TGI Friday's"
        fridaysMarker.snippet = "Thoroughly Average Chain Restaurant"
        fridaysMarker.map = mapView
        
        let georgesMarker = GMSMarker()
        georgesMarker.position = CLLocationCoordinate2D(latitude: 40.707518, longitude: -74.013343)
        georgesMarker.title = "George's"
        georgesMarker.snippet = "Old School Diner"
        georgesMarker.map = mapView
        
        let reserveCutMarker = GMSMarker()
        reserveCutMarker.position = CLLocationCoordinate2D(latitude: 40.706046, longitude: -74.012131)
        reserveCutMarker.title = "Reserve Cut"
        reserveCutMarker.snippet = "Kosher Steakhouse"
        reserveCutMarker.map = mapView
        
        let oHarasMarker = GMSMarker()
        oHarasMarker.position = CLLocationCoordinate2D(latitude: 40.709519, longitude: -74.012667)
        oHarasMarker.title = "O'Hara's"
        oHarasMarker.snippet = "Irish Pub"
        oHarasMarker.map = mapView
        
        let billsMarker = GMSMarker()
        billsMarker.position = CLLocationCoordinate2D(latitude: 40.709453, longitude: -74.014053)
        billsMarker.title = "Bill's Bar & Burger"
        billsMarker.snippet = "Bar founded by Bill that also has burgers"
        billsMarker.map = mapView

        
        // TTT logo
        view.addSubview(turnToTechLogo)
        turnToTechLogo.translatesAutoresizingMaskIntoConstraints = false
        turnToTechLogo.widthAnchor.constraint(equalToConstant: 40).isActive = true
        turnToTechLogo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        turnToTechLogo.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        turnToTechLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true

        // Search button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(pickPlace))

        
        // Night map style
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
    }
    
    
    
    
    
    lazy var turnToTechLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TTT")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        // Shadows bc shadows are dope
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 8
        
        // Cache the rendered shadow so it doesn't need to be redrawn every run
        imageView.layer.shouldRasterize = true
        
        return imageView
    }()
    
    
    
    

// MARK: - Search
    func pickPlace() {
        let center = CLLocationCoordinate2D(latitude: 40.708637, longitude: -74.014839)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.navigationItem.title = place.name
                
                let camera = GMSCameraPosition.camera(withLatitude: 40.708637, longitude: -74.014839, zoom: 18)
                
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                self.view = mapView
                
            } else {
                self.navigationItem.title = "No place selected"
            }
        })
    }
    
    
    
    
    
    
    
// MARK: - Annotation Images
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        let placeName = marker.title!
        
        
        
        switch placeName {
        case "TGI Friday's":
            customInfoWindow.nameLbl.text = "TGI Friday's"
            customInfoWindow.detailLabel.text = "Thoroughly Average Chain Restaurant"
            customInfoWindow.placeImage.image = UIImage(named: "fridays")
            self.navigationItem.title = "TGI Friday's"
        case "George's":
            customInfoWindow.nameLbl.text = "George's"
            customInfoWindow.detailLabel.text = "Old School Diner"
            customInfoWindow.placeImage.image = UIImage(named: "georges")
            self.navigationItem.title = "George's"
        case "Reserve Cut":
            customInfoWindow.nameLbl.text = "Reserve Cut"
            customInfoWindow.detailLabel.text = "Kosher Steakhouse"
            customInfoWindow.placeImage.image = UIImage(named: "reserveCut")
            self.navigationItem.title = "Reserve Cut"
        case "O'Hara's":
            customInfoWindow.nameLbl.text = "O'Hara's"
            customInfoWindow.detailLabel.text = "Irish Pub"
            customInfoWindow.placeImage.image = UIImage(named: "oharas")
            self.navigationItem.title = "O'Hara's"
        case "Bill's Bar & Burger":
            customInfoWindow.nameLbl.text = "Bill's Bar & Burger"
            customInfoWindow.detailLabel.text = "Bar founded by Bill that also has burgers"
            customInfoWindow.placeImage.image = UIImage(named: "bills")
            self.navigationItem.title = "Bill's Bar & Burger"
        default:
            customInfoWindow.nameLbl.text = "TurnToTech"
            customInfoWindow.detailLabel.text = "iOS Development School"
            customInfoWindow.placeImage.image = UIImage(named: "TTT")
            self.navigationItem.title = "TurnToTech"
        }
        
        return customInfoWindow
    }
    
    
    
    
    
    
    
    
// MARK: - WebView

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let placeName = marker.title!
        
        switch placeName {
        case "TurnToTech":
            if let tttUrl = URL(string: "http://turntotech.io") {
                self.webView.load(URLRequest(url: tttUrl))
            }
        case "George's":
            if let georgesUrl = URL(string: "http://www.georges-ny.com") {
                self.webView.load(URLRequest(url: georgesUrl))
            }
        case "TGI Friday's":
            if let fridaysUrl = URL(string: "https://www.tgifridays.com") {
                self.webView.load(URLRequest(url: fridaysUrl))
            }
        case "Reserve Cut":
            if let rcUrl = URL(string: "http://reservecut.com") {
                self.webView.load(URLRequest(url: rcUrl))
            }
        case "Bill's Bar & Burger":
            if let billsUrl = URL(string: "http://www.billsbarandburger.com") {
                self.webView.load(URLRequest(url: billsUrl))
            }
        default:
            if let oharasUrl = URL(string: "http://www.oharaspubnyc.com") {
                self.webView.load(URLRequest(url: oharasUrl))
            }
        }
        
        webView.allowsBackForwardNavigationGestures = false
        self.view = webView
        
        
         // return to map
        var backButton = UIImage(named: "back")
        backButton = backButton?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleReturn))
        navigationItem.title = "Restaurant Webpage"
    }
    

    
    func handleReturn() {
        let viewController = ViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    


    
    
    
    
    
    

}





