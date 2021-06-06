//
//  Record.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import Foundation

struct Record {
    var title: String
    var time: Time
    var expanded: Bool
    var memo: String
    static let data = [Record(title: "プログラミングを勉強する",
                              time: Time(today: 100, total: 300),
                              expanded: false,
                              memo: ""),
                       Record(title: "AtCoderの問題を解く",
                              time: Time(today: 30, total: 400),
                              expanded: false,
                              memo: ""),
                       Record(title: "数学（三角関数の2倍角の公式を暗記する)",
                              time: Time(today: 40, total: 200),
                              expanded: false,
                              memo: ""),
                       Record(title: "AtCoderの問題を解く",
                              time: Time(today: 30, total: 400),
                              expanded: false,
                              memo: ""),
                       Record(title: "数学（三角関数の2倍角の公式を暗記する)",
                              time: Time(today: 40, total: 200),
                              expanded: false,
                              memo: ""),
                       Record(title: "AtCoderの問題を解く",
                              time: Time(today: 30, total: 400),
                              expanded: false,
                              memo: ""),
                       Record(title: "数学（三角関数の2倍角の公式を暗記する)",
                              time: Time(today: 40, total: 200),
                              expanded: false,
                              memo: ""),
                       Record(title: "AtCoderの問題を解く",
                              time: Time(today: 30, total: 400),
                              expanded: false,
                              memo: ""),
                       Record(title: "数学（三角関数の2倍角の公式を暗記する)",
                              time: Time(today: 40, total: 200),
                              expanded: false,
                              memo: ""),
                       Record(title: "AtCoderの問題を解く",
                              time: Time(today: 30, total: 400),
                              expanded: false,
                              memo: ""),
                       Record(title: "数学（三角関数の2倍角の公式を暗記する)",
                              time: Time(today: 40, total: 200),
                              expanded: false,
                              memo: ""),
    ]
}

struct Time {
    var today: Int
    var total: Int
}
