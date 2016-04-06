//
//  LoginAccountCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/1.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class LoginAccountCell: UITableViewCell {

   
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    var cellData:AccountInfo = AccountInfo(){
        didSet{
            self.headImageView.setImageWithURL(NSURL(string: self.cellData.headUrl)!, placeholderImage: UIImage(named: "PlaceHolder"))
            self.nameLabel.text = self.cellData.name
            if self.cellData.name == LoginInfoModel.sharedInstance.user_name{
                self.selectedIcon.hidden = false
            }else{
                self.selectedIcon.hidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func initControl(){
        self.nameLabel.font = GGetNormalCustomFont()
        self.selectedIcon.hidden = true
    }
    
    static func cellIdentifier()->String{
        return "LoginAccountCell"
    }
    
    static func cellHeight()->CGFloat{
        return 68.0
    }
}
