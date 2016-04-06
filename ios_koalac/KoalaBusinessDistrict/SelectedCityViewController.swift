//
//  SelectedCityViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/29.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SelectedCityViewController: UIViewController {

    @IBOutlet weak var inputSearchTextField: UITextField!
    @IBOutlet weak var bordView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchKeyboardInputView: UIView!
    
    var xiaoquList:[XiaoQuModel] = []
    var selectBlock:(([XiaoQuModel])->())?
    private var inSearch:Bool = false
    private var searchList:[XiaoQuModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if self.selectBlock != nil {
            var tempArray:[XiaoQuModel] = []
            for item in self.xiaoquList{
                if item.isSelected == true{
                    tempArray.append(item)
                }
            }
            self.selectBlock!(tempArray)
        }
    }

    private func initControl(){
        self.title = "已选小区"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = UIView()
        
        self.bordView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.bordView.layer.borderWidth = 1.0
        self.bordView.layer.cornerRadius = 2.0
        self.inputSearchTextField.font = GGetNormalCustomFont()
        self.inputSearchTextField.inputAccessoryView = self.searchKeyboardInputView
        self.topView.backgroundColor = GlobalBgColor
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        if self.xiaoquList.count == 0{
            for item in LoginInfoModel.sharedInstance.xiaoquList{
                let xiaoqu = XiaoQuModel(copyItem: item)
                self.xiaoquList.append(xiaoqu)
            }
            self.tableView.reloadData()
        }
    }
    
    /***************table*****************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inSearch == true{
            return self.searchList.count
        }else{
            return self.xiaoquList.count
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
            model = self.xiaoquList[indexPath.row]
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
            model = self.xiaoquList[indexPath.row]
        }
        
        model.isSelected = !model.isSelected
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
        
        if searchText!.characters.count == 0{
            self.inSearch = false
        }else{
            self.inSearch = true
            self.searchList.removeAll(keepCapacity: true)
            //精确搜索
            for item in self.xiaoquList{
                if (item.xiaoqu_name.rangeOfString(searchText!) != nil) {
                    self.searchList.append(item)
                }
            }
            //拼音搜索
            if self.searchList.count == 0{
                for item in self.xiaoquList{
                    let cityPinyin = PinYinForObjc.chineseConvertToPinYin(item.xiaoqu_name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText!.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
            //首字母搜索
            if self.searchList.count == 0{
                for item in self.xiaoquList{
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
}
