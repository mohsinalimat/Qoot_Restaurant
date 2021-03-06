//
//  CCUtility.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit

class CCUtility: NSObject {
    class func getJSONfrom(dictionary:[String:Any?]) -> String {
        var jsonString:String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
        guard let requestBody = jsonString else {
            return ""
        }
        return requestBody
    }
    
    
    class func showDefaultAlertwith(_title : String, _message : String, parentController : UIViewController){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
            }
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
    
   
    
    class func showDefaultAlertwithCompletionHandler(_title : String, _message : String, parentController : UIViewController, completion:@escaping (_ okSuccess:Bool)->()){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default, handler: { action in
            completion(true)
            switch action.style{
                
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
    
    class func showActionAlertwithCancel(_title : String, _message : String, parentController : UIViewController,action:UIAlertAction){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "CANCEL".localiz(), style: .cancel, handler: { action in
            //  alert.dismiss(animated: true, completion: )
        }))
        parentController.present(alert, animated: true, completion: nil)
        
    }
    
   class func showAlertWithOkOrCancel(_title : String, viewController:UIViewController, messageString:String, completion:@escaping (_ result:String) -> Void) {
    
        let alertController = UIAlertController(title: _title, message: messageString, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK".localiz(), style: .default) { (action:UIAlertAction) in
            completion ("Ok")
        }
        let noAction = UIAlertAction(title: "CANCEL".localiz(), style: .default) { (action:UIAlertAction) in
            completion ("Cancel")
        }
   
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        viewController.present(alertController, animated: true) {
        }
    }
    class func showAlertWithoutOkOrCancel(_title : String, viewController:UIViewController, messageString:String, completion:@escaping () -> Void) {
        let alertController = UIAlertController(title: _title, message: messageString, preferredStyle: .alert)
        viewController.present(alertController, animated: true) {
        }
    }
    
    class func showActionAlertwith(_title : String, _message : String, parentController : UIViewController,action:UIAlertAction){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(action)
        
        parentController.present(alert, animated: true, completion: nil)
        
    }
    
    class func openSocialLink(_url : String){
        if let url = URL(string: _url) {
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    class func showActionAlertForSessionTimeOut(parentController : UIViewController){
        let alertController = UIAlertController(title: Constant.AppName, message: "SESSIONINVALID".localiz(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK".localiz(), style: .default) { (action:UIAlertAction) in
            CCUtility.processAfterLogOut()
        }
        alertController.addAction(yesAction)
        parentController.present(alertController, animated: true) {
        }
    }
    
    
    
    class func stringFromDate(date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func dateString(with dateString : String,from dateFormat:String, to format:String) -> String
    {
        
        if dateString == "0000-00-00" || dateString == ""
        {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from:date!)
        return dateStr
    }
    
    class func date(from dateString : String, to format:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Current time zone
        let date = dateFormatter.date(from: dateString)
        guard let _date = date else {
            return Date()
        }
        return _date
    }
    
    class func convertToDateToFormat(inputDate:String,inputDateFormat:String,outputDateFormat:String)->String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputDateFormat
        let showDate = inputFormatter.date(from: inputDate)
        inputFormatter.dateFormat = outputDateFormat
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
        
    }
    
    class func processAfterLogIn(){
        UserDefaults.standard.set(true, forKey: Constant.VariableNames.isLoogedIn)
        ApplicationController.isGuestLoggedIn = false
        let nc = NotificationCenter.default
        nc.post(name: .postNotification, object: nil)
        nc.post(name: .menuResetNotification, object: nil)
    }
    
    class func guestSwitchingAfterSignUp(){
        UserDefaults.standard.set(true, forKey: Constant.VariableNames.isLoogedIn)
        ApplicationController.isGuestLoggedIn = false
        let nc = NotificationCenter.default
        nc.post(name: .menuResetNotification, object: nil)
       // Cart.addAllCartProductsToUserProducts()
    }
    
    class func processAfterLogOut(){
        UserDefaults.standard.set(false, forKey: Constant.VariableNames.isLoogedIn)
        ApplicationController.isGuestLoggedIn = false
//        if let user = User.getUser(){
//            User.deleteUser()
//            Cart.deletAllItemsFromCart()
//            Categories.deletAllItemsFromCategories()
//        }
        let nc = NotificationCenter.default
        nc.post(name: .menuResetNotification, object: nil)
        nc.post(name: .postNotification, object: nil)
        //nc.removeObserver(SideMenuViewController(), name: .menuResetNotification, object: nil)
        
       
    }
    
    class func getCurrentLanguage()->String{
        let language = UserDefaults.standard.value(forKey: "language")
        if let _language = language as? String{
            return _language
        }else{
            return "en"
        }
    }
}
