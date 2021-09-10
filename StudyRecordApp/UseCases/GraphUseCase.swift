//
//  GraphUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation

final class GraphUseCase {
    
    private let repository: GraphRepositoryProtocol
    init(repository: GraphRepositoryProtocol) {
        self.repository = repository
    }
    
    var graph: Graph {
        if repository.readAll().isEmpty {
            let graph = Graph(selectedType: .line,
                              line: Line(isSmooth: false,
                                         isFilled: false,
                                         withDots: true),
                              bar: Bar(width: 20),
                              dot: Dot(isSquare: false))
            repository.create(graph: graph)
            return graph
        }
        return repository.read(at: 0)
    }
    
    func update(graph: Graph) {
        repository.update(graph: graph, at: 0)
    }
    
}
