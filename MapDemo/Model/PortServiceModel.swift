//
//  PortServiceModel.swift
//  MapDemo
//
//  Created by dinh vien  on 13/03/2022.
//

import Foundation

class PortBase{
    var id = ""
}

class PortService: PortBase{
    var image: String = ""
    var info: String? = nil
    
    init(image: String, info: String?){
        self.image = image
        self.info = info
    }
}

class PortArea: PortBase{
    var portName = ""
    var custommer = ""
    
    init(portName: String, custommer: String){
        self.portName = portName
        self.custommer = custommer
    }
}
