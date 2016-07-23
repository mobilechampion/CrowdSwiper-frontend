//
//  HomeRootViewController.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import MMDrawerController

class HomeRootViewController: MMDrawerController, MainStoryboardInstance {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let sideVc = SideMenuViewController.createInstance()
        let feedVc = BaseHomeViewController.createInstance()
        let nav = UINavigationController(rootViewController: feedVc)
        self.leftDrawerViewController = sideVc
        self.centerViewController = nav
        
        self.closeDrawerGestureModeMask = .TapCenterView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeRootViewController.needShowLoginView), name: kNeedShowLoginNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func needShowLoginView() {
        let loginVc = LoginViewController.createInstance()
        let nav = UINavigationController(rootViewController: loginVc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if TutorialHandler.needShow() {
            let tutorialVc = TutorialViewController.createInstance() as! TutorialViewController
            tutorialVc.firstTime = true
            let nav = UINavigationController(rootViewController: tutorialVc)
            self.presentViewController(nav, animated: true, completion: nil)
            
            TutorialHandler.setShowed()
        }
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

}
