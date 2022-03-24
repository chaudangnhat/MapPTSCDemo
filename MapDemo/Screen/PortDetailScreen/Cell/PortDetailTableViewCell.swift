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
    @IBOutlet weak var _descriptionLb: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    func configCell(model: PortBase){
        
        guard let _model = model as? PortService else {return}
        
        let image = UIImage(named: _model.image)
        let imageHeight = (image?.size.height ?? 100) / 2
        
        self.infoImageView.image = image
        self.titleLb.text = _model.info
    }
}
