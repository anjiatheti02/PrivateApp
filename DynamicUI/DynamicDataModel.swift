//
//  DynamicDataModel.swift
//  DynamicUI
//
//  Created by Admin on 05/02/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct DynamicDataModel {
    
    var name: String?
    var type: String?
    var value: String?
    
    init(dict:[String:Any]) {
        name = dict["name"] as? String
        type = dict["type"] as? String
        value = ""
    }
}
