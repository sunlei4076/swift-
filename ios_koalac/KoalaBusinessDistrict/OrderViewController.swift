//
//  OrderViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/18.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedFlagView: UIView!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    var requestDate:NSDate?
    private var currPage:Int = 0
    private var searchKeyword = ""
    var selectType:Int = 1{
        didSet{
            self.oneButton.selected = false
            self.twoButton.selected = false
            self.threeButton.selected = false
            self.fourButton.selected = false
            switch selectType{
            case 1:
                //未发货
                self.oneButton.selected = true
            case 2:
                //待退货
                self.twoButton.selected = true
            case 3:
                //已发货
                self.threeButton.selected = true
            case 4:
                //已取消
                self.fourButton.selected = true
                
            default:
                break
            }
            
            var frame = self.selectedFlagView.frame
            frame.origin.x = CGFloat((self.selectType-1))*frame.size.width
            
            UIView.animateWithDuration(0.3) { () -> Void in
                self.selectedFlagView.frame = frame
            }
            
            self.currPage = 0
            self.requestOrderList()
        }
    }
    private var tableData:[OrderModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.initControl()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func initControl(){
        self.title = "订单管理"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: OrderCell.cellIdentifier())

        
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.initData()
        }
        
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
            self.initData()
        }
        
        let buttonFont = GGetNormalCustomFont()
        self.oneButton.titleLabel?.font = buttonFont
        self.twoButton.titleLabel?.font = buttonFont
        self.threeButton.titleLabel?.font = buttonFont
        self.fourButton.titleLabel?.font = buttonFont
        
        let selectedColor = UIColor.redColor()
        self.oneButton.setTitleColor(selectedColor, forState: UIControlState.Selected)
        self.twoButton.setTitleColor(selectedColor, forState: UIControlState.Selected)
        self.threeButton.setTitleColor(selectedColor, forState: UIControlState.Selected)
        self.fourButton.setTitleColor(selectedColor, forState: UIControlState.Selected)
        
        let normalColor = GlobalGrayFontColor
        self.oneButton.setTitleColor(normalColor, forState: UIControlState.Normal)
        self.twoButton.setTitleColor(normalColor, forState: UIControlState.Normal)
        self.threeButton.setTitleColor(normalColor, forState: UIControlState.Normal)
        self.fourButton.setTitleColor(normalColor, forState: UIControlState.Normal)
        
        self.oneButton.selected = true
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
    func requestOrderList(){
        let date:NSDate
        if self.requestDate == nil{
            date = NSDate()
        }else{
            date = self.requestDate!
        }
        let status:Int
        switch self.selectType{
        case 1:
            status = 1
        case 2:
            status = 3
        case 3:
            status = 2
        case 4:
            status = 4
        default:
            status = 0
        }
        
        NetworkManager.sharedInstance.requestOrderList(date, status:status, keyword: self.searchKeyword,  page: self.currPage, pageNum: 10, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
      

            if self.currPage == 0{
                self.tableData.removeAll(keepCapacity: true)
            }
            
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let order = OrderModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.tableData.append(order)

                }
            }
            
            
            if listArray.count < 10{
                if self.currPage == 0 && listArray.count == 0{
                    if self.selectType == 1{
                        GShowAlertMessage("开店不推广，每天徒伤悲！")
                    }else if self.selectType == 2{
                        GShowAlertMessage("暂无申请退货的订单！")
                    }else if self.selectType == 3{
                        GShowAlertMessage("暂无已发货的商品！")
                    }else if self.selectType == 4{
                        GShowAlertMessage("暂无取消订单！")
                    }
                }else{
                    self.tableView.footer.endRefreshingWithNoMoreData()
                }
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
        self.requestOrderList()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let goodList:[GoodModel]
        goodList = self.tableData[indexPath.row].goods
        let goodCount:CGFloat = CGFloat(goodList.count)
        let height = OrderCell.cellHeight() + OrderGoodView.viewHeight()*goodCount
        return height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(OrderCell.cellIdentifier(), forIndexPath: indexPath) as! OrderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.row%2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
        }else{
            cell.backgroundColor = GlobalBgColor
        }
        cell.cellData = self.tableData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let orderDetailVC = OrderDetailViewController(nibName:"OrderDetailViewController", bundle:nil)
        orderDetailVC.orderData = self.tableData[indexPath.row]
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    

 
    @IBAction func oneButtonAction(sender: AnyObject) {
        //未发货
        let btn = sender as! UIButton
        if btn.selected == true{
        
        }else{
            self.selectType = 1
        }
    }
    
    @IBAction func twoButtonAction(sender: AnyObject) {
        //待退货
        let btn = sender as! UIButton
        if btn.selected == true{
            
        }else{
            self.selectType = 2
        }
    }
    
    @IBAction func threeButtonAction(sender: AnyObject) {
        //已发货
        let btn = sender as! UIButton
        if btn.selected == true{
            
        }else{
            self.selectType = 3
        }
    }
    @IBAction func fourButtonAction(sender: AnyObject) {
        //已取消
        let btn = sender as! UIButton
        if btn.selected == true{
            
        }else{
            self.selectType = 4
        }
    }
}
