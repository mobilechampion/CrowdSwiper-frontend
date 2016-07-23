//
//  BaseSideViewController.swift
//  DNews
//
//  Created by robert pham on 6/22/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import MMDrawerController

class BaseSideViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let barItem = MMDrawerBarButtonItem(target: self, action: #selector(BaseSideViewController.showSideMenu))
        self.navigationItem.leftBarButtonItem = barItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showSideMenu() {
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
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
