//
//  Alarm.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/12.
//

import Foundation

struct Alarm {
    var time: String
    var isOn: Bool
    static let data = [Alarm(time: "2:30", isOn: true),
                       Alarm(time: "4:10", isOn: true),
                       Alarm(time: "5:20", isOn: true),
                       Alarm(time: "2:50", isOn: true),
                       Alarm(time: "1:20", isOn: true),
    ]
}

