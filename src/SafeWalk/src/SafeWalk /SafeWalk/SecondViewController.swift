//
//  SecondViewController.swift
//  SafeWalk
//
//  Created by Byron Mitchell on 12/11/19.
//  Copyright © 2019 Byron Mitchell. All rights reserved.
//
import UIKit
import MapKit
import MessageUI
import CoreLocation

class SecondViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 300
    var directionsArray: [MKDirections] = []
    let geoCoder = CLGeocoder()
    
    var previousLocation: CLLocation?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            checkLocationServices()
        }
    var timer = Timer()
    var isTimerOn = false
    var duration = 0
    var phoneNumber = 7873793060;
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Areyouoklabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var OkConfirmation: UITextField!
    
    @IBAction func yesPressed(_ sender: Any) {
        Areyouoklabel.isHidden = true
        yesButton.isHidden = true
        noButton.isHidden = true
        OkConfirmation.text="YES"
    }
    
    @IBAction func noPressed(_ sender: Any) {
        Areyouoklabel.isHidden = true
        yesButton.isHidden = true
        noButton.isHidden = true
        OkConfirmation.text=""
    }
    
    @IBAction func arrivedPressed(_ sender: Any) {
        label.isHidden = true
        timer.invalidate()
        Areyouoklabel.isHidden = true
        yesButton.isHidden = true
        noButton.isHidden = true
        mapView.removeOverlays(mapView.overlays)
        
    }
    func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        
        func centerViewOnUserLocation() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                mapView.setRegion(region, animated: true)
            }
        }
        
        
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                // Show alert letting the user know they have to turn this on.
            }
        }
        
        
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                startTrackingUserLocation()
                break
            case .denied:
                // Show alert instructing them how to turn on permissions
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Show an alert letting them know what's up
                break
            case .authorizedAlways:
                break
            default:
                break
            }
        }
    
    func getDirection() {
            guard let location = locationManager.location?.coordinate else {
                //
                return
            }
        
            let request = createDirectionsRequest(from: location)
            let directions = MKDirections(request: request)
            resetMapView(withNew: directions)
            
            directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
        
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        getDirection()
        isTimerOn.toggle()
        toggleTimer(on: isTimerOn)
        label.isHidden = false

    }
    
    func toggleTimer(on: Bool)
    {
        if on{
            timer=Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let strongSelf = self else {return}
                strongSelf.duration += 1
                strongSelf.label.text = String(strongSelf.duration)
                if (strongSelf.duration == 30)
                {
                    self?.Areyouoklabel.isHidden = false
                    self?.yesButton.isHidden = false
                    self?.noButton.isHidden = false
                    self?.OkConfirmation.text = ""
                }
                if (strongSelf.duration >= 45)
                {
                    self?.checkConfirmation()
                }
            })
        }
        else {
            timer.invalidate()
        }
    }
    
    func checkConfirmation()
    {
        if (OkConfirmation.text == "YES")
        {
            stopTimer()
            OkConfirmation.isHidden = true
        }
        else
        {
            timer.invalidate()
            Areyouoklabel.isHidden = true
            yesButton.isHidden = true
            noButton.isHidden = true
            OkConfirmation.text = "Contacting Authorities"
            OkConfirmation.isHidden = false
            displayMessageInterface()
        }
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["7873793060"]
        composeVC.body = "Message sent using the SafeWalk app: It's Samantha Puterman, I am walking back home and I don't feel safe"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    func stopTimer()
    {
        duration=0
    }
    
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    
    
    func getCenterLocation(for mapView: MKMapView)-> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    

    
    }


    extension SecondViewController: CLLocationManagerDelegate {

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
    }


    extension SecondViewController: MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = getCenterLocation(for: mapView)
            
            
            guard let previousLocation = self.previousLocation else {return}
            
            guard center.distance(from: previousLocation) > 50 else { return }
            self.previousLocation = center
            
            geoCoder.cancelGeocode()
            
            geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
                if let _ = error {
                    //TODO: Show alert informing the user
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    //TODO: Show alert informing the user
                    return
                }
                
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                
                DispatchQueue.main.async {
                    self.addressLabel.text = "\(streetNumber) \(streetName)"
                }
            }
        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            renderer.strokeColor = .blue
            
            return renderer
        }
        
        
    }

