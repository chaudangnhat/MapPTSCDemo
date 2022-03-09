//
//  PortAnnotationView.swift
//  MapDemo
//
//  Created by dinh vien  on 24/02/2022.
//

import Foundation
import UIKit
import MapKit
import SnapKit

class PortAnnotationView: MKAnnotationView {

    var portModel: PortModel = PortModel()
    var iconImageView: UIImageView = UIImageView()
    var titleLb: UILabel = UILabel()
    
   // MARK: Initialization

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
       super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
       canShowCallout = true
   }

   @available(*, unavailable)
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    private func setup(title: String){
        self.iconImageView.image = UIImage(named: "logo")
        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(25)
        })
        
        self.titleLb.font = self.titleLb.font.withSize(12)
        self.titleLb.text = title + " Port"
        self.titleLb.textColor = UIColor.black
        self.addSubview(self.titleLb)
        self.titleLb.snp.makeConstraints({
            $0.leading.equalTo(self.iconImageView.snp.trailing)
            $0.centerY.equalTo(self.iconImageView)
        })
        self.titleLb.sizeToFit()
        self.titleLb.numberOfLines = 0
        self.frame = CGRect(x: 0, y: 0, width: self.titleLb.bounds.width + 35, height: self.titleLb.bounds.height)
        self.layoutIfNeeded()
    }
    
    func setupUI(){
        self.setup(title: self.portModel.name)
    }
    
    func setupGroupPort(portAnnotations: [PortAnnotation]){
        let title = portAnnotations.map({$0.portModel.name}).joined(separator: ";\n")
        self.setup(title: title)
    }
}
