//
//  RootTabBarVC.swift
//  SwiftApp
//
//  Created by leeson on 2018/6/14.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

class RootTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initTabBarVC()
    }
    
    func initTabBarVC(){
        let vcArr = ["HomeVC","FindVC","MineVC"]
        let titleArr = ["首页","发现","我的"]
        let imgArr = ["home","find","mine"]
        for i in 0..<(vcArr.count){
            //获取对应控制器类
            let vc = (NSClassFromString("SwiftApp." + vcArr[i]) as! UIViewController.Type).init()
            //创建导航控制器
            let nav = UINavigationController.init(rootViewController: vc)
            //修改导航栏背景颜色
            nav.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "barBgView2")!)//Tools.RGB_COLOR(r: 61, g: 147, b: 236)
            //修改导航栏字体颜色
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.italicSystemFont(ofSize: 25)]
            //修改导航栏按钮颜色
            nav.navigationBar.tintColor = UIColor.white
            self.addChildViewController(nav)
            //设置对应tabBarItem
            nav.tabBarItem = UITabBarItem.init(title: titleArr[i], image: UIImage(named: imgArr[i] + "_nor"), selectedImage: UIImage(named: imgArr[i] + "_sel"))
            nav.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:RGB16(value: 0x999999)], for: .normal)
            nav.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:RGB16(value: 0x3F82EA)], for: .selected)
        }
        self.tabBar.isTranslucent = false
        self.tabBar.barStyle = .black
        self.tabBar.barTintColor = UIColor(patternImage: UIImage(named: "barBgView2")!)
//        self.tabBar.backgroundImage = UIImage(named: "barBgView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
