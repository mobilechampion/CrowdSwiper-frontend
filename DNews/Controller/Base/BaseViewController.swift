//
//  BaseViewController.swift
//
//
//  Created by robert pham on 12/8/15.
//  Copyright © 2015 TutaCode. All rights reserved.
//

import UIKit
import ChameleonFramework

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        
        let width = UIConstants.screenWidth
        let color1 = UIColor(hexString: "111a35")
        let color2 = UIColor(hexString: "3d5171")
        self.navigationController?.navigationBar.barTintColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: CGRectMake(0, 0, width, 64), andColors: [color1, color2])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func showLoginView() {
        let vc = LoginViewController.createInstance()
        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func showLoginAlert() {
        UIAlertView(title: "", message: "You need login to continue this action. Login now?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
    }
    
}

extension BaseViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            dispatch_async(dispatch_get_main_queue(), { 
                self.showLoginView()
            })
        }
    }
}
