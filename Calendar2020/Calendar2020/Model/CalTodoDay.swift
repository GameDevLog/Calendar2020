//
//  CalTodoDay.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/31.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Foundation

struct CalTodoDay: Codable {
    var gameName: String?
    var gameImgae: String?
    var calTodoSection = [CalTodoSection]()
}
