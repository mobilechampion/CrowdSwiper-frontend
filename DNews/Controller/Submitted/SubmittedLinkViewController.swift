//
//  SubmittedLinkViewController.swift
//  DNews
//
//  Created by robert pham on 6/22/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SubmittedLinkViewController: BaseSideViewController, UserStoryboardInstance {

    let handler = SubmitLinkHandler()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SUBMITTED LINKS"
        self.tableView.registerNib(UINib(nibName: SubmittedCell.className(), bundle: nil), forCellReuseIdentifier: SubmittedCell.className())
        tableView.addPullToRefresh {
            self.refreshData()
        }
        getSubmittedLinks(showLoading: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getSubmittedLinks(showLoading show: Bool) {
        if show {
            showLoadingOnView(self.view)
        }
        
        handler.getListSubmitted(UserManager.sharedInstance.userId) { [weak self] (success, error) in
            if show {
                removeAllLoadingOnView(self?.view)
            }
            self?.tableView.endRefreshing()
            self?.addLoadMore()
            if success {
                self?.tableView.reloadData()
            } else {
                showErrorNotification(text: error?.failureReason)
            }
        }
    }

    func addLoadMore() {
        self.tableView.addLoadmore(canLoadMore: handler.canLoadmore) { [weak self]() in
            self?.getSubmittedLinks(showLoading: false)
        }
    }
    
    func refreshData() {
        showLoadingOnView(self.view)
        handler.refreshData(UserManager.sharedInstance.userId) { [weak self] (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                removeAllLoadingOnView(self?.view)
                self?.tableView.endRefreshing()
                self?.addLoadMore()
                if success {
                    self?.tableView.reloadData()
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        }
    }
    
    func changeApprove(model: ArticleModel) {
        showLoadingOnView(self.view)
        model.update(!model.approved) { [weak self] (success, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                removeAllLoadingOnView(self?.view)
                if success {
                    self?.tableView.reloadData()
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        }
    }
}


extension SubmittedLinkViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handler.models.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = handler.models[indexPath.row]
        let detailVc = ArticleViewController.createInstance() as! ArticleViewController
        detailVc.article = model
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SubmittedCell.className()) as! SubmittedCell
        let model = handler.models[indexPath.row]
        cell.model = model
        cell.approveButtonBlock = { [weak self]()-> Void in
            self?.changeApprove(model)
        }
        
        return cell
    }
}


