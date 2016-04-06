//
//  CouponViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/3.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private var tableData:[String] = []
    @IBOutlet weak var tableView: UITableView!
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
        self.title = "优惠券"
        
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.setTitle("添加", forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.addTarget(self, action: Selector("addCouponAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "CouponCell", bundle: nil), forCellReuseIdentifier: CouponCell.cellIdentifier())
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCouponAction(){
        let addCouponVC = AddCouponViewController(nibName:"AddCouponViewController", bundle:nil)
        self.navigationController?.pushViewController(addCouponVC, animated: true)
    }
    
    private func initData(){
        self.tableData = ["1","2","3"]
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CouponCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CouponCell.cellIdentifier(), forIndexPath: indexPath) as! CouponCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = GlobalBgColor
//        cell.orderData = self.tableData[indexPath.row]
        return cell
    }
}
