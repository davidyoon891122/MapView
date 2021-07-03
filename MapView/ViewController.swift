//
//  ViewController.swift
//  MapView
//
//  Created by David Yoon on 2021/07/03.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMapView: MKMapView!
    @IBOutlet var lblLocation1: UILabel!
    @IBOutlet var lblLocation2: UILabel!
    
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManger.delegate = self
        
        lblLocation1.text = ""
        lblLocation2.text = ""
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        myMapView.showsUserLocation = true
        
    }

    // 위도 경도 고도 설정하는 함수
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span : Double) -> CLLocationCoordinate2D{
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        
        myMapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    // 핀을 설치하는 함수 파라미터는 위도, 경도, 타이틀, 서브 타이틀
    func setAnnotation(latitueValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitueValue, longitudeValue: longitudeValue, delta: span)
        
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMapView.addAnnotation(annotation)
    }
    
    
    
    // 위치가 업데이트되었을 때, 지도에 위치를 나타내기 위한 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (plcaemarks, error) -> Void in
            let pm = plcaemarks!.first
            let country = pm!.country
            var address: String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocation1.text = "현재 위치"
            self.lblLocation2.text = address
        })
        locationManger.stopUpdatingLocation()
    }
    
    
    // segment 변화 될때 selectedSegmentIndex로 값 가져와서 1,2 는 핀설정 0은 현재 위치 업데이트
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.lblLocation1.text = ""
            self.lblLocation2.text = ""
            locationManger.startUpdatingLocation()
            
        } else if (sender.selectedSegmentIndex == 1) {
            setAnnotation(latitueValue: 37.48625, longitudeValue: 126.97686, delta: 0.001, title: "Home", subtitle: "서울시 사당로27길 54 301호")
            self.lblLocation1.text = "보고 계신 위치"
            self.lblLocation2.text = "서울시 사당로 27길 54 301호"
        } else if (sender.selectedSegmentIndex == 2) {
            setAnnotation(latitueValue: 37.52507, longitudeValue: 126.92618, delta: 0.001, title: "KBAM", subtitle: "IFC Three 40층")
            self.lblLocation1.text = "보고 계신 위치"
            self.lblLocation2.text = "서울 여의도 IFC Three 40층"
        }
        
    }
    
}

