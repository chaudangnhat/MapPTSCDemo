//
//  PortHeaderTableViewCell.swift
//  MapDemo
//
//  Created by dinh vien  on 21/03/2022.
//

import Foundation
import UIKit

class PortHeaderTableViewCell: UITableViewCell{
    static let IDENTIFIER = "PortHeaderTableViewCell"
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var deviceListLabel: UILabel!
    
    @IBOutlet weak var infoImageView: UIImageView!
    
    func configCell(model: PortService){
       
    }
}
