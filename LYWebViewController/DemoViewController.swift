//
//  DemoViewController.swift
//  LYWebViewController
//
//  Created by xiaofeishen on 16/7/9.
//  Copyright © 2016年 xiaofeishen. All rights reserved.
//

import UIKit

class DemoViewController: LYWebViewController {

    
    var wView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "second page"
        if let tmp = NSURL(string:"http://www.baidu.com") {
            webView.loadRequest(NSURLRequest(URL: tmp))
        }
        
    }
    
    func loadWebView() {
        wView = UIWebView()
        view.addSubview(wView)
        wView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        wView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        wView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        wView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        if let tmp = NSURL(string:"http://www.baidu.com") {
            wView.loadRequest(NSURLRequest(URL: tmp))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
