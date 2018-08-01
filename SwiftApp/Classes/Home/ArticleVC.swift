//
//  ArticleVC.swift
//  SwiftApp
//
//  Created by leeson on 2018/7/30.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit
import WebKit

class ArticleVC: UIViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate {
    //文章id
    var aticleID:String?
    //控制
    var didScroll = false
    //url
    var urlStr:String?
    
    private var topIndicator: UIActivityIndicatorView?
    
    var webView:WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.minimumFontSize = 40.0
        configuration.preferences = preferences
        let webView =  WKWebView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 49 - (IsiPhonX ? 34 : 0)), configuration:configuration)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置左侧返回键
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(backToLastVC))
        
        //wkwebview
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        self.view.addSubview(self.webView)
        self.urlStr = "https://www.jianshu.com\(self.aticleID!)"
        self.webView.load(URLRequest.init(url: URL.init(string: self.urlStr!)!))
        
        //加载“菊花”
        self.topIndicator = UIActivityIndicatorView.init(frame: CGRect(x: (SCREEN_WIDTH - 100) / 2.0, y: (SCREEN_HEIGHT - 100) / 2.0, width: 100, height: 100))
        self.topIndicator?.color = .red
        let win = UIApplication.shared.keyWindow
        win!.addSubview(self.topIndicator!)
        
    }
    
    @objc func backToLastVC() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.topIndicator?.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.webView.configuration.userContentController.add(self, name: "hidViews")
        self.webView.configuration.userContentController.add(self, name: "hidBottomViews")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "hidViews")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "hidBottomViews")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.topIndicator?.stopAnimating()
        
        //注入js代码
        //如果不是列表传来的URL不做js注入
        if self.urlStr != "\(self.webView.url!)" {return}
        
        let doc =
        """
            function hidViews(){
                //隐藏顶部信息
                document.getElementsByClassName("header-wrap")[0].style.display = "none";
                //隐藏打开简书APP按钮
                document.getElementsByClassName("open-app-btn")[0].style.display = "none";
                //隐藏底部
                document.getElementById("footer").style.display = "none";
                //document.getElementsByClassName("footer-wrap")[0].children[2].style.display = "none";
                
                //输出正文内容
                let mainBody = document.getElementsByClassName("collapse-free-content")[0].outerHTML
                window.webkit.messageHandlers.hidViews.postMessage(mainBody);
            };
            hidViews();
        """
        print(doc)
        self.webView.evaluateJavaScript(doc, completionHandler: { (htmlStr, error) in
            if error != nil {
                print(error!)
            }else if (htmlStr != nil){
                print(htmlStr!)
            }
        })
    }
    
    // 从web界面中接收到一个脚本时调用
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //print(String(format: "message.name = %@,message.body = %@",message.name,"\(message.body)"))
        
        if message.name == "hidBottomViews" {
            if("\(message.body)" == "1"){
                //如果返回1，说明已经全部隐藏，停止调用隐藏的js方法
                self.didScroll = true
            }
        }
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.topIndicator?.startAnimating()
        let url = navigationAction.request.url?.absoluteString
        print(url!)
        let urlArr = url!.components(separatedBy: "?")
        if urlArr[0].hasPrefix("https://www.jianshu.com/p/") {
            decisionHandler(WKNavigationActionPolicy.allow)
        }else{
            let urlRegex = "jianshu.com/p/(.*?)+$"
            let a = JianshuRequestModel.regexGetSub(urlRegex, urlArr[0])
            if a[0].count > 0 {
                self.webView.load(URLRequest.init(url: URL.init(string: "https://www.\(a[0])")!))
                decisionHandler(WKNavigationActionPolicy.allow)
            }else{
                self.topIndicator?.stopAnimating()
                decisionHandler(WKNavigationActionPolicy.cancel)
            }
        }
    }
    
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let url = navigationResponse.response.url?.absoluteString
        print(url!)
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    //监听滑动偏移量
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y)
        
        //如果不是列表传来的URL不做js注入
        if self.urlStr != "\(self.webView.url!)" {return}
        
        if scrollView.contentOffset.y > 600 {
            //let doc = "document.body.outerHTML"
            self.hiddenSomeViewUseJs()
        }
        
    }
    
    //隐藏HTML的一些标签元素
    func hiddenSomeViewUseJs (){
        if self.didScroll == false {
            let doc =
            """
                    function hidBottomViews (){
                        //隐藏“打开APP阅读文章“按钮
                        var hid1 = document.getElementsByClassName("open-app-btn")[0];
                        if(hid1.style.display != "none"){
                            hid1.style.display = "none";
                        }

                        //隐藏赞赏
                        var hid2 = document.getElementById("free-reward-panel");
                        if(hid2.style.display != "none"){
                            hid2.style.display = "none";
                        }

                        //隐藏评论
                        var hid3 = document.getElementById("comment-main");
                        if(hid3.style.display != "none"){
                            hid3.style.display = "none";
                        }
                        
                        //隐藏“更多精彩内容”
                        let doc1 = document.getElementById("recommended-notes");
                        var hid4 = null;
                        if(doc1 != null){
                            hid4 = doc1.getElementsByClassName("top-title")[0].getElementsByTagName("a")[0];
                            if(hid4.style.display != "none"){
                                hid4.style.display = "none";
                            }
                        }
                        
                        //隐藏推荐阅读顶部第一个广告
                        var hid5 = document.getElementsByClassName("recommend-wrap recommend-ad")[0];
                        if(hid5 == null){ return;}
                        if(hid5.style.display != "none"){
                            hid5.style.display = "none";
                        }

                        //如果全部隐藏了返回一个确认值给webView，不再调用此js方法
                        if (hid1.style.display == "none" && hid2.style.display == "none" && hid3.style.display == "none" && hid4 .style.display == "none" && hid5.style.display == "none"){
                            window.webkit.messageHandlers.hidBottomViews.postMessage("1");
                        }
                    }
                    hidBottomViews();
                """
            self.webView.evaluateJavaScript(doc, completionHandler: { (htmlStr, error) in
                if error != nil {
                    print(error!)
                }else if (htmlStr != nil){
                    print(htmlStr!)
                }
            })
        }
    }
}
