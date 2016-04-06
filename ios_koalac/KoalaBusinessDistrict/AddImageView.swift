//
//  AddImageView.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/28.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class AddImageView: UIView {
    @IBOutlet weak var addImage: UIImageView!
    
    private var isUrl:Bool = false
    private var index:Int = 0
    
    var deleteBlock:((isUrl:Bool, index:Int)->())?
    
    class func instantiateFromNib() -> AddImageView {
        let view = UINib(nibName: "AddImageView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! AddImageView
        
        return view
    }

    func initDataWithUrl(url:String, atIndex:Int){
        isUrl = true
        index = atIndex
        
        self.addImage.setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "PlaceHolder"))
    }
    
    func initDataWithImage(image:UIImage, atIndex:Int){
        isUrl = false
        index = atIndex
        
        self.addImage.image = image
    }
    
    
    @IBAction func actionDelete(sender: AnyObject) {
        if self.deleteBlock != nil{
            self.deleteBlock!(isUrl: self.isUrl, index: self.index)
        }
    }
}
