//
//  RealmGraphDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import RealmSwift

protocol GraphDataStoreProtocol {
    func create(graph: Graph)
    func read(at index: Int) -> Graph
    func readAll() -> [Graph]
    func update(graph: Graph, at index: Int)
    func delete(at index: Int)
}

final class RealmGraphDataStore: GraphDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<GraphRealm> {
        realm.objects(GraphRealm.self)
    }
    
    func create(graph: Graph) {
        let graphRealm = GraphRealm(graph: graph)
        try! realm.write {
            realm.add(graphRealm)
        }
    }
    
    func read(at index: Int) -> Graph {
        return Graph(graph: objects[index])
    }
    
    func readAll() -> [Graph] {
        return objects.map { Graph(graph: $0) }
    }
    
    func update(graph: Graph, at index: Int) {
        let object = objects[index]
        let graph = Graph(test: graph.test)
        try! realm.write {
            object.test = graph.test
        }
    }
    
    func delete(at index: Int) {
        let object = objects[index]
        try! realm.write {
            realm.delete(object)
        }
    }
    
}

private extension GraphRealm {
    
    convenience init(graph: Graph) {
        self.init()
        let graph = Graph(test: graph.test)
        self.test = graph.test
    }
    
}

private extension Graph {
    
    init(graph: GraphRealm) {
        let graph = Graph(test: graph.test)
        self.test = graph.test
    }
    
}
