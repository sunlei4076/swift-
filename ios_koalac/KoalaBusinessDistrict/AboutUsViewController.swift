//
//  AboutUsViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/11.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    private let tableData:[String] = ["服务条款", "联系我们"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func initControl(){
        self.title = "设置"
        
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = UIView()
        
        self.versionLabel.textColor = GlobalGrayFontColor
        
        //设置字体
        self.versionLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        let infoDic =  NSBundle.mainBundle().infoDictionary
        let localVersion:AnyObject? = infoDic!["CFBundleShortVersionString"]
        self.versionLabel.text = "考拉商圈V\(localVersion!)版本"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if cell == nil{
            cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Gray
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.font = GGetNormalCustomFont()
        }
        
        cell!.textLabel!.text = self.tableData[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            let webVC = WebViewController()
            webVC.title = "服务条款"
            webVC.webUrl = "http://shop.lifeq.com.cn/releasenote/protocol.html"
            self.navigationController?.pushViewController(webVC, animated: true)
        case 1:
            let contactVC = ContactViewController(nibName:"ContactViewController", bundle:nil)
            self.navigationController?.pushViewController(contactVC, animated: true)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
