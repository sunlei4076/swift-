//
//  SearchResultViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/3.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SearchResultViewController: UITableViewController {

    var tableData:[BMKPoiInfo] = []
    var selectBlock:((BMKPoiInfo)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
    }

    private func initControl(){
        self.title = "详细地址搜索"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = UIView()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if cell == nil{
            cell = UITableViewCell(style:.Subtitle, reuseIdentifier:"myCell")
        }
        
        let data = self.tableData[indexPath.row]
        cell!.textLabel?.text = data.name
        cell!.detailTextLabel!.text = data.address
        cell!.textLabel?.font = GGetNormalCustomFont()
        cell!.textLabel?.numberOfLines = 0

        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectBlock != nil{
            self.selectBlock!(self.tableData[indexPath.row])
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
