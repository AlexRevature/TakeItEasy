//
//  WebViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/13/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    let urlFirstPage = URL(string: "https://www.google.com")
    
    @IBOutlet weak var webViewArea: WKWebView!
    
    // MARK: - UIViewController functionality
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("web view loaded")
        webViewArea.navigationDelegate = self
        navigateWebView(url: urlFirstPage)
        webViewArea.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: - WebView functionality
    
    func navigateWebView(url: URL?) {
        guard let target = url else {
            print("Invalid URL")
            return
        }
        webViewArea.load(URLRequest(url: target))
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
