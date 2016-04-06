//
//  SetAreaViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/29.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SetAreaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {

    private let areaBtnHeight:CGFloat = 30.0
    private var areaView:UIView?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var choiceCityBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var inputSearchTextField: UITextField!
    @IBOutlet var searchKeyboardInputView: UIView!
    
    //标识那个地方调用，1：登录后调用 0：设置里调用
    var showType:Int = 0
    private var tableData:[XiaoQuModel] = []
    private var selectedXiaoQu:[XiaoQuModel] = []
    private var inSearch:Bool = false
    private var searchList:[XiaoQuModel] = []
    private var selectCity:CityInfoModel?
    private var areaSelectIndex = 0
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
        self.title = "选择城市"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.setTitle("已选", forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.addTarget(self, action: Selector("showHasSelectedAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = UIView()
        
        self.searchView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.searchView.layer.borderWidth = 1.0
        self.searchView.layer.cornerRadius = 2.0
        self.inputSearchTextField.font = GGetNormalCustomFont()
        self.inputSearchTextField.inputAccessoryView = self.searchKeyboardInputView
        self.choiceCityBtn.titleLabel?.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
    }
    
    func showHasSelectedAction(){
        if self.selectedXiaoQu.count == 0{
            GShowAlertMessage("你还没有选择任何小区！")
            return
        }
        let hasSelectedVC = SelectedCityViewController(nibName:"SelectedCityViewController", bundle:nil)
        hasSelectedVC.selectBlock = {(selectedArray:[XiaoQuModel])->() in
            let array:[XiaoQuModel]
            self.selectedXiaoQu = selectedArray
            if self.inSearch == true{
                array = self.searchList
            }else{
                array = self.tableData
            }
            if array.count > 0{
                for item in array{
                    item.isSelected = false
                    for select in selectedArray{
                        if item.xiaoqu_id == select.xiaoqu_id{
                            item.isSelected = true
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
        hasSelectedVC.xiaoquList = self.selectedXiaoQu
        self.navigationController?.pushViewController(hasSelectedVC, animated: true)
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
//        self.tableData = LoginInfoModel.sharedInstance.xiaoquList
        //由于使用上面的赋值方式，没有做到值拷贝，而是引用。
        for item in LoginInfoModel.sharedInstance.xiaoquList{
            let xiaoqu = XiaoQuModel(copyItem: item)
            self.selectedXiaoQu.append(xiaoqu)
        }
        self.tableData = self.selectedXiaoQu
        self.tableView.reloadData()
        
        if self.showType == 1{
            let city = LoginInfoModel.sharedInstance.store.cityModel.city_name
            let cityId = LoginInfoModel.sharedInstance.store.cityModel.city_locationid
            self.choiceCityBtn.setTitle(city, forState: UIControlState.Normal)
            self.requestXiaoQuWithRegistId(cityId)
        }
        
        let limitNum = LoginInfoModel.sharedInstance.store.xiaoqu_limit
        let limitInt = (limitNum as NSString).integerValue
        if limitInt != 0{
            let gradeName = LoginInfoModel.sharedInstance.store.grade_name
            let message = "你是\(gradeName),只能选择\(limitInt)个小区"
            GShowAlertMessage(message)
        }
    }

    /***************table*****************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inSearch == true{
            return self.searchList.count
        }else{
            return self.tableData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if cell == nil{
            cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.textLabel?.font = GGetNormalCustomFont()
            cell?.textLabel?.numberOfLines = 2
        }
        let model:XiaoQuModel
        if self.inSearch == true{
            model = self.searchList[indexPath.row]
        }else{
            model = self.tableData[indexPath.row]
        }
        
        let image:UIImage?
        if model.isSelected == true{
            image = UIImage(named: "TableCell_Selected")
        }else{
            image = UIImage(named: "TableCell_Unselected")
        }
        
        
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
        cell!.accessoryView = imageView
        cell!.textLabel!.text = model.xiaoqu_name
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model:XiaoQuModel
        if self.inSearch == true{
            model = self.searchList[indexPath.row]
        }else{
            model = self.tableData[indexPath.row]
        }
        
        model.isSelected = !model.isSelected
        if model.isSelected == true{
            self.selectedXiaoQu.append(model)
        }else{
            for (index,value) in self.selectedXiaoQu.enumerate(){
                if value.xiaoqu_id == model.xiaoqu_id{
                    self.selectedXiaoQu.removeAtIndex(index)
                    break
                }
            }
        }
        
        //选择限制
        let limitNum = LoginInfoModel.sharedInstance.store.xiaoqu_limit
        let limitInt = (limitNum as NSString).integerValue
        if self.selectedXiaoQu.count > limitInt{
            let message = "由于商家等级限制，你目前最多只能选择\(limitInt)个小区"
            GShowAlertMessage(message)
            self.selectedXiaoQu.removeLast()
            return
        }
        
        let image:UIImage
        if model.isSelected == true{
            image = UIImage(named: "TableCell_Selected")!
        }else{
            image = UIImage(named: "TableCell_Unselected")!
        }
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let newView = cell.accessoryView
            let newImageView = newView as! UIImageView
            newImageView.image = image
        }
    }
    /***************搜索*****************/
    @IBAction func textFieldEditChanged(sender: AnyObject)
    {
        let searchText = (sender as! UITextField).text
        if searchText?.characters.count == 0{
            self.inSearch = false
        }else{
            self.inSearch = true
            self.searchList.removeAll(keepCapacity: true)
            //精确搜索
            for item in self.tableData{
                if (item.xiaoqu_name.rangeOfString(searchText!) != nil) {
                    self.searchList.append(item)
                }
            }
            //拼音搜索
            if self.searchList.count == 0{
                for item in self.tableData{
                    let cityPinyin = PinYinForObjc.chineseConvertToPinYin(item.xiaoqu_name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText!.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
            //首字母搜索
            if self.searchList.count == 0{
                for item in self.tableData{
                    let cityPinyin = PinYinForObjc .chineseConvertToPinYinHead(item.xiaoqu_name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText!.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func actionCancelSearch(sender: AnyObject) {
        self.inSearch = false
        self.inputSearchTextField.resignFirstResponder()
        self.inputSearchTextField.text = ""
        self.searchList.removeAll(keepCapacity: true)
        self.tableView.reloadData()
    }
    @IBAction func actionOkSearch(sender: AnyObject) {
        self.inputSearchTextField.resignFirstResponder()
    }
    
    private func requestXiaoQuWithRegistId(locationId:String){
        NetworkManager.sharedInstance.requestXiaoQuList(locationId, success: { (jsonDic:AnyObject) -> () in
            self.tableData.removeAll(keepCapacity: true)
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let xiaoqu = XiaoQuModel(jsonDic: item as! Dictionary<String,AnyObject>)
                    xiaoqu.isSelected = false
                    self.tableData.append(xiaoqu)
                }
            }
            if self.tableData.count == 0{
                GShowAlertMessage("你店铺地址所在城市没有覆盖小区，前往城市列表选择服务城市！")
            }
            self.tableView.reloadData()
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    
    private func requestXiaoQuWithId(locationId:String){
        NetworkManager.sharedInstance.requestXiaoQuList(locationId, success: { (jsonDic:AnyObject) -> () in
            self.tableData.removeAll(keepCapacity: true)
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let xiaoqu = XiaoQuModel(jsonDic: item as! Dictionary<String,AnyObject>)
                    xiaoqu.isSelected = false
                    for selected in self.selectedXiaoQu{
                        if xiaoqu.xiaoqu_id == selected.xiaoqu_id{
                            xiaoqu.isSelected = true
                            break
                        }
                    }
                    self.tableData.append(xiaoqu)
                }
            }
            self.tableView.reloadData()
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    
    private func newAreaView(){
        if self.areaView == nil{
            let view = UIView()
            view.backgroundColor = GlobalBgColor
            self.areaView = view
            if self.selectCity != nil{
                for (index,_) in self.selectCity!.areaList.enumerate(){
                    let button = self.newAreaBtton(index)
                    if button != nil{
                        self.areaView!.addSubview(button!)
                    }
                }
                let frame = self.frameForButton(self.selectCity!.areaList.count-1)
                let width = UIScreen.mainScreen().bounds.size.width
                let height = CGRectGetMaxY(frame)+8.0
                let locationY = CGRectGetMaxY(self.topView.frame) - height
                self.areaView!.frame = CGRectMake(0, locationY, width, height)
                self.areaView!.hidden = true
                self.view.addSubview(self.areaView!)
                self.view.bringSubviewToFront(self.topView)
            }
        }
    }
    
    private func showAreaView(){
        if self.areaView!.hidden == false{
            return
        }
        self.areaView!.hidden = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var frame = self.areaView!.frame
            frame.origin.y += frame.size.height
            self.areaView!.frame = frame
            /*由于auto layout 无效
            var tableFrame = self.tableView.frame
            tableFrame.origin.y += frame.size.height
            tableFrame.size.height -= frame.size.height
            self.tableView.frame = tableFrame*/
        })
    }
    
    private func hideAreaView(){
        if self.areaView!.hidden == true{
            return
        }
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var frame = self.areaView!.frame
            frame.origin.y -= frame.size.height
            self.areaView!.frame = frame
            /*由于auto layout 无效
            var tableFrame = self.tableView.frame
            tableFrame.origin.y -= frame.size.height
            tableFrame.size.height += frame.size.height
            self.tableView.frame = tableFrame*/
            }) { (flag:Bool) -> Void in
                self.areaView!.hidden = true
        }
    }
    
    private func newAreaBtton(listIndex:Int)->UIButton? {
        if self.selectCity != nil && self.selectCity?.areaList.count > listIndex{
            let button = UIButton(type:UIButtonType.Custom)
            let model = self.selectCity!.areaList[listIndex]
            button.tag = listIndex
            button.setTitle(model.area_name, forState: UIControlState.Normal)
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.layer.borderWidth = 1.0
            button.titleLabel?.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Selected)
            button.backgroundColor = UIColor.whiteColor()
            button.frame = self.frameForButton(listIndex)
            button.addTarget(self, action: Selector("areaButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            if listIndex == self.areaSelectIndex{
                button.layer.borderColor = GlobalStyleFontColor.CGColor
                button.selected = true
            }
            return button
        }
        return nil
    }
    
    private func frameForButton(listIndex:Int)->CGRect{
        var rtnFrame = CGRectZero
        //每行4个
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let offset:CGFloat = 8.0
        let btnWidth = (screenWidth-5*offset)/4
        let btnHeight:CGFloat = self.areaBtnHeight
        
        let col = listIndex%4
        rtnFrame.origin.x = offset + (offset+btnWidth)*CGFloat(col)
        //由于listIndex是Int
        let row = listIndex/4
        rtnFrame.origin.y = offset + (offset+btnHeight)*CGFloat(row)
        rtnFrame.size.width = btnWidth
        rtnFrame.size.height = btnHeight
        
        return rtnFrame
    }
    
    func areaButtonAction(sender: UIButton){
        if sender.selected == true{
            self.hideAreaView()
        }else{
//            let oldSelect = self.areaView!.viewWithTag(self.areaSelectIndex)
            //使用viewWithTag不知道如何转换为uibutton
            
            for item in self.areaView!.subviews{
                if item .isKindOfClass(UIButton){
                    let btn = item as! UIButton
                    if btn.tag == self.areaSelectIndex{
                        btn.selected = false
                        btn.layer.borderColor = UIColor.lightGrayColor().CGColor
                        break
                    }
                }
            }
            
            sender.selected = true
            sender.layer.borderColor = GlobalStyleFontColor.CGColor
            self.areaSelectIndex = sender.tag
            let locataionId = self.selectCity!.areaList[self.areaSelectIndex].area_locationid
            self.requestXiaoQuWithId(locataionId)
            self.hideAreaView()
            if self.inSearch == true{
                //取消搜索
                self.inSearch = false
                self.inputSearchTextField.resignFirstResponder()
                self.inputSearchTextField.text = ""
                self.searchList.removeAll(keepCapacity: true)
            }
        }
    }
    
    @IBAction func actionChoiceCity(sender: AnyObject) {
        if self.selectCity == nil{
            let cityVC = CityViewController(nibName:"CityViewController", bundle:nil)
            cityVC.selectBlock = {(selectedCity:CityInfoModel)->() in
                self.selectCity = selectedCity
                //添加全城
                let area = AreaModel()
                area.area_locationid = self.selectCity!.city_locationid
                area.area_name = "全城"
                area.latitude = self.selectCity!.latitude
                area.longitude = self.selectCity!.longitude
                self.selectCity!.areaList.insert(area, atIndex: 0)
                
                self.choiceCityBtn.setTitle(self.selectCity!.city_name, forState: UIControlState.Normal)
                self.requestXiaoQuWithId(self.selectCity!.city_locationid)
            }
            self.navigationController?.pushViewController(cityVC, animated: true)
        }else{
            self.newAreaView()
            if self.areaView!.hidden == true{
                //显示
                self.showAreaView()
            }else{
                //隐藏
                self.hideAreaView()
            }
        }
    }
    @IBAction func actionSave(sender: AnyObject) {
        if self.selectedXiaoQu.count == 0{
            GShowAlertMessage("请选择覆盖小区！")
        }else{
            var tempArray:[String] = []
            for item in self.selectedXiaoQu{
                tempArray.append(item.xiaoqu_id)
            }
            NetworkManager.sharedInstance.requestChangeXiaoQu(tempArray, success: { (jsonDic:AnyObject) -> () in
                //更新登录数据
                var xiaoquArray:[XiaoQuModel] = []
                for item in self.selectedXiaoQu{
                    let xiaoqu = XiaoQuModel(copyItem: item)
                    xiaoquArray.append(xiaoqu)
                }
                LoginInfoModel.sharedInstance.xiaoquList = xiaoquArray
                
                let alert = UIAlertView(title: "提示", message: "设置成功！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if self.showType == 0{
            self.navigationController?.popViewControllerAnimated(true)
        }else if self.showType == 1{
            //跳转到主页
            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = mainVC
        }
    }
}
