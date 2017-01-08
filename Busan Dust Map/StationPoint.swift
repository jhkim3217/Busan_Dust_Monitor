//
//  StationPoint.swift
//  Busan Dust Map
//
//  Created by 김종현 on 2016. 11. 5..
//  Copyright © 2016년 김종현. All rights reserved.
//

import UIKit
import MapKit

class StationPoint: NSObject, MKAnnotation {
    var title: String? // 측정소명
    var subtitle: String? // 주소
    var coordinate: CLLocationCoordinate2D
    var pm10: String?
    var pm25: String?
    var pm10Cai: String?
    var pm25Cai: String?
    var loc: String? // 측정소 위치
    var stType: String? // 측정망 종류
    var area: String? // 지역용도
    
    init(title: String,
         subtitle: String,
         coordinate: CLLocationCoordinate2D,
         pm10: String,
         pm25: String,
         pm10Cai: String,
         pm25Cai: String,
         loc: String,
         stType: String,
         area: String) {
        
        self.title = title
        self.subtitle = loc
        self.coordinate = coordinate
        self.pm10 = pm10
        self.pm25 = pm25
        self.pm10Cai = pm10Cai
        self.pm25Cai = pm25Cai
        self.loc = loc
        self.stType = stType
        self.area = area
    }
}

