//
//  GraphRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation

protocol GraphRepositoryProtocol {
    func create(graph: Graph)
    func read(at index: Int) -> Graph
    func readAll() -> [Graph]
    func update(graph: Graph, at index: Int)
    func delete(at index: Int)
}

final class GraphRepository: GraphRepositoryProtocol {
    
    private var dataStore: GraphDataStoreProtocol
    init(dataStore: GraphDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(graph: Graph) {
        dataStore.create(graph: graph)
    }
    
    func read(at index: Int) -> Graph {
        return dataStore.read(at: index)
    }
    
    func readAll() -> [Graph] {
        return dataStore.readAll()
    }
    
    func update(graph: Graph, at index: Int) {
        dataStore.update(graph: graph, at: index)
    }
    
    func delete(at index: Int) {
        dataStore.delete(at: index)
    }
    
}
