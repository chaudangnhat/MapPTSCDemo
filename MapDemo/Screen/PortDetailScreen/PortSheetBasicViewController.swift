//
//  PortSheetBasicViewController.swift
//  MapDemo
//
//  Created by dinh vien  on 14/03/2022.
//

import Foundation
import UIKit

class PortSheetBasicViewController: BaseViewController{
    @IBOutlet weak var portNameLb: UILabel!
    @IBOutlet weak var locationNameLb: UILabel!
    @IBOutlet weak var sizeLb: UILabel!
    @IBOutlet weak var lengthLb: UILabel!
    @IBOutlet weak var capacityLb: UILabel!

    var model: PortModel
    
    // MARK: - View lifecycle
    init(model: PortModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.config()
    }
    func config(){
        self.portNameLb.text = self.model.name + " Port"
        self.locationNameLb.text = "Location: \(self.model.locationName)"
        self.sizeLb.text = "Size(ha): \(self.model.size) "
        self.lengthLb.text = "Length(m): \(self.model.length)"
        self.capacityLb.text = "Vesset Capacity(DWT): \(self.model.capacity)"
    }
}
