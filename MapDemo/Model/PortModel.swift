//
//  PortModel.swift
//  MapDemo
//
//  Created by dinh vien  on 13/03/2022.
//

import Foundation

enum PortType: String{
    case BeTramTichCuuLong
    case SaoMaiBenDinhPort
    case DungQuat
    case unknow
}

class PortModel{
    
    var type: PortType = .unknow
    var image: String? = nil
    var info: String? = nil
    
    var name: String = ""
    var locationName = ""
    var size: Double = 0.0
    var length: Double = 0
    var capacity: String = ""
    
    var lat: Double = 0
    var long: Double = 0
    
    var theme: String? = nil
    
    var portServices = [PortService]()
    
    init(){
        
    }
    
    init(name: String, locationName: String, size: Double, length: Double, capacity: String, lat: Double, long: Double,type: PortType = .unknow){
        self.name = name
        self.locationName = locationName
        self.size = size
        self.length = length
        self.capacity = capacity
        self.lat = lat
        self.long = long
        self.type = type
    }
}
