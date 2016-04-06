//
//  ReceivingDetailViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/18.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ReceivingDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var requestDate:NSDate?
    var storeId:String = ""
    private var currPage:Int = 0
    private var detailList:[ReceivingDetailModel] = []
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
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let image = UIImage(named: "Receiving_Beizhu")
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        rightBtn.setImage(image, forState: UIControlState.Normal)
        rightBtn.frame = CGRectMake(0, 0, 30, 30)
        rightBtn.addTarget(self, action: Selector("remarkAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "ReceivingDetailCell", bundle: nil), forCellReuseIdentifier: ReceivingDetailCell.cellIdentifier())
        
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.initData()
        }
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
            self.initData()
        }
        
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //备注
    func remarkAction(){
        let remarkVC = SendQuestionViewController(nibName:"SendQuestionViewController", bundle:nil)
        remarkVC.showType = 1
        remarkVC.remarkRequestDate = self.requestDate!
        self.navigationController?.pushViewController(remarkVC, animated: true)
    }
    
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
    
    private func requiredReceivingDetailList(){
        let date:NSDate
        if self.requestDate == nil{
            date = NSDate()
        }else{
            date = self.requestDate!
        }
        NetworkManager.sharedInstance.requestReceivingDetailList(date, page: self.currPage, pageNum: 25, storeId: self.storeId, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            if self.currPage == 0{
                self.detailList.removeAll(keepCapacity: true)
            }
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let detail = ReceivingDetailModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.detailList.append(detail)
                }
            }
            
            if listArray.count < 25{
                if self.currPage == 0 && listArray.count == 0{
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
    
    private func initData(){
        self.requiredReceivingDetailList()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReceivingDetailCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ReceivingDetailCell.cellIdentifier(), forIndexPath: indexPath) as! ReceivingDetailCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cellData = self.detailList[indexPath.row]
        cell.statusZeroQueHuoBtn.tag = indexPath.row
        cell.statusZeroShouQiBtn.tag = indexPath.row
        cell.statusTwoBuHuoBtn.tag = indexPath.row
        
        if indexPath.row%2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
        }else{
            cell.backgroundColor = GlobalBgColor
        }
        return cell
    }
}
