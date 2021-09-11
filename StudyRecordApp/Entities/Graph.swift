//
//  Graph.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation

// 共通の型
struct Graph {
    var selectedType: SelectedGraphType
    var line: Line
    var bar: Bar
    var dot: Dot
}

struct Line {
    var isSmooth: Bool
    var isFilled: Bool
    var withDots: Bool
}

struct Bar {
    let width: Float
}

struct Dot {
    let isSquare: Bool
}

