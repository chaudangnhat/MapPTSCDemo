//
//  ViewController.swift
//  MapDemo
//
//  Created by dinh vien  on 23/02/2022.
//

import UIKit
import MapKit
import CoreLocation
import Cluster
import FittedSheets

class ViewController: UIViewController {

    @IBOutlet weak var currentLocationBtn: UIButton!{
        didSet{
            currentLocationBtn.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var searchButton: UIButton!{
        didSet{
            searchButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var map: MKMapView!{
        didSet{
            map.register(PortAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PortAnnotationView")
            map.mapType = .mutedStandard
        }
    }
    @IBOutlet weak var portTableview: PortTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sheetController: SheetViewController?
    let regionRadius: Double = 1000
    var locationManager = CLLocationManager()
    
    lazy var manager: ClusterManager = { [unowned self] in
        let manager = ClusterManager()
        manager.delegate = self
        manager.maxZoomLevel = 17
        manager.minCountForClustering = 3
        manager.clusterPosition = .nearCenter
        return manager
    }()
    
    
    var list: [PortModel] = [PortModel(name: "Dinh Vu", locationName: "Hai Phong", size: 15.3, length: 250, capacity: "20.000", lat: 20.818670, long: 106.810503), //20.81867049389915, 106.8105037781829
                             PortModel(name: "Nghi Son", locationName: "Thanh Hoa", size: 9.95, length: 165, capacity: "20.000-50.000", lat: 19.309601, long: 105.820213), //19.309601188633742, 105.82021368766398
                             PortModel(name: "Hon La", locationName: "Quang Binh", size: 11.02, length: 215, capacity: "10.000", lat: 17.929660, long: 106.500005), //17.929660874932118, 106.50000572810103
                             PortModel(name: "Son Tra", locationName: "Da Nang", size: 10, length: 210, capacity: "3.000", lat: 16.083344, long: 108.221817), //16.08334476711069, 108.22181779924702
                             PortModel(name: "Dung Quat", locationName: "Quang Ngai", size: 13.72, length: 165, capacity: "70.000", lat: 15.145452, long: 108.797640), //15.1454527203998, 108.79764077463726
                             PortModel(name: "Sao Mai Ben Dinh", locationName: "Ba Ria Vung Tau", size: 15, length: 150, capacity: "20.000", lat: 10.384196761115378, long: 107.0941748415363), //10.384196761115378, 107.0941748415363 Số 65A3, Đường 30/4, Phường Thắng Nhất, Thành phố Vũng Tàu
                             PortModel(name: "PTSC Supply Base", locationName: "Ba Ria Vung Tau", size: 82.2, length: 733.12, capacity: "10.000", lat: 10.383698942680002, long: 107.09413089920776), //10.383698942680002, 107.09413089920776
                             PortModel(name: "Phu My", locationName: "Ba Ria Vung Tau", size: 26.49, length: 150, capacity: "80.000", lat: 10.59077015398646, long: 107.05455175771709), //10.59077015398646, 107.05455175771709
                             PortModel(name: "Lô 01.97, 02.97 ", locationName: "Ba Ria Vung Tau", size: 26.49, length: 150, capacity: "80.000", lat: 9.699477030590371, long: 108.60610041209111, type: .BeTramTichCuuLong)
                             
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        self.map.delegate = self
        self.configSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.portTableview.list = self.list
        self.portTableview.reloadData()
        
        self.addAnnotation()
        
        self.portTableview.didSelectItem = {[weak self] model in
            self?.mapSelectPort(portModel: model)
            self?.searchBar.isHidden = true
            self?.portTableview?.isHidden = true
            self?.view.endEditing(true)
        }
        self.view.endEditing(true)
    }
    
    @IBAction func currentLocationOnClick(_ sender: Any) {
        LocationUtil.sharedIntance.checkAuthorizedLocation {
            guard let coordinate = self.locationManager.location?.coordinate else {return}
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: self.regionRadius, longitudinalMeters: self.regionRadius)
            self.map.setRegion(coordinateRegion, animated: true)
        }
    }
    
    @IBAction func searchOnclick(_ sender: Any) {
        self.searchBar.isHidden = false
        self.portTableview.isHidden = false
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        self.view.layoutIfNeeded()

    }
    
    func configSearchBar(){
        self.searchBar.delegate = self
        self.searchBar.setDefaultSearchBar()
        if #available(iOS 13.0, *){
            self.searchBar.textField?.delegate = self
        }
    }
    
    func addAnnotation(){
        for item in self.list{
            let portAnnotation = PortAnnotation(model: item)
            portAnnotation.portModel = item
//            map.addAnnotation(portAnnotation)
            self.manager.add(portAnnotation)
            self.manager.reload(mapView: self.map)
        }
    }
}


extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "PortAnnotationView"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PortAnnotationView
        annotationView?.portModel = (annotation as? PortAnnotation)?.portModel ?? PortModel()
        if let annotation = annotation as? ClusterAnnotation {
            annotationView?.setupGroupPort(portAnnotations: annotation.annotations as? [PortAnnotation] ?? [])
        }else{
            annotationView?.setupUI()
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let portModel = (view as? PortAnnotationView)?.portModel else {return}
        self.mapSelectPort(portModel: portModel)
    }
    
    func mapSelectPort(portModel: PortModel){
        
        if portModel.type == .unknow{
            let viewController = PortSheetBasicViewController(model: portModel)
            
            let sheetController = SheetViewController(controller: viewController, sizes: [.percent(0.4), .intrinsic], options: nil)
            self.sheetController = sheetController
            self.sheetController?.didDismiss = { [weak self] vc in
                self?.sheetController?.dismiss(animated: false, completion: nil)
            }
            self.present(sheetController, animated: true, completion: nil)
            return
        }
       
        let viewController = PortSheetViewController(model: portModel)
        let sheetController = SheetViewController(controller: viewController, sizes: [.percent(0.5), .marginFromTop(100)], options: nil)
        self.sheetController = sheetController
        sheetController.handleScrollView(viewController.portInfoTableView)
        self.sheetController?.didDismiss = { [weak self] vc in
            self?.sheetController?.dismiss(animated: false, completion: nil)
        }
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView) { finished in
            print(finished)
        }
    }
}

extension ViewController: UISearchBarDelegate, UITextFieldDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.isHidden = true
        self.portTableview.isHidden = true
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text?.lowercased() ?? ""
        if searchText.isEmpty{
            self.portTableview.list = self.list
            self.portTableview.reloadData()
        }
        
        let searchList = self.list.filter({$0.name.lowercased().contains(searchText) || $0.locationName.lowercased().contains(searchText)})
        
        self.portTableview.list = searchList
        self.portTableview.reloadData()
    }
    
    func clearSearch(){
        self.searchBar.text = ""
        self.portTableview.list = self.list
        self.portTableview.reloadData()
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.clearSearch()
        return true
    }
    
    @objc
    public func userClickedClearSearch(_ sender: Any) {
        self.clearSearch()
    }
}

extension ViewController: ClusterManagerDelegate {
    
    func cellSize(for zoomLevel: Double) -> Double? {
        return nil // default
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return true
    }
}
