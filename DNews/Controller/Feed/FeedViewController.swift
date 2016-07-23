//
//  FeedViewController.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

let needRefreshNotification = "com.dnews.needRefreshHome"

class FeedViewController: BaseViewController, HomeStoryboardInstance {

    @IBOutlet weak var tableView: UITableView!
    let handler = HomeHandler()
    var needRefreshWhenAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedViewController.needRefresh), name: needRefreshNotification, object: nil)
        tableView.registerNib(UINib(nibName: FeedCell.className(), bundle: nil), forCellReuseIdentifier: FeedCell.className())
        tableView.addPullToRefresh {
            self.refreshData()
        }
        getArticles(showLoading: true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func needRefresh() {
        needRefreshWhenAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if needRefreshWhenAppear {
            needRefreshWhenAppear = false
            refreshData()
        }
    }


    func getArticles(showLoading show: Bool) {
        if show {
            showLoadingOnView(self.view)
        }
        
        handler.getArticles { [weak self] (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if show {
                    removeAllLoadingOnView(self?.view)
                }
                self?.tableView.endRefreshing()
                if success {
                    self?.tableView.reloadData()
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
            
        }
    }
    
    func refreshData() {
        getArticles(showLoading: true)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handler.models.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) { 
            let mod = self.handler.models[indexPath.row]
            let detailVc = ArticleViewController.createInstance() as! ArticleViewController
            detailVc.article = mod
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
        let mod = handler.models[indexPath.row]
        cell.model = mod
        return cell
    }
}
