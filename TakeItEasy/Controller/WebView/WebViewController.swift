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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var buttonBackground: UIView!

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

        backButton.isEnabled = false
        forwardButton.isEnabled = false

        buttonBackground.backgroundColor = .systemGray5
        buttonBackground.layer.cornerRadius = 10
        buttonBackground.clipsToBounds = true


    }

    @IBAction func reloadAction(_ sender: Any) {
        self.webView?.reload()
    }
    
    @IBAction func backwardAction(_ sender: Any) {
        self.webView?.goBack()

        if let backList = webView?.backForwardList.backList, backList.count == 1 {
            backButton?.isEnabled = false
        } else {
            backButton?.isEnabled = true
        }
        forwardButton?.isEnabled = true
    }

    @IBAction func forwardAction(_ sender: Any) {
        self.webView?.goForward()

        if let forwardList = webView?.backForwardList.forwardList, forwardList.count == 1 {
            forwardButton?.isEnabled = false
        } else {
            forwardButton?.isEnabled = true
        }
        backButton?.isEnabled = true
    }

    // Can be run before viewDidLoad to speed up loading
    func setUpWebView() {
        if let pageURL {
            webView = WKWebView()
            webView?.load(URLRequest(url: pageURL))
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if webView.backForwardList.backList.count == 0 {
            backButton?.isEnabled = false
        } else {
            backButton?.isEnabled = true
        }
        forwardButton?.isEnabled = false
    }

}
