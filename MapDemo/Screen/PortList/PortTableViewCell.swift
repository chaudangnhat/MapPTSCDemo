//
//  PortTableViewCell.swift
//  MapDemo
//
//  Created by dinh vien  on 24/02/2022.
//

import Foundation
import UIKit

class PortTableViewCell: UITableViewCell{
    static let IDENTFIER = "PortTableViewCell"
    
    @IBOutlet weak var portNameLb: UILabel!
    @IBOutlet weak var locationNameLb: UILabel!
    @IBOutlet weak var sizeLb: UILabel!
    @IBOutlet weak var lengthLb: UILabel!
    @IBOutlet weak var capacityLb: UILabel!
    
    func config(portModel: PortModel){
        self.portNameLb.text = portModel.name
        self.locationNameLb.text = portModel.locationName
        self.sizeLb.text = "\(portModel.size)"
        self.lengthLb.text = "\(portModel.length)"
        self.capacityLb.text = "\(portModel.capacity)"
    }
}
