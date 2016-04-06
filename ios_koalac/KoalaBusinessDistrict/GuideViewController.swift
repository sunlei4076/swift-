//
//  GuideViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/3.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController,UIScrollViewDelegate{

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initControl(){
        self.scrollView.delegate = self
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let scrollWidth = CGRectGetWidth(scrollView.bounds)
        let offset = scrollView.contentOffset
        let index:Int = Int(offset.x/scrollWidth)
                
        self.pageControl.currentPage = index
        
        if index == 4{
            self.pageControl.hidden = true
            /*
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3)), dispatch_get_main_queue(), { () -> Void in
                let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                mainVC.delegate = appDelegate
                appDelegate.window?.rootViewController = mainVC
            })*/
        }else{
            self.pageControl.hidden = false
        }
    }
    
    @IBAction func actionEnter(sender: AnyObject) {
        
        let lastAccount = LoginAccountTool.getLastLoginAccount()
        
        if lastAccount.name.isEmpty{
            
            
            
            let vc = NoLoginViewController()
            
            let nav = UINavigationController(rootViewController: vc)
            

            
            self.presentViewController(nav, animated: true, completion: nil)
            
        }else{
            
            
            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            mainVC.delegate = appDelegate
            appDelegate.window?.rootViewController = mainVC
        }
        
        
    }
}
