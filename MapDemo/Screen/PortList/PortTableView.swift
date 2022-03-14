//
//  PointListTableView.swift
//  MapDemo
//
//  Created by dinh vien  on 24/02/2022.
//

import Foundation
import UIKit
import SnapKit

class PortTableView: UITableView{
    
    var list: [PortModel] = []
    
    var didSelectItem:((PortModel)->Void)?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.configViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configViews()
    }
    
    func configViews(){
        self.register(UINib(nibName: PortTableViewCell.IDENTFIER, bundle: nil), forCellReuseIdentifier: PortTableViewCell.IDENTFIER)
        self.register(UINib(nibName: "PortHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        self.delegate = self
        self.dataSource = self
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}

extension PortTableView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PortTableViewCell.IDENTFIER, for: indexPath) as? PortTableViewCell
        cell?.config(portModel: self.list[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.didSelectItem?(self.list[indexPath.row])
    }
}

