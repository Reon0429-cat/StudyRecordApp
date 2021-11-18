//
//  RealmGraphDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation

final class RealmGraphDataStore {

    func create(graph: GraphRealm) {
        RealmManager().create(object: graph)
    }

    func readAll() -> [GraphRealm] {
        return RealmManager().readAll(type: GraphRealm.self,
                                      byKeyPath: nil)
    }

    func update(graph: GraphRealm) {
        RealmManager().update(object: graph)
    }

}
