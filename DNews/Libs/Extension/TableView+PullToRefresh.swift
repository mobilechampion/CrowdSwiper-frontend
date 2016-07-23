//
//  TableView+PullToRefresh.swift
//  SuperCoin
//
//  Created by quangpc on 4/13/16.
//  Copyright © 2016 SuperCoin. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

extension UITableView {
    
    func addPullToRefresh(block: MJRefreshComponentRefreshingBlock) -> Void {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel.hidden = true
        header.stateLabel.hidden = true
        
        self.mj_header = header
    }
    
    func addLoadmore(canLoadMore flag: Bool, block: MJRefreshComponentRefreshingBlock) {
        if flag {
            if self.mj_footer == nil {
                let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
                footer.stateLabel.hidden = true
                
                self.mj_footer = footer
            }
        } else {
            if let _ = self.mj_footer {
                self.mj_footer = nil
            }
        }
    }
    
    func endRefreshing() {
        if let header = self.mj_header where header.isRefreshing() == true {
            header.endRefreshing()
        }
        if let footer = self.mj_footer where footer.isRefreshing() == true {
            footer.endRefreshing()
        }
    }
    
}