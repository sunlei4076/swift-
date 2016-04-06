//
//  CityViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/27.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{

    @IBOutlet var keyboardInputView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectBlock:((CityInfoModel)->())?
    private var cityList:[CityInfoModel] = []
    private var tableData:[Dictionary<String,AnyObject>] = []
    private var searchList:[CityInfoModel] = []
    private var inSearch:Bool = false
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
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = UIView()
        
        self.searchBar.inputAccessoryView = self.keyboardInputView
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        //获取城市列表
        NetworkManager.sharedInstance.requestCityList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let city = CityInfoModel(jsonDic: item as! Dictionary<String,AnyObject>)
                    self.cityList.append(city)
                }
            }
            self.changeToTableData()
            self.tableView.reloadData()
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
                    GShowAlertMessage(error)
                }
        })
    }

    //将接口获取的城市数据转换为首字母排序格式
    private func changeToTableData(){
        if self.cityList.count > 0{
            let sections = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
            for item in sections{
                var tempArray:[CityInfoModel] = []
                for city in self.cityList{
                    let cityName = city.city_name.utf16
                    let firstLetter = pinyinFirstLetter(cityName[cityName.startIndex])
                    let firstStr:String = String(UnicodeScalar(Int(firstLetter)))
                    
                    let result = firstStr.compare(item, options: [.CaseInsensitiveSearch, .NumericSearch], range: nil, locale: nil)
                    if result == NSComparisonResult.OrderedSame{
                        tempArray.append(city)
                    }
                }
                if tempArray.count > 0{
                    let data:Dictionary<String,AnyObject> = ["section":item,"sectionArr":tempArray]
                    self.tableData.append(data)
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.inSearch == true{
            return 1
        }else{
            return self.tableData.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.inSearch == false{
            let dic = self.tableData[section]
            return dic["section"] as? String
        }
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inSearch == true{
            return self.searchList.count
        }else{
            let dic = self.tableData[section]
            let array = JsonDicHelper.getJsonDicArray(dic, key: "sectionArr")
            return array.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if cell == nil{
            cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Gray
            cell?.textLabel?.font = GGetNormalCustomFont()
        }
        if self.inSearch == true{
            cell!.textLabel!.text = self.searchList[indexPath.row].city_name
        }else{
            let dic = self.tableData[indexPath.section]
            let array = JsonDicHelper.getJsonDicArray(dic, key: "sectionArr")
            cell!.textLabel!.text = array[indexPath.row].city_name
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectBlock != nil{
            let model:CityInfoModel
            if self.inSearch == true{
                model = self.searchList[indexPath.row]
            }else{
                let dic = self.tableData[indexPath.section]
                let array = JsonDicHelper.getJsonDicArray(dic, key: "sectionArr")
                model = array[indexPath.row] as! CityInfoModel
            }
            self.selectBlock!(model)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0{
            self.inSearch = false
        }else{
            self.inSearch = true
            self.searchList.removeAll(keepCapacity: true)
            //精确搜索
            for item in self.cityList{
                if (item.city_name.rangeOfString(searchText) != nil) {
                    self.searchList.append(item)
                }
            }
            //拼音搜索
            if self.searchList.count == 0{
                for item in self.cityList{
                    let cityPinyin = PinYinForObjc.chineseConvertToPinYin(item.city_name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
            //首字母搜索
            if self.searchList.count == 0{
                for item in self.cityList{
                    let cityPinyin = PinYinForObjc .chineseConvertToPinYinHead(item.city_name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func actionEndSearch(sender: AnyObject) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.inSearch = false
        self.tableView.reloadData()
    }
    
}
