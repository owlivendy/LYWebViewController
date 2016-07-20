//
//  DemoViewController.swift
//  LYWebViewController
//
//  Created by xiaofeishen on 16/7/9.
//  Copyright © 2016年 xiaofeishen. All rights reserved.
//

import UIKit

class DemoViewController: MyAppWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "second"

        let path = NSBundle.mainBundle().pathForResource("base", ofType: "html")
        var htmlCtn:String?
        do {
            htmlCtn = try String(contentsOfFile: path!)
        } catch {
            
        }
        
        webView.loadHTMLString(htmlCtn!, baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
