//
//  Compatible.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/08.
//

import Foundation

protocol Compatible {
    associatedtype CompatibleType
    var ex: CompatibleType { get }
}

extension Compatible {
    var ex: Base<Self> {
        return Base(self)
    }
}

final class Base<T> {
    private let base: T
    init(_ base: T) {
        self.base = base
    }
}
