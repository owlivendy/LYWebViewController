//
//  ZSBWebViewController.swift
//  TestSwift
//
//  Created by xiaofeishen on 16/7/7.
//  Copyright © 2016年 xiaofeishen. All rights reserved.
//

import UIKit
import WebKit

/**
 *  基于WKWebView的WebViewController
 */
@available(iOS 8.0, *)
public class LYWebViewController: UIViewController, WKNavigationDelegate {
    
    //MARK: public property
    public var showLoadingBar:Bool
    public let webView:WKWebView
    public var url:NSURL?
    public var loadingBarColor:UIColor?
    
    //MARK: private property
    private var loadingBar = LoadingBar()
    
    //MARK: initializer
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        webView = WKWebView()
        showLoadingBar = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(url:NSURL) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    convenience init(urlString:String) {
        self.init(nibName: nil, bundle: nil)
        if let tmp = NSURL(string: urlString) {
            self.url = tmp
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        webView = WKWebView()
        showLoadingBar = true
        super.init(coder: aDecoder)
    }

    //MARK: life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        configBackItem()
        configWeb()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configLoadingBar(true)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        configLoadingBar(false)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: action
    public func goBack(sender:UIBarButtonItem) {
        if webView.canGoBack {
            addCloseItem()
            webView.goBack()
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            if let progress = change?[NSKeyValueChangeNewKey] as? NSNumber {
                if progress.floatValue >= 1 {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                }
                loadingBar.progress = progress.floatValue
            }
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    //MARK: WKWebView Delegate
    public func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        
    }
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error)
    }
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error)
    }
}

private class LoadingBar:UIView {
    //MARK: public method
    /// range:0 - 1
    var progress:Float {
        didSet {
            if oldValue != progress {
                self.alpha = 1
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.2)
                let timefunc = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                CATransaction.setAnimationTimingFunction(timefunc)
                setProgress(progress)
                CATransaction.commit()
                
                if progress == 1 {
                    let timer = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)*0.3))
                    dispatch_after(timer, dispatch_get_main_queue(), {
                        self.alpha = 0
                        self.reset()
                    })
                }
            }
        }
    }
    var loadingColor:UIColor? {
        didSet {
            if let _ = loadingColor {
                progressLayer.backgroundColor = loadingColor!.CGColor
            }
        }
    }
    
    //MARK: private property
    private var progressLayer:CALayer
    
    override init(frame: CGRect) {
        progressLayer = CALayer()
        progress = 0
        super.init(frame: frame)
        layer.addSublayer(progressLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        progressLayer = CALayer()
        progress = 0
        super.init(coder: aDecoder)
        layer.addSublayer(progressLayer)
    }
    
    func reset() {
        setProgress(0)
    }
    
    private func setProgress(progress:Float) {
        var rect = self.bounds
        rect.size.width = rect.width * CGFloat(progress)
        progressLayer.frame = rect
    }
    
    private override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(progressLayer.frame), CGRectGetHeight(self.frame))
    }
}

extension LYWebViewController {
    //MARK: helper
    private func configLoadingBar(appear:Bool) {
        if !appear {
            loadingBar.removeFromSuperview()
            return
        }
        if let bar = self.navigationController?.navigationBar {
            loadingBar.loadingColor = loadingBarColor ?? bar.tintColor
            loadingBar.progress = Float(webView.estimatedProgress)
            loadingBar.frame = CGRectMake(0, CGRectGetHeight(bar.bounds) - 2, CGRectGetWidth(bar.bounds), 2)
            bar.addSubview(loadingBar)
        }
    }
    
    private func configBackItem() {
        var tintColor:UIColor!
        if let bar = navigationController?.navigationBar {
            tintColor = bar.tintColor
        }
        else {
            tintColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
        let backBtn = UIButton(type: .Custom)
        backBtn.addTarget(self, action: #selector(goBack(_:)), forControlEvents:.TouchUpInside)
        backBtn.frame = CGRectMake(0, 0, 60, 44)
        backBtn.setTitle("返回", forState: .Normal)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        backBtn.setTitleColor(tintColor, forState: .Normal)
        if let image = indicatorImage(tintColor) {
            backBtn.setImage(image, forState: .Normal)
            backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        }
        let backItem = UIBarButtonItem(customView: backBtn)
        let fixSpaceItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixSpaceItem.width = -15
        navigationItem.leftBarButtonItems = [fixSpaceItem,backItem]
    }
    
    /**
     配置webView
     */
    private func configWeb() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.navigationDelegate = self
        view.addSubview(webView)
        //layout
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor.blueColor()
        NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0).active = true
    }
    
    private func indicatorImage(color:UIColor) -> UIImage? {
        let scale = UIScreen.mainScreen().scale
        let ctxSize = CGSizeMake(14 * scale, 24 * scale)
        UIGraphicsBeginImageContext(ctxSize)
        let ctx = UIGraphicsGetCurrentContext()
        let path = CGPathCreateMutable()
        let offset:CGFloat = 4
        CGPathMoveToPoint(path, nil, ctxSize.width - offset, offset)
        CGPathAddLineToPoint(path, nil, offset, ctxSize.height/2)
        CGPathAddLineToPoint(path, nil, ctxSize.width - offset, ctxSize.height - offset)
        CGContextAddPath(ctx, path)
        CGContextSetLineWidth(ctx, 6)
        CGContextSetStrokeColorWithColor(ctx, color.CGColor)
        CGContextDrawPath(ctx, .Stroke)
        
        var image:UIImage?
        if let cgImage = UIGraphicsGetImageFromCurrentImageContext().CGImage {
            image = UIImage(CGImage: cgImage, scale: scale, orientation: .Up)
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    private func addCloseItem() {
        if navigationItem.leftBarButtonItems?.count == 2 {
            let closeItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(closeAction))
            navigationItem.leftBarButtonItems?.append(closeItem)
        }
    }
    
    @objc private func closeAction() {
        navigationController?.popViewControllerAnimated(true)
    }
}
