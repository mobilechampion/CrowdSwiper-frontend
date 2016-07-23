//
//  FavoriteViewController.swift
//  DNews
//
//  Created by robert pham on 6/22/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseSideViewController, UserStoryboardInstance {

    @IBOutlet weak var tableView: UITableView!
    let handler = FavoriteHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "FAVORITE"
        self.tableView.registerNib(UINib(nibName: FeedCell.className(), bundle: nil), forCellReuseIdentifier: FeedCell.className())
        tableView.addPullToRefresh {
            self.refreshData()
        }
        getFavoriteLinks(showLoading: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        handler.checkRemovedModels()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFavoriteLinks(showLoading show: Bool) {
        if show {
            showLoadingOnView(self.view)
        }
        
        handler.getFavorites() { [weak self] (success, error) in
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
            self?.getFavoriteLinks(showLoading: false)
        }
    }
    
    func refreshData() {
        showLoadingOnView(self.view)
        handler.refreshData() { [weak self] (success, error) in
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
    

}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedCell.className()) as! FeedCell
        let model = handler.models[indexPath.row]
        cell.model = model
        return cell
    }
}