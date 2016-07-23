//
//  TutorialViewController.swift
//  DNews
//
//  Created by robert pham on 6/25/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

let kNeedShowLoginNotification = "com.dnews.needShowLoginNotification"

class TutorialViewController: BaseViewController, OtherStoryboardInstance {
    
    var firstTime = false
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tutorial"
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if firstTime == false {
            let skipButton = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(TutorialViewController.skip))
            self.navigationItem.rightBarButtonItem = skipButton
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 4, CGRectGetHeight(self.scrollView.frame))
    }
    
    func skip() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if firstTime {
            self.dismissViewControllerAnimated(false, completion: { 
                NSNotificationCenter.defaultCenter().postNotificationName(kNeedShowLoginNotification, object: nil)
            })
        } else {
            if UserManager.sharedInstance.isLoggedIn() == false {
                self.dismissViewControllerAnimated(false, completion: {
                    NSNotificationCenter.defaultCenter().postNotificationName(kNeedShowLoginNotification, object: nil)
                })
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func skipButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
