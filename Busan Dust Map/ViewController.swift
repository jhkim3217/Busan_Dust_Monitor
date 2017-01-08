//
//  ViewController.swift
//  Busan Dust Map
//
//  Created by 김종현 on 2016. 11. 5..
//  Copyright © 2016년 김종현. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//var currentTime: String?
// 공공데이터 인증키
//let key = "aT2qqrDmCzPVVXR6EFs6I50LZTIvvDrlvDKekAv9ltv9dbO%2F8i8JBz2wsrkpr9yrPEODkcXYzAqAEX1m%2Fl4nHQ%3D%3D"

class ViewController: UIViewController, XMLParserDelegate, MKMapViewDelegate,
      CLLocationManagerDelegate {
    
    @IBOutlet weak var DistSegment: UISegmentedControl!
    @IBOutlet weak var DustMapView: MKMapView!
    
    // Timer
    var timer = Timer()
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var currnetElement = ""
    var isInItem = false
    
    var currentTime: String?
    var preValue:Double = 15000
    var distance:Double?
    var minDist:Double?
    
    var tmpLat:Double?
    var tmpLong:Double?
    
    let cais = ["좋음", "보통", "나쁨", "매우나쁨"]
    
    var p10Cais = ""
    var p25Cais = ""
    
    var lat = ""
    var long = ""
    
    var add = ""
    var loc = ""
    var stType = ""
    var area = ""
    
//    var strURL: String?
    var dLong:Double = 0.0
    var dLat:Double = 0.0
    
    var annotation: StationPoint?
    var selectedAnno: StationPoint?
    var annotations:Array = [StationPoint]()
    var minDistAnno: StationPoint?
    
    var locationManager = CLLocationManager()
    var myViewController = MyViewController()
    
    let key = "aT2qqrDmCzPVVXR6EFs6I50LZTIvvDrlvDKekAv9ltv9dbO%2F8i8JBz2wsrkpr9yrPEODkcXYzAqAEX1m%2Fl4nHQ%3D%3D"
    
    // 현재 위치
    //var center:CLLocationCoordinate2D?
    
    let addrs:[String:[String]] = [
        "광복동" : ["중구 광복로 55번길 10", "35.0999630", "129.0304170", "광복동 주민센터", "도시대기", "상업지역"],
        "장림동" : ["사하구 장림로 161번길 2", "35.0829920", "128.9668750", "사하여성회관", "도시대기","공업지역"],
        "학장동" : ["사상구 대동로 205", "35.1460850", "128.9838270", "학장초등학교", "도시대기","공업지역"],
        "덕천동" : ["북구 만덕대로 155번길 81", "35.2158660", "129.0197570", "한국환경공단", "도시대기", "주거지역"],
        "연산동" : ["연제구 중앙대로 1065번길 14", "35.1841140", "129.0786090", "연제초등학교", "도시대기", "주거지역"],
        "대연동" : ["남구수영로 196번길 80", "35.1303210", "129.0876850", "부산공업고등학교", "도시대기", "주거지역"],
        "청룡동" : ["금정구 청룡로 25", "35.2752570", "129.0898810","청룡노포동 주민센터 옥상", "도시대기", "주거지역"],
        "전포동" : ["부산진구 전포대로 175번길 22", "35.1530480", "129.0635640","경남공고 옥상", "도시대기",  "상업지역"],
        "태종대" : ["영도구 전망로 24", "35.0597260", "129.0798400", "태종대유원지관리사무소", "도시대기", "녹지지역"],
        "기장읍" : ["기장군 기장읍 읍내로 69", "35.2460560", "129.2118280","기장초등학교 옥상", "도시대기", "주거지역"],
        "대저동" : ["강서구 낙동북로 236", "35.2114600", "128.9547110","대저차량사업소 옥상", "도시대기", "녹지지역"],
        "부곡동" : ["금정구 부곡로 156번길 7", "35.2298390", "129.0927140","부곡2동 주민센터 옥상", "도시대기", "주거지역"],
        "광안동" : ["수영구 수영로 521번길 55", "35.1527040", "129.1078090","구 보건환경연구원 3층", "도시대기", "주거지역"],
        "명장동" : ["동래구 명장로 32", "35.2047550", "129.1043270","명장ㅂ동 주민센터 옥상", "도시대기", "주거지역"],
        "녹산동" : ["강서구 녹산산업중로 333", "35.0953270", "128.8556680", "(주)삼성전기부산사업장 옥상", "도시대기",  "공업지역"],
        "용수리" : ["기장군 정관면 용수로4", "35.3255580", "129.1801400", "정관면 주민센터 2층 옥상", "도시대기", "주거지역"],
        "좌동"  : ["해운대구 양운로 91", "35.1708900", "129.1742250", "좌1동 주민센터 옥상", "도시대기", "주거지역"],
        "수정동" : ["동구 구청로 1", "35.1293350", "129.0454230", "동구청사 옥상", "도시대기", "주거지역"],
        "대신동" : ["서구 대신로 150", "35.1173230", "129.0156410", "부산국민체육센터", "도시대기", "주거지역"],
        "온천동" : ["동래구 중앙대로 동래역", "35.2056140", "129.0785020", "동래지하철 앞", "도로변", "상업지역"],
        "초량동" : ["동구 초량동 윤흥신장군 동상앞", "35.11194650", "129.0354560", "윤흥신장군 동상 앞", "도로변", "상업지역"]
    ]
    
    //let data = ["전포동 측정소", "PM10", "PM25"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "부산 실시간 미세먼지 지도"
        
        myParse()
        timer = Timer.scheduledTimer(timeInterval: 60*60, target: self, selector: #selector(ViewController.myParse), userInfo: nil, repeats: true)
        
        // tableView data reload
        //myViewController.tableView.reloadData()
        

        DustMapView.delegate = self
        
        // 현재 위치 트랙킹
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        DustMapView.showsUserLocation = true
        DustMapView.userLocation.title = "현재 위치"
        DustMapView.showsCompass = true
        
        /// 지도 작업
        zoomToRegion()
        
        // StationPoint 객체 생성 및 데이터 입력
        // coordinate는 공공데이터에 없으므로 geocoding 데이터를 배열에 저장하여 index로 불러옴
        // addr도 똑같이 처리
        
        for item in items {
            let title = item["site"]
            print("title = \(title)")
            
            for (key, value) in addrs {
                print("\(key) -> \(value)")
                
                if key == title {
                    add = value[0]
                    lat = value[1]
                    long = value[2]
                    dLong = Double(long)!
                    dLat = Double(lat)!
                    loc = value[3]
                    stType = value[4]
                    area = value[5]
                }
            }
            
            let pm10 = item["pm10"]
            let pm25 = item["pm25"]
            let pm10Cai = item["pm10Cai"]
            let pm25Cai = item["pm25Cai"]
            
            if pm25Cai! == "1" {
                p25Cais = cais[0]
            } else if pm25Cai == "2" {
                p25Cais = cais[1]
            } else if pm25Cai == "3" {
                p25Cais = cais[2]
            } else if pm25Cai == "4" {
                p25Cais = cais[3]
            } else {
                p25Cais = "오류"
            }
            
            if pm10Cai! == "1" {
                p10Cais = cais[0]  //좋음
            } else if pm10Cai == "2" {
                p10Cais = cais[1]  // 보통
            } else if pm10Cai == "3" {
                p10Cais = cais[2]  // 나쁨
            } else if pm10Cai == "4" {
                p10Cais = cais[3]  // 매우 나쁨
            } else {
                p10Cais = "오류"
            }
            
            //let subtitle = loc
            let subtitle = add
            print("***********add = \(add)")
            
            // CLLocation 객체 만들기
            let subtitlePM10 = "PM10" + "(" + p10Cais + ")"
            let subtitlePM25 = "PM2.5" + "(" + p25Cais + ")"
            let subtitlePM = subtitlePM10 + " " + subtitlePM25
            let pmState = subtitlePM

            //annotation?.subtitle = pm10Cai! + pm25Cai!
            
            // 각 충전소 정보를 가지고 있는 객체 생성(for loop로 모는 충전소 객체(StationPoint.swift 생성)
            annotation = StationPoint(title: title!,
                                          subtitle: subtitle,
                                          coordinate: CLLocationCoordinate2D(latitude: dLat, longitude: dLong),
                                          pm10: pm10!,
                                          pm25: pm25!,
                                          pm10Cai: pm10Cai!,
                                          pm25Cai: pm25Cai!,
                                          loc: loc,
                                          stType: stType,
                                          area: area
                                     )
            annotation!.title = title! + " 대기질 측정소"
            annotation!.subtitle = pmState
            annotations.append(annotation!)
            
            print("annotations = \(annotations.count)")
 
        }
        
        DustMapView.showAnnotations(annotations, animated: true)
        DustMapView.addAnnotations(annotations)
        //DustMapView.selectAnnotation(minDistAnno!, animated: true)
        
        //mapView(DustMapView, viewFor: annotation!)

    }

    
    func myParse() {
        
        print("myParse() go...")
        let strURL = "http://opendata.busan.go.kr/openapi/service/AirQualityInfoService/getAirQualityInfoClassifiedByStation?ServiceKey=\(key)&numOfRows=21&pageSize=21&pageNo=1&startPage=1"
        
        print(strURL)
        
        if let url = URL(string: strURL) {
            if let parser = XMLParser(contentsOf: url) {
               parser.delegate = self
        
                if (parser.parse()) {
                    print("parsing success")
                    let date: Date = Date()
                    let dayTimePeriodFormatter = DateFormatter()
                    dayTimePeriodFormatter.dateFormat = "YYYY/MM/dd HH시"
                    currentTime = dayTimePeriodFormatter.string(from: date)
                    myViewController.tableView.reloadData()
            
                } else {
                    print("parsing fail")
                }
            } else {
                print("url error")
            }
        }
    }
    
    // parsing delegate method
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currnetElement = elementName
        
        // 다시 파싱할 경우도 있으므로
        if elementName == "items" {
            items = []
        } else if elementName == "item" {
            item = [:]
            isInItem = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if isInItem {
            item[currnetElement] = string.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            isInItem = false
            items.append(item)
        }
    }

    
    // 초기 맵 region 설정
    func zoomToRegion() {
        
        print("zoom to Location")
        // 부산지도 구글 중심정 35.163246, 129.066297
        let location = CLLocationCoordinate2D(latitude: 35.118002, longitude: 129.121017)
        let span = MKCoordinateSpan(latitudeDelta: 0.27, longitudeDelta: 0.27)
        let region = MKCoordinateRegionMake(location, span)
        DustMapView.setRegion(region, animated: true)
        
        // anno test
        // add annotaton
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "동의과학대학교"
//        annotation.subtitle = "DIT"
//        DustMapView.addAnnotation(annotation)
//        DustMapView.delegate = self
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        
        let identifier = "MyPin"
        
        
        // 사용자의 현재 위치 annotation을 제외함
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // 2
        if annotation.isKind(of: StationPoint.self) {
            // if annotation is StationwPoint
            // 3
            
            var annotationView = DustMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView!.canShowCallout = true
                
                let myCastAnno: StationPoint = annotation as! StationPoint
                
                if myCastAnno.pm25Cai == "4" || myCastAnno.pm10Cai == "4" { // 매우 나쁨
                    annotationView?.pinTintColor = UIColor.magenta
                } else if myCastAnno.pm25Cai == "3" || myCastAnno.pm10Cai == "3" { // 나쁨
                        annotationView?.pinTintColor = UIColor.red
                } else if myCastAnno.pm25Cai == "2" || myCastAnno.pm10Cai == "2" { // 보통
                    annotationView?.pinTintColor = UIColor.blue
                } else if myCastAnno.pm25Cai == "1" || myCastAnno.pm10Cai == "1" { // 좋음
                    annotationView?.pinTintColor = UIColor.green
                } else  {
                 // 전송 오류
                    annotationView?.pinTintColor = UIColor.darkGray
                }
                
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
            
            return annotationView
        }
        // 7
        return nil
    }
 
    
    // Pin View의 Accessary를 눌러을때 Alert View 보여줌
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let viewAnno = view.annotation as! StationPoint // MKAnnotation
        let statName = viewAnno.title!
        //let myaddr = viewAnno.subtitle
        let cPM10 = viewAnno.pm10
        let cPM25 = viewAnno.pm25
        let pm10Cai = viewAnno.pm10Cai
        let pm25Cai = viewAnno.pm25Cai
        let loc = viewAnno.loc
        let stType = viewAnno.stType
        let area = viewAnno.area
        
        print("pm10 = \(cPM10)")
        print("pm2.5 = \(cPM25)")
        
        if pm25Cai! == "1" {
            p25Cais = cais[0]
        } else if pm25Cai == "2" {
            p25Cais = cais[1]
        } else if pm25Cai == "3" {
            p25Cais = cais[2]
        } else if pm25Cai == "4" {
            p25Cais = cais[3]
        } else {
            p25Cais = "error"
        }
        
        if pm10Cai! == "1" {
            p10Cais = cais[0]
        } else if pm10Cai == "2" {
            p10Cais = cais[1]
        } else if pm10Cai == "3" {
            p10Cais = cais[2]
        } else if pm10Cai == "4" {
            p10Cais = cais[3]
        } else {
            p10Cais = "error"
        }
        
        let tMessage01 = p10Cais + "(" + cPM10! + ")"
        let tMessage02 = p25Cais + "(" +  cPM25! + ")"
        //let tMessage03 = "측정소 정보"
        
        
        ///////
        let ac = UIAlertController(title: statName, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
        //presentViewController(ac, animated: true, completion: nil)
        
        //let tableViewController = AlertTableViewController()
        myViewController = MyViewController()
        
        //myViewController.data.append(tMessage01)
        //myViewController.data.append(tMessage02)
        
        
        myViewController.data.append(currentTime!)
        myViewController.data.append(tMessage01)
        myViewController.data.append(tMessage02)
        myViewController.data.append(loc!)
        myViewController.data.append(stType!)
        myViewController.data.append(area!)
        
        
        /*
        if (array.count < 4) {
            rect = CGRectMake(0, 0, 272, 100);
            [controller setPreferredContentSize:rect.size];
            
        }
        else if (array.count < 6){
            rect = CGRectMake(0, 0, 272, 150);
            [controller setPreferredContentSize:rect.size];
        }
        else if (array.count < 8){
            rect = CGRectMake(0, 0, 272, 200);
            [controller setPreferredContentSize:rect.size];
            
        }
        else {
            rect = CGRectMake(0, 0, 272, 250);
            [controller setPreferredContentSize:rect.size];
        }
        */
        
        
        
        myViewController.preferredContentSize = CGSize(width: 272, height: 250) // 4 default cell heights.
        ac.setValue(myViewController, forKey: "contentViewController")
        
        self.present(ac, animated: true)
        {
            // ...
            print("presentView go")
        }
        
    }
    
    
    // 현재 위치정보 트랙킹(currnet location tracking)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        print("center = \(center)")
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.21, longitudeDelta: 0.21))
        
        DustMapView.setRegion(region, animated: true)
        
    }
    
    // segmentControl Action 함수
    @IBAction func segmentSelected(_ sender: AnyObject) {
        
        //let location = CLLocationCoordinate2D(latitude: 35.163246, longitude: 129.066297)
        
        let center = locationManager.location?.coordinate
 
        if DistSegment.selectedSegmentIndex == 0 {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegionMake(center!, span)
            DustMapView.setRegion(region, animated: true)
            //DustMapView.selectAnnotation(minDistAnno!, animated: true)
            
            
        } else if DistSegment.selectedSegmentIndex == 1 {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegionMake(center!, span)
            DustMapView.setRegion(region, animated: true)
            //DustMapView.selectAnnotation(minDistAnno!, animated: true)
            
            
        } else if DistSegment.selectedSegmentIndex == 2 {
            let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            let region = MKCoordinateRegionMake(center!, span)
            DustMapView.setRegion(region, animated: true)
            //DustMapView.selectAnnotation(minDistAnno!, animated: true)

        } else {
            let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            let region = MKCoordinateRegionMake(center!, span)
            DustMapView.setRegion(region, animated: true)
            //DustMapView.selectAnnotation(minDistAnno!, animated: true)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

