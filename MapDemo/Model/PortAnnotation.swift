//
//  PortAnnotation.swift
//  MapDemo
//
//  Created by dinh vien  on 12/03/2022.
//

import Foundation
import Cluster
import CoreLocation

class PortAnnotation: Annotation {
    var portModel: PortModel
    
    init(model: PortModel) {
        self.portModel = model
        super.init()

//        self.title = model.name + " Port"
        self.coordinate = CLLocationCoordinate2D(latitude: model.lat, longitude: model.long)
    }
}
