//
//  ArticleViewController.swift
//  DNews
//
//  Created by robert pham on 6/23/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import NJKWebViewProgress
import WESlider

class ArticleViewController: BaseViewController, HomeStoryboardInstance {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var voteButton: BaseButton!
    @IBOutlet weak var slider: WESlider!
    @IBOutlet weak var progressView: NJKWebViewProgressView!
    lazy var proxy: NJKWebViewProgress = {
        return NJKWebViewProgress()
    }()
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var article: ArticleModel?
    let handler = DetailHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        voteButton.backgroundColor = AppColor.buttonColor
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.minimumTrackTintColor = UIColor.flatGrayColor()
        slider.maximumTrackTintColor = UIColor.flatWatermelonColor()
        slider.setThumbImage(UIImage(named: "icon-slider-small"), forState: .Normal)
        let red = UIColor.flatWhiteColor()
        let chunk = WEChunk(duration: 0.5, chunkColor: red)
        slider.setChunks([chunk])
        
        webView.delegate = self.proxy
        
        proxy.webViewProxyDelegate = self
        proxy.progressDelegate = self
        progressView.progress = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let model = article {
            if UserManager.sharedInstance.isLoggedIn() {
                favoriteButton.selected = model.favorited
            } else {
                favoriteButton.selected = false
            }
            
            self.title = model.title
            if let url = NSURL(string: model.url) {
                self.webView.loadRequest(NSURLRequest(URL: url))
            }
            model.checkVote({ [weak self] (success, error) in
                self?.bindVoteStatus(model)
            })
        }
    }
    
    private func bindVoteStatus(model: ArticleModel?) {
        if let model = model {
            if model.voted && UserManager.sharedInstance.isLoggedIn() {
                voteButton.backgroundColor = UIColor.grayColor()
                voteButton.userInteractionEnabled = false
                voteButton.setTitle("Voted", forState: .Normal)
                slider.userInteractionEnabled = false
                slider.value = model.averaged_votes
            } else {
                voteButton.backgroundColor = AppColor.buttonColor
                voteButton.userInteractionEnabled = true
                voteButton.setTitle("Vote", forState: .Normal)
                slider.userInteractionEnabled = true
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func voteButtonPressed(sender: AnyObject) {
        if UserManager.sharedInstance.isLoggedIn() {
            if let article = article {
                showLoadingOnView(self.view)
                handler.vote(article.id, value: slider.value, completion: { [weak self] (value, error) in
                    removeAllLoadingOnView(self?.view)
                    if error == nil {
                        self?.article?.averaged_votes = value
                        self?.article?.voted = true
                        self?.article?.didCheckVote = true
                        self?.bindVoteStatus(self?.article)
                        showSuccessNotification(text: "Vote Accepted.")
                    } else {
                        showErrorNotification(text: error?.failureReason)
                    }
                })
            }
        } else {
            showLoginAlert()
        }
        
    }
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if UserManager.sharedInstance.isLoggedIn() {
            if let model = article {
                if model.favorited {
                    showLoadingOnView(self.view)
                    model.unLike({ [weak self] (success, error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            removeAllLoadingOnView(self?.view)
                            if success {
                                self?.favoriteButton.selected = model.favorited
                            } else {
                                showErrorNotification(text: error?.failureReason)
                            }
                        })
                        })
                } else {
                    showLoadingOnView(self.view)
                    model.like({ [weak self] (success, error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            removeAllLoadingOnView(self?.view)
                            if success {
                                self?.favoriteButton.selected = model.favorited
                            } else {
                                showErrorNotification(text: error?.failureReason)
                            }
                        })
                        })
                }
            }
        } else {
            showLoginAlert()
        }
        
    }
}

extension ArticleViewController: NJKWebViewProgressDelegate, UIWebViewDelegate {
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
        
    }
}
