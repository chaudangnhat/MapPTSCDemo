//
//  PortSheetViewController.swift
//  MapDemo
//
//  Created by dinh vien  on 24/02/2022.
//

import Foundation
import UIKit

class PortSheetViewController: BaseViewController{
    
    @IBOutlet weak var portInfoTableView: PortDetailTableView!

    var model: PortModel
    
    var rightData: [PortModel] = []
    
    // MARK: - View lifecycle
    init(model: PortModel, data: [[PortBase]]) {
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
        let data: [[PortBase]] = [[PortArea(portName: "Lô dầu khí 01.97 & 02.97", custommer: "PVN")],
                                   
                                   [PortService(image: "ptsc2", info: "1. Dàn đầu giếng (WHP) Thăng Long và Đông Đô"),
                                   PortService(image: "ptsc3", info: "2. Cung cấp, vận hành, bảo dưỡng FPSO PTSC Lam Sơn"),
                                    PortService(image: "ptsc4", info: "3. Khảo sát địa chất, khảo sát các công trình tịa mỏ"),
                                    PortService(image: "ptsc5", info: "4. Tàu trực mỏ, tàu bảo vệ mỏ"),
                                    PortService(image: "ptsc6", info: "5. Lắp đặt và bảo dưỡng các công trình tại mỏ"),
                                    PortService(image: "ptsc7", info: "6. Dịch vụ căn cứ cảng dầu khí")]]
        self.configData(data: data)
    }
    
    func configRightTableView(){
        self.view.addSubview(self.portInfoTableView)
        self.portInfoTableView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 2)
            $0.bottom.equalToSuperview()
        })
    }
    
    func configData(data: [[PortBase]]){
        self.portInfoTableView.reloadData(data: data)
    }
}
