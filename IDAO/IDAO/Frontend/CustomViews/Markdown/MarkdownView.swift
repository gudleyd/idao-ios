//
//  MarkdownView.swift
//  IDAO
//
//  Created by Ivan Lebedev on 17.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//


//

import Foundation
import UIKit
import WebKit


open class MarkdownView: UIView {

    private var webView: WKWebView?
  
    fileprivate var intrinsicContentHeight: CGFloat? {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    @objc public var isScrollEnabled: Bool = true {
        didSet {
            webView?.scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    @objc public var onTouchLink: ((URLRequest) -> Bool)?

    @objc public var onRendered: ((CGFloat) -> Void)?

    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init (frame: CGRect) {
        super.init(frame : frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override var intrinsicContentSize: CGSize {
        if let height = self.intrinsicContentHeight {
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        } else {
            return CGSize.zero
        }
    }

    @objc public func load(markdown: String?, enableImage: Bool = true) {
        guard let markdown = markdown else { return }

        let bundle = Bundle.main

        let htmlURL: URL? =
            bundle.url(forResource: "index",
                       withExtension: "html")
        
        self.webView?.navigationDelegate = nil
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil

        if let url = htmlURL {
            let templateRequest = URLRequest(url: url)

            let escapedMarkdown = self.escape(markdown: markdown) ?? ""
            let imageOption = enableImage ? "true" : "false"
            let script = "window.showMarkdown('\(escapedMarkdown)', \(imageOption));"
            let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

            let controller = WKUserContentController()
            controller.addUserScript(userScript)

            let configuration = WKWebViewConfiguration()
            configuration.userContentController = controller

            let wv = WKWebView(frame: self.bounds, configuration: configuration)
            wv.scrollView.isScrollEnabled = self.isScrollEnabled
            wv.translatesAutoresizingMaskIntoConstraints = false
            wv.navigationDelegate = self
            self.addSubview(wv)
            wv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            wv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            wv.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            wv.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            wv.backgroundColor = self.backgroundColor

            self.webView = wv
            
            wv.load(templateRequest)
        }
    }
    
    public func cancel() {
        self.onRendered = nil
        self.webView?.stopLoading()
    }

    private func escape(markdown: String) -> String? {
        return markdown.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
    }

}

extension MarkdownView: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = "document.body.scrollHeight;"
        webView.evaluateJavaScript(script) { [weak self] result, error in
            if let _ = error { return }

            if let height = result as? CGFloat {
                self?.onRendered?(height)
                self?.intrinsicContentHeight = height
            }
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        switch navigationAction.navigationType {
        case .linkActivated:
            if let onTouchLink = onTouchLink, onTouchLink(navigationAction.request) {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        default:
            decisionHandler(.allow)
        }

    }

}
