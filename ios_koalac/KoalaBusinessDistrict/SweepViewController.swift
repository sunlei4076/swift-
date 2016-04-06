//
//  SweepViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/7.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SweepViewController: UIViewController,ZBarReaderViewDelegate {

    @IBOutlet weak var bottomBgView: UIImageView!
    @IBOutlet weak var sweepAreaView: UIImageView!
    
    private let sweepLineImage:UIImageView = UIImageView()
    private var timer:NSTimer?
    private var reader:ZBarReaderView = ZBarReaderView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.stopTimer()
        if self.reader.torchMode == 1{
            self.reader.torchMode = 0
        }
        self.reader.stop()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = self.sweepLineImage.frame
        frame.origin.x = self.sweepAreaView.frame.origin.x
        frame.origin.y = self.sweepAreaView.frame.origin.y
        self.sweepLineImage.frame = frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func test(){
        let test = ZBarReaderController()
        let curtscanner = test.scanner;
        test.showsZBarControls = false;
        curtscanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        self.presentViewController(test, animated: true, completion: nil)
    }
    
    private func initControl(){
        self.title = "扫描"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let image = UIImage(named: "Sweep_BottomBlack")
        self.bottomBgView.image = image?.stretchableImageWithLeftCapWidth(10, topCapHeight: 10)
        if let lineImage = UIImage(named: "Sweep_Line"){
            self.sweepLineImage.image = lineImage
                self.sweepLineImage.frame = CGRectMake(0, 0, lineImage.size.width, lineImage.size.height)
            self.view.addSubview(self.sweepLineImage)
        }
        
        self.reader.readerDelegate = self
        self.reader.tracksSymbols = false
        //关闭闪光灯
        self.reader.torchMode = 0
        self.reader.frame = self.view.bounds
        self.view.insertSubview(reader, atIndex: 0)
        self.reader.start()
        
        self.createTimer()
    }

    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //二维码的横线移动
    func moveUpAddDownLine(){
        var frame = self.sweepLineImage.frame
        if frame.origin.y < self.sweepAreaView.center.y{
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                frame.origin.y = CGRectGetMaxY(self.sweepAreaView.frame)
                self.sweepLineImage.frame = frame
            })
        }else{
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                frame.origin.y = CGRectGetMinY(self.sweepAreaView.frame)
                self.sweepLineImage.frame = frame
            })
        }
    }
    
    private func createTimer(){
        //创建一个时间计数
        if self.timer == nil{
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("moveUpAddDownLine"), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer(){
        if self.timer != nil && self.timer!.valid == true{
            timer!.invalidate()
        }
    }
    
    func readerView(readerView: ZBarReaderView!, didReadSymbols symbols: ZBarSymbolSet!, fromImage image: UIImage!) {

        pprLog("111")
//        let symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet)
//        let symbolStr = String(UTF8String: zbar_symbol_get_data(symbol))
    }
    
    func readerView(readerView: ZBarReaderView!, didStopWithError error: NSError!) {
        //失败
    }
    
    @IBAction func openLight(sender: AnyObject) {
       
        if self.reader.torchMode == 0{
            self.reader.torchMode = 1
        }else{
            self.reader.torchMode = 0
        }
    }
}
