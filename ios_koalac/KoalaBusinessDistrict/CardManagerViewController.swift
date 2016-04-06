//
//  CardManagerViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CardManagerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var bankCardList:[BankCardInfoNewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
    }

    private func initControl(){
        self.title = "收款账户管理"
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
        rightBtn.addTarget(self, action: Selector("actionAddCard"), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "BankCardCell", bundle: nil), forCellReuseIdentifier: BankCardCell.cellIdentifier())
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        
        self.bankCardList.removeAll(keepCapacity: true)
        //获取收款账户列表
        NetworkManager.sharedInstance.requestDrawalCardList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let card = BankCardInfoNewModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.bankCardList.append(card)
                }
            }
            
            if self.bankCardList.count == 0{
               GShowAlertMessage("无账户信息！")
            }
            self.tableView.reloadData()
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BankCardCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bankCardList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(BankCardCell.cellIdentifier(), forIndexPath: indexPath) as! BankCardCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cardData = self.bankCardList[indexPath.row]
        return cell
    }
    
    func actionAddCard() {
        let addCardVC = AddCardViewController(nibName:"AddCardViewController", bundle:nil)
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }
}
