//
//  QueueViewController.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class QueueViewController: BaseViewController, HomeStoryboardInstance {

    let handler = QueueHandler()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(QueueViewController.didSubmitLink(_:)), name: didSubmitLinkSuccessfullyNotification, object: nil)
        tableView.registerNib(UINib(nibName: FeedCell.className(), bundle: nil), forCellReuseIdentifier: FeedCell.className())
        tableView.addPullToRefresh {
            self.refreshData()
        }
        getArticles(showLoading: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func getArticles(showLoading show: Bool) {
        if show {
            showLoadingOnView(self.view)
        }
        handler.getQueue { [weak self] (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
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
            })
        }
    }
    
    func refreshData() {
        showLoadingOnView(self.view)
        handler.refreshData { [weak self] (success, error) in
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
    
    func didSubmitLink(noti: NSNotification) {
        if let model = noti.object as? ArticleModel {
            dispatch_async(dispatch_get_main_queue(), { 
                self.handler.models.insert(model, atIndex: 0)
                self.tableView.reloadData()
            })
        }
    }
    
    func addLoadMore() {
        self.tableView.addLoadmore(canLoadMore: handler.canLoadmore) { [weak self]() in
            self?.getArticles(showLoading: false)
        }
    }
    
    func publicModel(model: ArticleModel) {
        showLoadingOnView(self.view)
        model.update(!model.approved) { [weak self] (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                removeAllLoadingOnView(self?.view)
                if success {
                    model.updateLabel()
                    self?.tableView.reloadData()
                    NSNotificationCenter.defaultCenter().postNotificationName(needRefreshNotification, object: nil)
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        }
    }
}

extension QueueViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handler.models.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) { 
            let detailVc = ArticleViewController.createInstance() as! ArticleViewController
            detailVc.article = self.handler.models[indexPath.row]
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedCell.className()) as! FeedCell
        cell.delegate = self
        let model = handler.models[indexPath.row]
        cell.model = model
        
        if model.approved == false && model.is_top && model.isCurrentUser {
            let publicButton = MGSwipeButton(title: "Public", backgroundColor: UIColor.flatMintColor(), callback: { [weak self] (mcell) -> Bool in
                self?.publicModel(model)
                return true
            })
            cell.rightButtons = [publicButton]
        } else {
            cell.rightButtons = []
        }
        
        return cell
    }
}

extension QueueViewController: MGSwipeTableCellDelegate {
    
}

