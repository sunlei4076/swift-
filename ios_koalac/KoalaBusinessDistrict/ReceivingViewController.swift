//
//  ReceivingViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/17.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ReceivingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var requestDate:NSDate?
    private var receivingList:[ReceivingModel] = []
    private var currPage:Int = 0
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
        self.title = "收货易"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let image = UIImage(named: "Receiving_Calendar")
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        rightBtn.setImage(image, forState: UIControlState.Normal)
        rightBtn.frame = CGRectMake(0, 0, 30, 30)
        rightBtn.addTarget(self, action: Selector("showCalender"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "ReceivingCell", bundle: nil), forCellReuseIdentifier: ReceivingCell.cellIdentifier())
        
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.initData()
        }
        
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
            self.initData()
        }

        //设置字体
    }
    
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showCalender(){
        let calendarVC = CalendarViewController(nibName:"CalendarViewController", bundle:nil)
        calendarVC.selectBlock = {(date:NSDate)->() in
            self.requestDate = date
            self.currPage = 0
            self.initData() 
        }
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    private func initData(){
        let currDate:NSDate
        if self.requestDate == nil{
            currDate = NSDate()
        }else{
            currDate = self.requestDate!
        }
        NetworkManager.sharedInstance.requestReceivingList(currDate, page: self.currPage, pageNum: 25, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            if self.currPage == 0{
                self.receivingList.removeAll(keepCapacity: true)
            }
            
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let record = ReceivingModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.receivingList.append(record)
                }
            }
            
            if listArray.count < 25{
                if self.currPage == 0 && self.receivingList.count == 0{
                    GShowAlertMessage("无数据！")
                    if let autoNormalFooter = self.tableView.footer as? MJRefreshAutoNormalFooter{
                        autoNormalFooter.setTitle("暂无数据", forState: MJRefreshStateNoMoreData)
                    }
                }else{
                    if let autoNormalFooter = self.tableView.footer as? MJRefreshAutoNormalFooter{
                        autoNormalFooter.setTitle("已加载全部", forState: MJRefreshStateNoMoreData)
                    }
                }
                self.tableView.footer.endRefreshingWithNoMoreData()
            }else{
                self.tableView.footer.resetNoMoreData()
            }
            self.endRefresh()
            self.tableView.reloadData()
            }) { (error:String, needRelogin:Bool) -> () in
                if self.currPage != 0{
                    self.currPage -= 1
                }
                if needRelogin == true{
                
                }else{
                    self.endRefresh()
                    GShowAlertMessage(error)
                }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReceivingCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receivingList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ReceivingCell.cellIdentifier(), forIndexPath: indexPath) as! ReceivingCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cellData = self.receivingList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let receivingDetailVC = ReceivingDetailViewController(nibName:"ReceivingDetailViewController", bundle:nil)
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: self.requestDate!)
        let model = self.receivingList[indexPath.row]
        receivingDetailVC.title = "\(dateComponents.month)月\(dateComponents.day)日\(model.name)配送"
        receivingDetailVC.requestDate = self.requestDate
        receivingDetailVC.storeId = model.storeId
        self.navigationController?.pushViewController(receivingDetailVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
