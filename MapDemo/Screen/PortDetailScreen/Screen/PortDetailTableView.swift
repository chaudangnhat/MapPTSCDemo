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
    private var data: [[PortBase]] = []
    
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
        self.register(UINib(nibName: PortHeaderTableViewCell.IDENTIFIER, bundle: Bundle(for: PortHeaderTableViewCell.self)), forCellReuseIdentifier: PortHeaderTableViewCell.IDENTIFIER)
        
        self.separatorStyle = .none
    }
    
    func reloadData(data: [[PortBase]]){
        self.data = data
        self.reloadData()
    }
}

extension PortDetailTableView: UITableViewDelegate, UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let sectionView = UIView()
            sectionView.backgroundColor = UIColor.clear
            sectionView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30)
            let tempView = UIView()
            sectionView.addSubview(tempView)
            tempView.backgroundColor = UIColor.primaryColor
            
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textColor = UIColor.black
            label.text = "Các dịch vụ PTSC đã/đang cung cấp"
            sectionView.addSubview(label)
            label.snp.makeConstraints({
                $0.centerX.centerY.equalToSuperview()
            })
            
            tempView.snp.makeConstraints({
                $0.leading.equalTo(label).offset(-8)
                $0.trailing.equalTo(label).offset(8)
                $0.top.equalTo(label).offset(-8)
                $0.bottom.equalTo(label).offset(8)
            })
            
            return sectionView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.data[indexPath.section][indexPath.row]
        
        if let portArea = item as? PortArea{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PortHeaderTableViewCell.IDENTIFIER, for: indexPath) as? PortHeaderTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortDetailTableViewCell.IDENTIFIER, for: indexPath) as? PortDetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return -1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
