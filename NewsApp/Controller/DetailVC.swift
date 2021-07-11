//
//  DetailVC.swift
//  NewsApp
//
//  Created by Alexandr on 08.07.2021.
//

import UIKit
import WebKit

final class DetailVC: UIViewController, WKNavigationDelegate  {
	var url: URL?
	
	@IBOutlet private weak var webView: WKWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		webView.navigationDelegate = self
		
		guard let url = url else {
			return
		}
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
    }
}
