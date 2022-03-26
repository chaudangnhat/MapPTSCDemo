//
//  PortSheetV2TableViewCell.swift
//  MapDemo
//
//  Created by dinh vien  on 25/03/2022.
//

import Foundation
import UIKit

class PortSheetV2TableViewCell: UITableViewCell{
    static let IDENTIFIER = "PortSheetV2TableViewCell"
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    
    func configCell(model: PortService){
        self.titleLb.text = model.info
        self.leftImageView.image = UIImage(named: model.image ?? "")
    }
}
