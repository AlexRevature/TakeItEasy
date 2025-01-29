//
//  WebViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/13/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    let pageURL = URL(string: "https://duckduckgo.com")
    var webView: WKWebView?

    @IBOutlet weak var documentWrapper: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if webView == nil {
            setUpWebView()
        }

        webView?.navigationDelegate = self
        webView?.allowsBackForwardNavigationGestures = true
        webView?.translatesAutoresizingMaskIntoConstraints = false

        documentWrapper.addSubview(webView!)
        let viewsDict = ["view": webView]
        documentWrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", metrics: nil, views: viewsDict as [String : Any]))
        documentWrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", metrics: nil, views: viewsDict as [String : Any]))

    }
    
    func setUpWebView() {
        if let pageURL {
            webView = WKWebView()
            webView?.load(URLRequest(url: pageURL))
        }
    }

}
