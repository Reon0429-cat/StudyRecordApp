//
//  RealmGraphDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import RealmSwift

protocol GraphDataStoreProtocol {
    func create(graph: GraphRealm)
    func readAll() -> [GraphRealm]
    func update(graph: GraphRealm)
}

final class RealmGraphDataStore: GraphDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<GraphRealm> {
        realm.objects(GraphRealm.self)
    }
    
    func create(graph: GraphRealm) {
        try! realm.write {
            realm.add(graph)
        }
    }
    
    func readAll() -> [GraphRealm] {
        return objects.map { $0 }
    }
    
    func update(graph: GraphRealm) {
        let object = realm.object(ofType: GraphRealm.self,
                                  forPrimaryKey: graph.identifier) ?? GraphRealm()
        try! realm.write {
            object.selectedType = graph.selectedType
            object.line = graph.line
            object.bar = graph.bar
            object.dot = graph.dot
        }
    }
    
}

