//
//  DynamicCell1.swift
//  DynamicUI
//
//  Created by Admin on 05/02/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DynamicCell1: UITableViewCell {

    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
