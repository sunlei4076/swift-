//
//  CheckOrdrerController.swift
//  KoalaBusinessDistrict
//
//  Created by Adobe on 15/12/10.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit


class CheckOrdrerController: UITableViewController {
    

    var goodId = ""
    
    var goodName = ""
    
    var image = ""

    
    
    var goodNums = ""
    
    var good_ids = ""
    
    var goodNum = 0
    var goodIDS = ""
    

    var orderDictory:Dictionary<String,Int> = [:]

    var currPage:Int = 0
    var shopGoodList:[ShopGoodModel] = []
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
    private func addFootRefresh(){
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
            self.requestGoodList()
        }
    }
    
    private func requestGoodList(){
        
       loadData()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.requestGoodList()
        }
        
        self.addFootRefresh()
        self.currPage = 0
        self.requestGoodList()
    
        
        initData()
//        loadData()
    }


    private func initData(){
        self.title = "勾选商品"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        
        
        let rightBtn:UIButton = UIButton(type: UIButtonType.Custom)
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.setTitle("提交", forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.addTarget(self, action: Selector("commit"), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.tableView.registerNib(UINib(nibName: "CheckOrderCell", bundle: nil), forCellReuseIdentifier: CheckOrderCell.cellIdentifier())
    }
    
    private func loadData(){

        NetworkManager.sharedInstance.requestShopGoodList(self.currPage, pageNum: 10, success: { (jsonDic:AnyObject) -> () in
            
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
  
            // let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            
            //**********/
            if self.currPage == 0{
                self.shopGoodList.removeAll(keepCapacity: true)
            }
            
            //**********/
            for item in listArray
            {
                if item is Dictionary<String, AnyObject>{
                    let good = ShopGoodModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    
                    self.image = good.default_image
                    
                    self.goodId = good.goods_id
                
                    self.goodName = good.goods_name

//                    if self.isAdd == true{
                    
                        let goodID = good.goods_id + ","
//                        let goodID = good.goods_id
                        
                        self.good_ids += goodID
//                    self.orderDictory  = [self.goodNums:self.good_ids]
//                    pprLog(self.orderDictory)
//                    }

                    self.shopGoodList.append(good)
                }
//                pprLog(self.shopGoodList.count)
                
                
                  //**********/
                if listArray.count < 10{
                     self.tableView.footer.endRefreshingWithNoMoreData()
                }else{
                    self.tableView.footer.resetNoMoreData()
                }
                
                self.endRefresh()
                self.tableView.reloadData()
                  //**********/
            }
            self.tableView.reloadData()
            }){ (error:String, needRelogin:Bool) -> () in
                if self.currPage != 0{
                    self.currPage -= 1
                }
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    

    //MARK : 提交
    func commit(){

        let orderID = ProjectManager.sharedInstance.orderID
        
        for good in self.shopGoodList{
    
            let goodID = good.goods_id
            
            let goodNum = good.good_num

            self.orderDictory[goodID] = goodNum

        }
        

        for (key ,value) in self.orderDictory{
            
            if value == 0{

                self.orderDictory.removeValueForKey(key)
    
            }else{

                
                let k = key + ","
                
                let num = (String)(value) + ","
                
                let v = num // int
                
                self.goodIDS += k
                
                self.goodNums += v
     
            }
            
        }
        
        
        if self.goodIDS.isEmpty || self.goodNums.isEmpty{
            
            GShowAlertMessage("请勾选商品")
            return
        }

        let goodIDS = (self.goodIDS as NSString)
        
        let goodNums =  (self.goodNums as NSString)
        
        let  id = goodIDS.substringToIndex(goodIDS.length - 1)
        
        let num = goodNums.substringToIndex(goodNums.length - 1)
        
        
        NetworkManager.sharedInstance.requestFaceOrderCheckShop(orderID, goodsID: id, goodsNums:num, success: { (jsonDic:AnyObject) -> () in
    
            
            let  is_select_goods =  "adobe"
            
            ProjectManager.sharedInstance.is_select_goods = is_select_goods

            
            
            self.navigationController?.popViewControllerAnimated(true)

            }) { (error:String, needRelogin:Bool) -> () in
                
                if needRelogin == true{
                    
                }else{
                    
                    GShowAlertMessage(error)
                }
        }
   
    }
    
    func backAction(){
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if  section == 0{
            return 1
        }else{
            
            return  self.shopGoodList.count
        }
    }
    
    


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = searchBar()
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier(CheckOrderCell.cellIdentifier()) as! CheckOrderCell
            
            //        let cell = tableView.dequeueReusableCellWithIdentifier(CheckOrderCell.cellIdentifier(), forIndexPath: indexPath) as! CheckOrderCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.cellData =  self.shopGoodList[indexPath.row]
        
            return cell
            
        }
        
    }
   

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 45
        }
        return 70
    }
    
    
    
    private func  searchBar() ->UITableViewCell{
        let view = UITableViewCell()
        view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 70)
        view.backgroundColor = GlobalBgColor
        
        let searchBar = UISearchBar()
        
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        searchBar.placeholder = "搜索全部商品"
        
        searchBar.frame = CGRectMake(5, 5, screenWidth - 60, 35)
        view.addSubview(searchBar)
        
        
        let btn = UIButton(type: UIButtonType.Custom)
        
        btn.setTitle("搜索", forState: UIControlState.Normal)
        
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.frame = CGRectMake(screenWidth - 60 , 5, 50, 35)
        
        btn.backgroundColor =  UIColor.grayColor()
        
        view.addSubview(btn)
 
        return view
    }
    

    

    
}
