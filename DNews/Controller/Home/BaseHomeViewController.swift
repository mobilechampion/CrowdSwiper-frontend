//
//  BaseHomeViewController.swift
//  DNews
//
//  Created by robert pham on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import MMDrawerController

class BaseHomeViewController: BaseSideViewController, HomeStoryboardInstance {
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Home", "Queue"])
        return control
    }()
    
    lazy var feedVc: FeedViewController = FeedViewController.createInstance() as! FeedViewController
    lazy var queueVc: QueueViewController = QueueViewController.createInstance() as! QueueViewController
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = self.segmentedControl
        self.segmentedControl.addTarget(self, action: #selector(BaseHomeViewController.controlValueChanged), forControlEvents: .ValueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        submitButton.backgroundColor = UIColor.clearColor()
        submitButton.layer.cornerRadius = 4
        submitButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitButton.layer.borderWidth = 1
        botView.backgroundColor = UIColor(hexString: "3d5171")
        
        controlValueChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.removeAllChildControllers()
            setChildController(self.feedVc)
        } else {
            self.removeAllChildControllers()
            setChildController(self.queueVc)
        }
    }
    
    func setChildController(vc: UIViewController) {
        self.addChildViewController(vc)
        vc.view.frame = self.contentView.bounds
        self.contentView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }

    @IBAction func submitButtonPressed() {
        if UserManager.sharedInstance.isLoggedIn() {
            let submitVc = CreateLinkViewController.createInstance()
            self.navigationController?.pushViewController(submitVc, animated: true)
        } else {
            showLoginAlert()
        }
        
    }

}
