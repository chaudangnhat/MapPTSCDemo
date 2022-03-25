//
//  PortSheetV2ViewController.swift
//  MapDemo
//
//  Created by dinh vien  on 25/03/2022.
//

import Foundation
import UIKit

class PortSheetV2ViewController: UIViewController{
    
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var rightTableView: UITableView?
    
    var data: [PortBase] = []
    var selectPortService: ((PortService)-> Void)?
    
    init(data: [PortBase]){
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.rightTableView?.delegate = self
        self.rightTableView?.dataSource = self
        self.rightTableView?.register(UINib(nibName: PortSheetHeaderV2TableViewCell.identifier, bundle: Bundle(for: PortDetailTableViewCell.self)), forCellReuseIdentifier: PortSheetHeaderV2TableViewCell.identifier)
        self.rightTableView?.register(UINib(nibName: PortSheetV2TableViewCell.IDENTIFIER, bundle: Bundle(for: PortDetailTableViewCell.self)), forCellReuseIdentifier: PortSheetV2TableViewCell.IDENTIFIER)
        self.rightTableView?.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rightTableView?.reloadData()
    }
}

extension PortSheetV2ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PortSheetHeaderV2TableViewCell.identifier, for: indexPath) as? PortSheetHeaderV2TableViewCell
            return cell ?? UITableViewCell()
        }
        
        guard let item = self.data[indexPath.row] as? PortService else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PortSheetV2TableViewCell.IDENTIFIER, for: indexPath) as? PortSheetV2TableViewCell
        cell?.configCell(model: item)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return -1
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.clear
        sectionView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30)
        let tempView = UIView()
        sectionView.addSubview(tempView)
        tempView.backgroundColor = UIColor.primaryColor
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.text = section == 0 ? "Lô dầu khí 01.97 & 02.97" : "Các dịch vụ PTSC đã/đang cung cấp"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1{
            guard  let item = self.data[indexPath.row] as? PortService else {return}
            self.selectPortService?(item)
        }
    }
}
