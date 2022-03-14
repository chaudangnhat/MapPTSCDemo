//
//  PortDetailTableView.swift
//  MapDemo
//
//  Created by dinh vien  on 12/03/2022.
//

import Foundation
import UIKit
import SnapKit

class PortDetailTableView: UITableView{
    private var data: [PortService] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.configViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configViews()
    }
    
    func configViews(){
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName: PortDetailTableViewCell.IDENTIFIER, bundle: Bundle(for: PortDetailTableViewCell.self)), forCellReuseIdentifier: PortDetailTableViewCell.IDENTIFIER)
    }
    
    func reloadData(data: [PortService]){
        self.data = data
        self.reloadData()
    }
}

extension PortDetailTableView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortDetailTableViewCell.IDENTIFIER, for: indexPath) as? PortDetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configCell(model: self.data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.data[indexPath.row]
        
        if model.info == nil {
            
//            let image = UIImage(named: model.image)
//            let _height = (image?.size.height ?? 100) + 40
            return 220
        }
        
        return -1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
