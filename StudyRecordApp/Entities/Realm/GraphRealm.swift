//
//  GraphRealm.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

// Realmに依存した型
final class GraphRealm: Object {
    @objc private dynamic var selectedTypeRawValue = 0
    var selectedType: SelectedGraphType {
        get {
            return SelectedGraphType(rawValue: selectedTypeRawValue) ?? .line
        }
        set {
            selectedTypeRawValue = newValue.rawValue
        }
    }
    @objc dynamic var line: LineRealm? = LineRealm()
    @objc dynamic var bar: BarRealm? = BarRealm()
    @objc dynamic var dot: DotRealm? = DotRealm()
}

final class LineRealm: Object {
    @objc dynamic var isSmooth: Bool = false
    @objc dynamic var isFilled: Bool = false
    @objc dynamic var withDots: Bool = true
}

final class BarRealm: Object {
    @objc dynamic var width: Float = 20
}

final class DotRealm: Object {
    @objc dynamic var isSquare: Bool = false
}

