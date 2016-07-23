//
//  SideMenuViewController.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SideMenuViewController: BaseViewController, MainStoryboardInstance {

    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let titleArray = ["HOME", "SHARE APP", "ACCOUNT", "FAVORITES", "SUBMITTED", "TUTORIAL", "CONTACT US"]
    let icons = ["icon-home", "icon-share-app","icon-account", "icon-favorite", "icon-submited", "icon-tutorial", "icon-contact"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 30
        let color1 = UIColor(hexString: "223554")
        let color2 = UIColor(hexString: "5fa0b4")
        self.view.backgroundColor = UIColor(gradientStyle: .LeftToRight, withFrame: self.view.frame, andColors: [color1, color2])
        signoutButton.backgroundColor = UIColor.flatWatermelonColor()
        usernameLabel.textColor = UIColor.whiteColor()
        tableView.registerNib(UINib(nibName: SideMenuCell.className(), bundle: nil), forCellReuseIdentifier: SideMenuCell.className())
        if tableView.numberOfRowsInSection(0) > 0 {
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .Top)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkLoginStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signoutButtonPressed(sender: AnyObject) {
        if UserManager.sharedInstance.isLoggedIn() {
            AppDelegate.logout()
            checkLoginStatus()
        } else {
            showLoginView()
        }
        
    }
    
    private func checkLoginStatus() {
        if UserManager.sharedInstance.isLoggedIn() {
            usernameLabel.text = UserManager.sharedInstance.userToken?.uid
            signoutButton.backgroundColor = UIColor.flatWatermelonColor()
            signoutButton.setTitle("SIGN OUT", forState: .Normal)
        } else {
            usernameLabel.text = "GUEST"
            signoutButton.backgroundColor = UIColor.flatSkyBlueColor()
            signoutButton.setTitle("SIGN IN", forState: .Normal)
        }
    }

}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) { 
            if indexPath.row == 0 {
                let vc = BaseHomeViewController.createInstance()
                self.setCenterView(vc)
            } else if indexPath.row == 5 {
                let vc = TutorialViewController.createInstance()
                let nav = UINavigationController(rootViewController: vc)
                self.presentViewController(nav, animated: true, completion: nil)
            } else if indexPath.row == 6 {
                let vc = ContactUsViewController.createInstance()
                self.setCenterView(vc)
            } else {
                if UserManager.sharedInstance.isLoggedIn() {
                    if indexPath.row == 2 {
                        let vc = ProfileViewController.createInstance()
                        self.setCenterView(vc)
                    } else if indexPath.row == 3 {
                        let vc = FavoriteViewController.createInstance()
                        self.setCenterView(vc)
                    } else if indexPath.row == 4 {
                        let vc = SubmittedLinkViewController.createInstance()
                        self.setCenterView(vc)
                    }
                } else {
                    self.showLoginView()
                }
            }
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SideMenuCell.className()) as! SideMenuCell
        cell.contentLabel.text = titleArray[indexPath.row]
        cell.iconImageView.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    private func setCenterView(vc: UIViewController) {
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
        self.mm_drawerController.centerViewController = UINavigationController(rootViewController: vc)
    }
}
