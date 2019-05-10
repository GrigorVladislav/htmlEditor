//
//  WebViewController.swift
//  htmlEditor
//
//  Created by Admin on 09.05.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController:UIViewController, WKUIDelegate {
    
    var htmlContent: String?
    var webView: WKWebView!
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if htmlContent != nil{
        
            webView.loadHTMLString(htmlContent!, baseURL: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }

}
}
