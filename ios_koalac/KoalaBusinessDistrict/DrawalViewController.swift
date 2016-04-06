//
//  DrawalViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class DrawalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var drawalType:String = ""
    var moneyNum:String = ""
    var moneyNunDrawaling:String = ""

    var tableData:[DrawalRecordNewModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showMoneyNumLabel: UILabel!
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
        if self.drawalType == "1" {
             self.title = "提现中金额"
        }else{
             self.title = "已提现金额"
        }

        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "DrawalRecordCell", bundle: nil), forCellReuseIdentifier: DrawalRecordCell.cellIdentifier())
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.showMoneyNumLabel.font = GGetCustomFontWithSize(GBigFontSize+4.0)
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){

        //[可选] drawal_status:     提现状态（不传则返回全部列表，drawaling提现中的列表，drawaled已提现列表）
        var drawal_status:String = ""
        if self.drawalType == "1" {
             drawal_status = "drawaling"
            self.showMoneyNumLabel.text = self.moneyNunDrawaling
        }else{
             drawal_status = "drawaled"
            self.showMoneyNumLabel.text = self.moneyNum
        }

        //获取提现记录
        NetworkManager.sharedInstance.requestDrawalRecordList(drawal_status,success:{ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let record = DrawalRecordNewModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.tableData.append(record)
                }
            }
            self.tableView.reloadData()
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
//                    GShowAlertMessage(error)
                    if self.drawalType == "1" {
                        GShowAlertMessage("您没有正在提现中的资金哦")
                    }else{
                        GShowAlertMessage("您还没有完成任何提现哦")
                    }

                }
        })
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DrawalRecordCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(DrawalRecordCell.cellIdentifier(), forIndexPath: indexPath) as! DrawalRecordCell
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
        }else{
            cell.backgroundColor = GGetColor(247.0, g: 247.0, b: 247.0)
        }
        cell.recordData = self.tableData[indexPath.row]
        return cell
    }
}
