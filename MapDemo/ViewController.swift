//
//  ViewController.swift
//  MapDemo
//
//  Created by dinh vien  on 23/02/2022.
//

import UIKit
import MapKit
import CoreLocation
import FINNBottomSheet
import PanModal
import Cluster

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
    
    
    var list: [PortModel] = [PortModel(name: "Dinh Vu", locationName: "Hai Phong", size: 15.3, length: 250, capacity: "20.000", lat: 20.844912, long: 106.688087),
                             PortModel(name: "Nghi Son", locationName: "Thanh Hoa", size: 9.95, length: 165, capacity: "20.000-50.000", lat: 19.806692, long: 105.785179),
                             PortModel(name: "Hoa La", locationName: "Quang Binh", size: 11.02, length: 215, capacity: "10.000", lat: 17.510486, long: 106.360443),
                             PortModel(name: "Son Tra", locationName: "Da Nang", size: 10, length: 210, capacity: "3.000", lat: 16.054407, long: 108.202164),
                             PortModel(name: "Dung Quat", locationName: "Quang Ngai", size: 13.72, length: 165, capacity: "70.000", lat: 15.122330, long: 108.799362),
                             PortModel(name: "Sao Mai Ben Dinh", locationName: "Ba Ria Vung Tau", size: 15, length: 150, capacity: "20.000", lat: 10.4, long: 108.0765028),
                             PortModel(name: "PTSC Supply Base", locationName: "Ba Ria Vung Tau", size: 82.2, length: 733.12, capacity: "10.000", lat: 10.384140, long: 107.094180),
                             PortModel(name: "Phu My", locationName: "Ba Ria Vung Tau", size: 26.49, length: 150, capacity: "80.000", lat: 10.588560, long: 107.047330),
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

class PortAnnotation: Annotation {
    var portModel: PortModel
    
    init(model: PortModel) {
        self.portModel = model
        super.init()

//        self.title = model.name + " Port"
        self.coordinate = CLLocationCoordinate2D(latitude: model.lat, longitude: model.long)
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
        let transitioningDelegate = BottomSheetTransitioningDelegate(
            contentHeights: [.bottomSheetAutomatic, 400],
            startTargetIndex: 1
        )
        let viewController = PortSheetViewController(model: portModel)
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .custom
        
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            dismiss(animated: true, completion: nil)
            presentPanModal(viewController)
        }else{
            self.present(viewController, animated: true, completion: {})

        }
        
        
        
//        self.present(viewController, animated: true, completion: {
//            let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: portModel.lat, longitude: portModel.long), latitudinalMeters: self.regionRadius, longitudinalMeters: self.regionRadius)
//            self.map.setRegion(coordinateRegion, animated: true)
//        })
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


extension UIColor{
    public class var primaryColor : UIColor {
        return UIColor.link
    }
}

extension UISearchBar{

    func getClearSearchButton()-> UIButton?{
        
        guard let searchTextField = self.textField else {return nil}
        guard let clearButton     = searchTextField.value(forKey: "_clearButton") as? UIButton else {return nil}
        return clearButton
    }
    
    public func clearSearchText(onTap: (() -> Void)?){
        
    }
    
    public func setDefaultSearchBar(){
        self.barTintColor = UIColor.link
        self.tintColor    = UIColor.link
        self.cursorColor = UIColor.link
        
        self.textField?.textColor = UIColor.black
        self.textField?.backgroundColor = UIColor.white

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.link.cgColor
        
        self.backgroundColor = UIColor.link
        self.placeholder = "Search"
        self.setShowsCancelButton(true, animated: true)
        
        if let cancel_btn = self.cancelButton {
            cancel_btn.setTitle("Cancel", for: .normal)
            cancel_btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            cancel_btn.sizeToFit()
        }
    }
    
    public var cursorColor: UIColor! {
        set {
            for subView in self.subviews[0].subviews where ((subView as? UITextField) != nil) {
                subView.tintColor = newValue
            }
        }
        get {
            for subView in self.subviews[0].subviews where ((subView as? UITextField) != nil) {
                return subView.tintColor
            }
            // Return default tintColor
            return UIColor.link
        }
    }
    
    //get SearchTextField
    public var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        return self.value(forKey: "searchField") as? UITextField
    }
    
    public var cancelButton: UIButton? {
        if #available(iOS 13, *) {
            return subviews.last?.subviews.last?.subviews.last(where: {String(describing: $0).contains("UINavigationButton")}) as? UIButton
        } else {
            guard let cancel_btn = self.value(forKey: "_cancelButton") as? UIButton else {return nil}
            return cancel_btn
        }
    }
}



@objc open class LocationUtil: NSObject, CLLocationManagerDelegate{
     
     @objc public static let sharedIntance = LocationUtil()
     var locationManager: CLLocationManager = CLLocationManager()
     var authorizedCompletion: (() -> ()) = {}
     
     public func alertPromptToAllowLocationAccessViaSetting(){
          let alert = UIAlertController(title: "Permission for your Location was denied", message: "Please enable access to your Location in the Settings app", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { [weak self](alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],
                                      completionHandler: {
                                        (success) in
                                      })
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak self](alert) in
            self?.authorizedCompletion = {}
            self?.locationManager.delegate = nil
        }))
        
        
          
          if !(UIApplication.topViewController() is UIAlertController) {
               UIApplication.topViewController().present(alert, animated: true, completion: nil)
          }
     }
     
     @objc public func checkAuthorizedLocation(authorizedCompletion: @escaping ()-> Void){
          self.authorizedCompletion = authorizedCompletion
          let status = CLLocationManager.authorizationStatus()
          
          switch status {
          case .authorizedAlways:
               self.authorizedCompletion()
               self.authorizedCompletion = {}
               locationManager.delegate = nil
               break
          case .authorizedWhenInUse:
               self.authorizedCompletion()
               self.authorizedCompletion = {}
               locationManager.delegate = nil
               break
          case .denied:
               locationManager.delegate = self
               self.alertPromptToAllowLocationAccessViaSetting()
               break
          case .notDetermined:
               locationManager.delegate = self
               locationManager.requestAlwaysAuthorization()
               break
          case .restricted:
               break
          default:
            break
          }
     }
     
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          switch  status{
          case .authorizedAlways:
               self.authorizedCompletion()
               self.authorizedCompletion = {}
               locationManager.delegate = nil
               break
          case .authorizedWhenInUse:
               self.authorizedCompletion()
               self.authorizedCompletion = {}
               locationManager.delegate = nil
               break
          case .denied:
               locationManager.delegate = self
               self.alertPromptToAllowLocationAccessViaSetting()
               break
          case .notDetermined:
               locationManager.delegate = self
               locationManager.requestAlwaysAuthorization()
               break
          case .restricted:
               break
          default:
            break
        }
     }
}


extension UIApplication {
    
    @objc public static func setSharedStatusBarStyle(_ style: UIStatusBarStyle = UIStatusBarStyle.default,animated:Bool = true) {
        UIApplication.shared.setStatusBarStyle(style, animated: animated)
    }
    
    @objc open class func topViewController(_ inputBase: UIViewController? = nil ) -> UIViewController {
        var base : UIViewController? = inputBase
        
        if(base == nil) {
            if let delegateWindow = UIApplication.shared.delegate?.window,let window = delegateWindow {
                base = window.rootViewController
            }
            else {
                base = UIApplication.shared.keyWindow?.rootViewController
            }
            
        }
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController ?? nav.topViewController ?? nav.viewControllers.first)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let split = base as? UISplitViewController {
            return topViewController(split.viewControllers.first)
        }
        
        if let presented = base?.presentedViewController {
            if (presented is UINavigationController) && (presented as! UINavigationController).viewControllers.count == 0 {
                return base!
            }
            return topViewController(presented)
        }
        
        return base ?? UIViewController()
    }
    
    @objc public static func setSharedStatusBarHidden(_ isHidden : Bool,animated:Bool = true, animationType: UIStatusBarAnimation = .fade) {
        UIApplication.shared.setStatusBarHidden(isHidden, with: animationType)
    }
    
    @objc public static func iOS_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
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
