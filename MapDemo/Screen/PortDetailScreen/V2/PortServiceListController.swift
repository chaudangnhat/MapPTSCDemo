//
//  PortServiceListController.swift
//  MapDemo
//
//  Created by dinh vien  on 25/03/2022.
//

import Foundation
import UIKit
import SnapKit

class PortServiceListController: UIViewController{
    var portDetailTableView = PortDetailTableView()
    
    var data = [[PortBase]]()
    
    init(data: [PortBase]) {
        self.data = [data]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.portDetailTableView)
        self.portDetailTableView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
        self.portDetailTableView.reloadData(data: self.data)
    }
}
