//
//  PortDetailTableViewCell.swift
//  MapDemo
//
//  Created by dinh vien  on 12/03/2022.
//

import Foundation
import UIKit

class PortDetailTableViewCell: UITableViewCell{
    
    static let IDENTIFIER = "PortDetailTableViewCell"
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var heightImageCT: NSLayoutConstraint!
    @IBOutlet weak var infoImageView: UIImageView!
    
    func configCell(model: PortService){
        let image = UIImage(named: model.image)
        let imageHeight = image?.size.height ?? 100
        
        self.infoImageView.image = image
        self.heightImageCT.constant = imageHeight
        self.titleLb.text = model.info
    }
}
