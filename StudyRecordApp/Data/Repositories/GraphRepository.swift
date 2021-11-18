//
//  GraphRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation
import RealmSwift

final class GraphRepository: GraphRepositoryProtocol {

    private let dataStore = RealmGraphDataStore()

    func create(graph: Graph) {
        let graphRealm = GraphRealm(graph: graph)
        dataStore.create(graph: graphRealm)
    }

    func readAll() -> [Graph] {
        let graphs = dataStore.readAll().map { Graph(graph: $0) }
        return graphs
    }

    func update(graph: Graph) {
        let graphRealm = GraphRealm(graph: graph)
        dataStore.update(graph: graphRealm)
    }

}

private extension GraphRealm {

    convenience init(graph: Graph) {
        self.init()
        let graph = Graph(selectedType: graph.selectedType,
                          line: graph.line,
                          bar: graph.bar,
                          dot: graph.dot,
                          identifier: graph.identifier)
        self.selectedType = graph.selectedType
        self.line = LineRealm(graph: graph)
        self.bar = BarRealm(graph: graph)
        self.dot = DotRealm(graph: graph)
        self.identifier = graph.identifier
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
                  dot: Dot(graph: graph),
                  identifier: graph.identifier)
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
