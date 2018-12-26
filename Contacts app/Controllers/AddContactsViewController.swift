//
//  AddContactsViewController.swift
//  Contacts app
//
//  Created by apple on 25/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import UIKit

class AddContactsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var firstName: HoshiTextField!
    @IBOutlet weak var lastName: HoshiTextField!
    @IBOutlet weak var emailAddress: HoshiTextField!
    @IBOutlet weak var phoneNumber: HoshiTextField!
    @IBOutlet weak var nationality: HoshiTextField!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var activeTextField = UITextField()
    var newAlertWindow:UIWindow? = nil
    private var picker = UIImagePickerController()
    var contact = Contact()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        contactImage.layer.borderWidth = 2.0
        contactImage.layer.borderColor = UIColor.white.cgColor
        self.contact  = Contact(entity: Contact.entity(), insertInto: context)
    }
    
    func dismissKeyboard()  {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        firstName.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func checkIfDataIsNil() -> Bool {
        if self.contact.image == nil {
            self.showAlertVC(errMSG: "Please select your contact image.", title: "Alert")
        } else if (firstName.text?.isEmpty)!  {
            self.showAlertVC(errMSG: "Please enter your first name.", title:  "Alert" )
            return true
        } else if (emailAddress.text?.isEmpty)! {
            self.showAlertVC(errMSG: "Please enter your email address.", title:  "Alert")
            return true
        }else if (phoneNumber.text?.isEmpty)! {
            self.showAlertVC(errMSG: "Please enter your phone number.", title:  "Alert")
            return true
        }else if (nationality.text?.isEmpty)! {
            self.showAlertVC(errMSG: "Please select your nationality.", title: "Alert" )
            return true
        }
        return false
    }
    
    //************ show alert view on root viewController window *****************//
    func showAlertVC(errMSG:String, title:String){
        
        let alertController = UIAlertController(title: title,
                                                message: errMSG,
                                                preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.newAlertWindow?.resignKey()
            self.newAlertWindow?.removeFromSuperview()
            self.newAlertWindow = nil
        }
        // Add the actions
        alertController.addAction(okAction)
        
        if newAlertWindow == nil {
            
            newAlertWindow = UIWindow(frame: UIScreen.main.bounds)
            newAlertWindow?.rootViewController = UIViewController()
            newAlertWindow?.windowLevel = UIWindow.Level.alert + 1
            newAlertWindow?.makeKeyAndVisible()
            newAlertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        } else {
            
            newAlertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.moveScrollViewDown()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.moveViewUp(activeView: activeTextField, keyboardHeight: keyboardSize.height)
        }
    }
    
    /// Move View Up When keyboard Appears
    ///
    /// - Parameters:
    ///   - activeView: View that has Became First Responder
    ///   - keyboardHeight: Keyboard Height
    func moveViewUp(activeView: UIView, keyboardHeight: CGFloat) {
        
        //         Get Max Y of Active View with respect their Super View
        var viewMAX_Y = activeView.frame.maxY
        
        // Check if SuperView of ActiveView lies in Nexted View context
        // Get Max for every Super of ActiveTextField with respect to Views SuperView
        if var view: UIView = activeView.superview {
            
            // Check if Super view of View in Nested Context is View of ViewController
            while (view != self.view.superview) {
                viewMAX_Y += view.frame.minY
                view = view.superview!
            }
        }
        
        // Calculate the Remainder
        let remainder = self.view.frame.height - (viewMAX_Y + keyboardHeight)
        
        // If Remainder is Greater than 0 does mean, Active view is above the and enough to see
        if (remainder >= 0) {
            // Do nothing as Active View is above Keyboard
        }
        else {
            // As Active view is behind keybard
            // ScrollUp View calculated Upset
            UIView.animate(withDuration: 0.4,
                           animations: { () -> Void in
                            self.scrollView.contentOffset = CGPoint(x: 0, y: -remainder)
                            self.view.layoutIfNeeded()
            })
        }
        
        // Set ContentSize of ScrollView
        var contentSizeOfContent: CGSize = self.contentView.frame.size
        contentSizeOfContent.height += keyboardHeight
        self.scrollView.contentSize = contentSizeOfContent
    }
    
    
    /// Move View Down / Normal Position When keyboard disappears
    func moveScrollViewDown() {
                self.scrollView.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(0))
                let contentSizeOfContent: CGSize = self.contentView.frame.size
                self.scrollView.contentSize = contentSizeOfContent
                UIView.animate(withDuration: 0.4,
                               animations: { () -> Void in
                                self.view.layoutIfNeeded()
                })
    }
    
    @IBAction func selectNationalityAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toSelectNationality", sender: self)
    }
    
    @IBAction func addContactToDbAction(_ sender: UIButton) {
        
        if !(checkIfDataIsNil()) {
            let contactData = ContactModel.init(firstName: firstName.text ?? "", lastName: lastName.text ?? "" , emailAddress: emailAddress.text ?? "", phoneNumber: phoneNumber.text ?? "", nationality: nationality.text ?? "")
            self.contact.fullName = contactData.firstName + " " + contactData.lastName
            self.contact.email = contactData.emailAddress
            self.contact.phoneNumber = contactData.phoneNumber
            self.contact.nationality = contactData.nationality
            appDelegate.saveContext()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
    
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func pickImageAction(_ sender: UIButton) {
    
        self.navigationController?.present(picker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVc = segue.destination as? SelectNationalityViewController {
            
            destVc.delegate = self
        }
    }
    
    
    @IBAction func screenTappedAction(_ sender: UITapGestureRecognizer) {
   
        self.dismissKeyboard()
    }
}

extension AddContactsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailAddress && (emailAddress.text?.count)! > 0 {
            
            if !(emailAddress.text?.isValidEmail ?? true){
                
                emailAddress.text = ""
                self.showAlertVC(errMSG: "Please enter valid email address.", title:  "Alert")
                
            }
            
        } else if textField == phoneNumber && (phoneNumber.text?.count) ?? 0 > 0 {
            
            if !((phoneNumber.text?.validateMobile(value: phoneNumber.text ?? "")) ?? true) {
                
                phoneNumber.text = ""
                self.showAlertVC(errMSG: "Please enter valid phone number.", title:  "Alert")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        switch textField {
        case firstName:
            self.dismissKeyboard()
            lastName.becomeFirstResponder()
            break
        case lastName:
            self.dismissKeyboard()
            emailAddress.becomeFirstResponder()
            break
        case emailAddress:
            
            if !(emailAddress.text?.isValidEmail ?? true){
                emailAddress.text = ""
                self.showAlertVC(errMSG: "Please enter valid email address.", title:  "Alert")
//                emailAddress.becomeFirstResponder()
            } else {
                phoneNumber.becomeFirstResponder()
            }
            self.dismissKeyboard()
            break
        case phoneNumber:
            if !((phoneNumber.text?.validateMobile(value: phoneNumber.text ?? "")) ?? true) {
                phoneNumber.text = ""
                self.showAlertVC(errMSG: "Please enter valid phone number.", title:  "Alert")
//                phoneNumber.becomeFirstResponder()
            }else{
                // add nationality button action
            }
            self.dismissKeyboard()
            break

        default:
            dismissKeyboard()
            break
        }
        return true
    }
}

// Image Picker Delegates
extension AddContactsViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        self.contactImage.image = image
        self.contact.image = image.pngData() as NSData?
//        appDelegate.saveContext()
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension AddContactsViewController: SelectNationalityDelegate {
    
    func selected(country: Country) {
        self.nationality.text = country.countryName
    }
}
