//
//  CalTodoItem.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/31.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

struct CalTodoItem: Codable {
    var todoKey = "GameDevLog"
    var todoValue: String? = nil
    var finished = false
}
