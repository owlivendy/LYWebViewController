//
//  MyAppWebViewController.swift
//  LYWebViewController
//
//  Created by xiaofeishen on 16/7/20.
//  Copyright © 2016年 xiaofeishen. All rights reserved.
//
import WebKit

class MyAppWebViewController: LYWebViewController, WKScriptMessageHandler,WKUIDelegate {
    
    let javaScriptHandle = "MyDemoApp"
    
    // initializer
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        let configTmp = WKWebViewConfiguration()
        configTmp.userContentController.addScriptMessageHandler(self, name: javaScriptHandle)
        self.config = configTmp
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configTmp = WKWebViewConfiguration()
        configTmp.userContentController.addScriptMessageHandler(self, name: javaScriptHandle)
        self.config = configTmp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.UIDelegate = self
    }
    
    override func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        super.webView(webView, didFinishNavigation: navigation)
        after(0.1) {
            let script = "btnClick()"
            self.webView.evaluateJavaScript(script, completionHandler: { (obj, error) in
                
            })
        }
    }
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) in
            completionHandler()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.Allow)
    }
    
    //MARK: WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let function = message.body as? Dictionary<String,String>
        
        var methodName = function!["method"]!
        methodName.appendContentsOf(":")
        self.performSelector(NSSelectorFromString(methodName),withObject: function!["msg"]!)
    }
    
    func alert(aa:String) {
        print(aa)
    }
}
