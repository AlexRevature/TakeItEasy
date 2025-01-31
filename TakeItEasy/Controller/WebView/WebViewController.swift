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

        // WebView constrained to wrapper to allow for background editing
        documentWrapper.addSubview(webView!)
        let viewsDict = ["view": webView]
        documentWrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", metrics: nil, views: viewsDict as [String : Any]))
        documentWrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", metrics: nil, views: viewsDict as [String : Any]))

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem (
            image: UIImage(systemName: "chevron.left"),
            style: .done,
            target: self,
            action: #selector(reverseWebView)
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }

    @objc
    func reverseWebView() {
        self.webView?.goBack()
    }

    // Can be run before viewDidLoad to speed up loading
    func setUpWebView() {
        if let pageURL {
            webView = WKWebView()
            webView?.load(URLRequest(url: pageURL))
        }
    }

}
