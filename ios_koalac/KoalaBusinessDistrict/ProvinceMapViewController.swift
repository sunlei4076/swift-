//
//  ProvinceMapViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/2.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ProvinceMapViewController: UIViewController,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate {

    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var inputSearchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var mapBgView: UIView!
    
    var selectBlock:((String)->())?
    var address:String = ""
    private var selectAddress = ""
    private let mapView:BMKMapView = BMKMapView()
    private let geoCode:BMKGeoCodeSearch = BMKGeoCodeSearch()
    private let poiSearch:BMKPoiSearch = BMKPoiSearch()
    private var annotations:[BMKPointAnnotation] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.viewWillAppear()
        self.mapView.delegate = self
        self.poiSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.mapView.viewWillDisappear()
        self.mapView.delegate = nil
        self.poiSearch.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mapView.frame = CGRectMake(0, 0, CGRectGetWidth(self.mapBgView.bounds), CGRectGetHeight(self.mapBgView.bounds))
    }
    
    private func initControl(){
        self.title = "详细地址搜索"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.inputSearchTextField.font = GGetNormalCustomFont()
        self.searchBtn.layer.borderWidth = 1.0
        self.searchBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.searchBtn.titleLabel?.font = GGetNormalCustomFont()
        
        self.mapBgView.addSubview(mapView)
        self.mapView.zoomLevel = 12
        //显示比例尺
        self.mapView.showMapScaleBar = true
        self.mapView.mapScaleBarPosition = CGPointMake(0, 0)
        self.geoCode.delegate = self
        
        self.redView.backgroundColor = GlobalStyleFontColor
        self.addressLabel.font = GGetNormalCustomFont()
        self.addressLabel.numberOfLines = 0
    }

    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        self.outPutLocation(self.address)
    }
    
    private func poiSearch(key:String){
        let option = BMKCitySearchOption()
        option.pageIndex = 0
        option.pageCapacity = 10
        option.keyword = key
        option.city = self.address
        self.poiSearch.poiSearchInCity(option)
    }
    
    
    //address->经纬度
    private func outPutLocation(address:String){
        // 初始化地址编码选项（数据模型）
        let option = BMKGeoCodeSearchOption()
        // 将数据传到地址编码模型
        option.address = address
        // 调用地址编码方法，让其在代理方法中输出
        self.geoCode.geoCode(option)
    }
    
    //经纬度->address
    private func outPutAddress(location:CLLocationCoordinate2D){
        // 初始化反地址编码选项（数据模型）
        let option = BMKReverseGeoCodeOption()
        // 将数据传到反地址编码模型
        option.reverseGeoPoint = location
        // 调用反地址编码方法，让其在代理方法中输出
        self.geoCode.reverseGeoCode(option)
    }
    
    /************************************/
    //地理编码代理
    /************************************/
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error.rawValue == BMK_SEARCH_NO_ERROR.rawValue{
            self.mapView.setCenterCoordinate(result.location, animated: false)
        }else{
            GShowAlertMessage("地理编码失败！")
        }
    }
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error.rawValue == BMK_SEARCH_NO_ERROR.rawValue{
            let address = result.address
            self.bottomView.hidden = false
            self.selectAddress = address
            self.addressLabel.text = "服务地址："+self.selectAddress
        }else{
            GShowAlertMessage("反地理编码失败！")
        }
    }
    /************************************/
    //地图代理
    /************************************/
    func mapView(mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        self.outPutAddress(mapPoi.pt)
    }
    
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        self.outPutAddress(coordinate)
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKindOfClass(BMKPointAnnotation){
            let annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        self.bottomView.hidden = false
        self.selectAddress = view.annotation.subtitle!()
        self.addressLabel.text = "服务地址："+self.selectAddress
    }
    /************************************/
    //检索代理
    /************************************/
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if errorCode.rawValue == BMK_SEARCH_NO_ERROR.rawValue{
            
            if poiResult == nil{
                GShowAlertMessage("没有搜索到符合的结果，请输入更为详细的关键字搜索！")
            }else{
                if poiResult.poiInfoList == nil || poiResult.poiInfoList.count == 0{
                    GShowAlertMessage("没有搜索到符合的结果，请输入更为详细的关键字搜索！")
                    return
                }
                for item in poiResult.poiInfoList{
                    let annotation = BMKPointAnnotation()
                    let poiInfo = item as! BMKPoiInfo
                    annotation.coordinate = poiInfo.pt
                    annotation.title = poiInfo.name
                    annotation.subtitle = poiInfo.address
                    self.annotations.append(annotation)
                    self.mapView.addAnnotation(annotation)
                }
                
                let searchResultVC = SearchResultViewController()
                searchResultVC.tableData = poiResult.poiInfoList as! [BMKPoiInfo]
                searchResultVC.selectBlock = {(selectPoi:BMKPoiInfo)->() in
                    self.mapView.setCenterCoordinate(selectPoi.pt, animated: true)
                    self.bottomView.hidden = false
                    self.selectAddress = selectPoi.address
                    self.addressLabel.text = "服务地址："+self.selectAddress
                }
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
        }
    }
    
    @IBAction func actionAddressCancel(sender: AnyObject) {
        self.bottomView.hidden = true
    }
    @IBAction func actionAddressOk(sender: AnyObject) {
        if self.selectBlock != nil{
            self.selectBlock!(self.selectAddress)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actionSearch(sender: AnyObject) {
        if self.mapView.zoomLevel != 18{
            self.mapView.zoomLevel = 18
        }
        self.inputSearchTextField.resignFirstResponder()
        let key = self.inputSearchTextField.text
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll(keepCapacity: true)
        if key!.isEmpty{
            
        }else{
            self.poiSearch(key!)
        }
    }
}
