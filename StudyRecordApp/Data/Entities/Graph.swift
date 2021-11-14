//
//  Graph.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation

// 共通の型
struct Graph: Equatable {
    var selectedType: SelectedGraphType
    var line: Line
    var bar: Bar
    var dot: Dot
    var identifier: String
}

struct Line: Equatable {
    var isSmooth: Bool
    var isFilled: Bool
    var withDots: Bool
}

struct Bar: Equatable {
    let width: Float
}

struct Dot: Equatable {
    let isSquare: Bool
}
