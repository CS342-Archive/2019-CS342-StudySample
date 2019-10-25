//
//  ProfileViewController.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit
import ResearchKit
import MessageUI

class ProfileViewController: UIViewController {
    
    let kSettingCell = "settingCell"
    let kSettingDetailCell = "settingDetailCell"
    
    enum ProfileSection : Int {
        case passcode
        case contact
        case withdraw
        
        static let all = [passcode, contact, withdraw]
    }
    
    enum ContactInfoRow : Int {
        case email
        case phone
        
        static let all = [email, phone]
    }
    
    enum SettingRow {
        case changePasscode
        case withdraw
        case contact
        case contactPhone
    }
    
    let settingsRowContent = [
        
        // Passcode
        [   NSLocalizedString("Change Passcode", comment: "")
        ],
        
        //Contact
        [
            NSLocalizedString("Report a Problem", comment: ""),
            NSLocalizedString("Support #", comment: "")
        ],
        
        //Withdrawal
        [
            NSLocalizedString("Withdraw from Study", comment: "")
        ],
    ]
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = StudyUser.shared.currentUser {
            self.userIdLabel.text = currentUser.uid
        }
        
        if let release = Bundle.main.releaseVersionNumber,
            let build = Bundle.main.buildVersionNumber {
            let buildDetails = "v\(release) (build \(build))"
            appVersionLabel.text = buildDetails
        }
    }
    
}

extension ProfileViewController {
    
    func getSettingRowType(_ settingName:String) -> SettingRow {
        
        var settingRowType: SettingRow = .changePasscode
        
        if (settingName == settingsRowContent[0][0]) {
            settingRowType = .changePasscode
        }
        else if (settingName == settingsRowContent[1][0]) {
            settingRowType = .contact
        }
        else if (settingName == settingsRowContent[1][1]) {
            settingRowType = .contactPhone
        }
        else if (settingName == settingsRowContent[2][0]) {
            settingRowType = .withdraw
        }
        
        return settingRowType
    }
    
    func toWithdraw() {
        performSegue(withIdentifier: "unwindToWithdrawal", sender: nil)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSection.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch ProfileSection(rawValue: section)! {
        case .passcode:
            return 1
        case .contact:
            return ContactInfoRow.all.count
        case .withdraw:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = settingsRowContent[indexPath.section]
        
        switch ProfileSection(rawValue: indexPath.section)! {
        case .withdraw:
            let cell = tableView.dequeueReusableCell(withIdentifier: kSettingCell, for: indexPath)
            cell.textLabel?.textColor = UIColor.radicalRed
            cell.textLabel?.text = section[indexPath.row]
            return cell
        case .passcode:
            let cell = tableView.dequeueReusableCell(withIdentifier: kSettingCell, for: indexPath)
            cell.textLabel?.text = section[indexPath.row]
            return cell
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: kSettingDetailCell, for: indexPath)
            cell.textLabel?.text = section[indexPath.row]
            
            let settingRow = getSettingRowType(section[indexPath.row])
            if settingRow == .contact {
                cell.detailTextLabel?.text = "contact@domain.com"
            } else if settingRow == .contactPhone {
                cell.detailTextLabel?.text = "(123) 456-7890"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = settingsRowContent[indexPath.section]
        let settingRow = getSettingRowType(section[indexPath.row])
        
        switch settingRow {
        case .changePasscode:
            self.editPasscode()
        case .contact:
            sendEmail()
        case .contactPhone:
            callPhone()
        case .withdraw:
            toWithdraw()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { //first section
            return 0
        }
        return 25
    }
    
}

//MARK: Call Support Phone
extension ProfileViewController {
    func callPhone() {
        guard let number = URL(string: "tel://1234567890") else { return }
        UIApplication.shared.open(number)
    }
}

//MARK: Send Support Email
extension ProfileViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.mailComposeDelegate = nil
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail() {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["contact@domain.com"])
        mailComposeViewController.setSubject("Support Request")
        mailComposeViewController.setMessageBody("Enter your support request here.", isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Could Not Send Email", message: "Looks like you don't have Mail app setup. Please configure to share via email.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ProfileViewController : ORKPasscodeDelegate {
    
    func editPasscode() {
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            let editPasscodeViewController = ORKPasscodeViewController.passcodeEditingViewController(withText: "", delegate: self, passcodeType:.type4Digit)
            present(editPasscodeViewController, animated: true, completion: nil)
        }
    }
    
    func passcodeViewControllerDidCancel(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Wrong Passcode Entered", message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
