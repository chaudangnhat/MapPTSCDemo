//
//  LocationUtil.swift
//  MapDemo
//
//  Created by dinh vien  on 12/03/2022.
//

import Foundation
import CoreLocation
import UIKit

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
