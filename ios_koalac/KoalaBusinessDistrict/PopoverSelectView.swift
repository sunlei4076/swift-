//
//  PopoverSelectView.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/10.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class PopoverSelectView: UIView,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var titleBGView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonBGView: UIView!
    
    private var tableData:[String] = []
    private var selectIndex:Int = 0
    private var selectBlock:((Int,String)->())?
    private func initControl(){
        self.titleBGView.backgroundColor = GlobalStyleFontColor
        self.buttonBGView.backgroundColor = UIColor.blackColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.titleLabel.font = GGetBigCustomFont()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instantiateFromNib() -> PopoverSelectView {
        let view = UINib(nibName: "PopoverSelectView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! PopoverSelectView
        
        return view
    }
    
    func show(inView:UIView, title:String, data:[String], defaultSelect:Int, selectedDone:(selectIndex:Int,selectString:String)->()){
        self.initControl()
        self.titleLabel.text = title
        self.selectBlock = selectedDone
        self.selectIndex = defaultSelect
        self.tableData = data
        self.tableView.reloadData()
        self.frame = CGRectMake(0, 0, inView.bounds.size.width, inView.bounds.size.height)
        inView.addSubview(self)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if cell == nil{
            cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.textLabel?.font = GGetNormalCustomFont()
            cell?.textLabel?.numberOfLines = 2
        }
        
        let image:UIImage?
        if self.selectIndex == indexPath.row{
            image = UIImage(named: "TableCell_Selected")
        }else{
            image = UIImage(named: "TableCell_Unselected")
        }
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
        cell!.accessoryView = imageView
        cell!.textLabel!.text = self.tableData[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectIndex != indexPath.row{
            let oldSelectIndex = NSIndexPath(forRow: self.selectIndex, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(oldSelectIndex){
                let oldView = cell.accessoryView
                let oldImageView = oldView as! UIImageView
                oldImageView.image = UIImage(named: "TableCell_Unselected")
            }
            
            self.selectIndex = indexPath.row
            if let wantSelectCell = tableView.cellForRowAtIndexPath(indexPath){
                let newView = wantSelectCell.accessoryView
                let newImageView = newView as! UIImageView
                newImageView.image = UIImage(named: "TableCell_Selected")
            }
        }
    }
    @IBAction func actionCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
    @IBAction func actionOk(sender: AnyObject) {
        self.removeFromSuperview()
        if self.selectBlock != nil && self.selectIndex < self.tableData.count{
            self.selectBlock!(self.selectIndex,self.tableData[self.selectIndex])
        }
    }
}
