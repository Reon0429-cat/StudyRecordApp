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
        let graph = Graph(selectedType: graph.selectedType,
                          line: graph.line,
                          bar: graph.bar,
                          dot: graph.dot)
        try! realm.write {
            object.selectedType = graph.selectedType
            object.line = LineRealm(graph: graph)
            object.bar = BarRealm(graph: graph)
            object.dot = DotRealm(graph: graph)
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
        let graph = Graph(selectedType: graph.selectedType,
                          line: graph.line,
                          bar: graph.bar,
                          dot: graph.dot)
        self.selectedType = graph.selectedType
        self.line = LineRealm(graph: graph)
        self.bar = BarRealm(graph: graph)
        self.dot = DotRealm(graph: graph)
    }
    
}

private extension LineRealm {
    
    convenience init(graph: Graph) {
        self.init()
        self.isSmooth = graph.line.isSmooth
        self.isFilled = graph.line.isFilled
        self.withDots = graph.line.withDots
    }
    
}

private extension BarRealm {
    
    convenience init(graph: Graph) {
        self.init()
        self.width = graph.bar.width
    }
    
}

private extension DotRealm {
    
    convenience init(graph: Graph) {
        self.init()
        self.isSquare = graph.dot.isSquare
    }
    
}

private extension Graph {
    
    init(graph: GraphRealm) {
        self.init(selectedType: graph.selectedType,
                  line: Line(graph: graph),
                  bar: Bar(graph: graph),
                  dot: Dot(graph: graph))
    }
    
}

private extension Line {
    
    init(graph: GraphRealm) {
        self.init(isSmooth: graph.line?.isSmooth ?? false,
                  isFilled: graph.line?.isFilled ?? false,
                  withDots: graph.line?.withDots ?? true)
    }
    
}

private extension Bar {
    
    init(graph: GraphRealm) {
        self.init(width: graph.bar?.width ?? 20)
    }
    
}

private extension Dot {
    
    init(graph: GraphRealm) {
        self.init(isSquare: graph.dot?.isSquare ?? false)
    }
    
}
