//
//  CalendarViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/17.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController,LKCalendarViewDelegate,LKCalendarDayViewDelegate,LKCalendarMonthDelegate{

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var weeksLabelView: UIView!
    @IBOutlet weak var currDateLabel: UILabel!
    
    var calenderView:LKCalendarView?
    var lastSelectedDayView:LKCalendarDayView?
    var selectBlock:((NSDate)->())?
    
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
        
        self.title = "配送清单历史"
        self.view.backgroundColor = GlobalBgColor
        
        self.currDateLabel.font = GGetBigCustomFont()
        self.currDateLabel.textColor = GlobalStyleFontColor
        
        GSetFontInView(self.weeksLabelView, font: GGetCustomFontWithSize(GNormalFontSize - 2.0))
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        self.calenderView = LKCalendarView(frame: CGRectMake(0, 0, screenWidth, 235))
        self.calenderView?.setCurrentDateComponentsWithDate(NSDate())
        self.calenderView?.startLoadingView()
        self.calenderView!.delegate = self
        self.bottomView.addSubview(self.calenderView!)
    }

    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: NSDate())
        self.currDateLabel.text = "\(dateComponents.year)年\(dateComponents.month)月"
    }
    
    func calendarViewDidChangedMonth(sender: LKCalendarView!) {
        
        let year = sender.currentDateComponents.year
        let month = sender.currentDateComponents.month
        
        self.currDateLabel.text = "\(year)年\(month)月"
    }
    
    func calendarDayViewWillSelected(dayView: LKCalendarDayView!) {
        if self.lastSelectedDayView == dayView{
            return
        }else{
            if self.lastSelectedDayView != nil{
                self.lastSelectedDayView?.setCalDayShowWithType(CalendarDay_Normal)
            }
            self.lastSelectedDayView = dayView
        }
        if self.selectBlock != nil{
            self.selectBlock!(dayView.date)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func calendarMonth(month: LKCalendarMonth!, dayView: UIView!, date: NSDate!) {
        let calendarDayView = (dayView as! LKCalendarDayView)
        calendarDayView.date = date;
        let showType:CalendarDay_Type
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currDate = formatter.dateFromString(formatter .stringFromDate(NSDate()))
        
        let monthDiff = LKCalendarView.monthDiffWithDate(month.currentMonth, toDate: date)
        if monthDiff != 0{
            showType = CalendarDay_None
        }else{
            let comparResult = currDate!.compare(date)
            if comparResult == NSComparisonResult.OrderedAscending{
                showType = CalendarDay_Disable
            }else if comparResult == NSComparisonResult.OrderedSame{
                showType = CalendarDay_Selected
                self.lastSelectedDayView = calendarDayView
            }else{
                showType = CalendarDay_Normal
            }
        }
        calendarDayView.setCalDayShowWithType(showType)
    }
    
    @IBAction func actionTurnRight(sender: AnyObject) {
        self.calenderView!.turnRight()
    }
    @IBAction func actionTurnLeft(sender: AnyObject) {
        self.calenderView?.turnLeft()
    }
}
