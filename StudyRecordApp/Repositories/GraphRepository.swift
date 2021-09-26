//
//  GraphRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/06.
//

import Foundation

protocol GraphRepositoryProtocol {
    func create(graph: Graph)
    func readAll() -> [Graph]
    func update(graph: Graph)
}

final class GraphRepository: GraphRepositoryProtocol {
    
    private var dataStore: GraphDataStoreProtocol
    init(dataStore: GraphDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(graph: Graph) {
        dataStore.create(graph: graph)
    }
    
    func readAll() -> [Graph] {
        return dataStore.readAll() 
    }
    
    func update(graph: Graph) {
        dataStore.update(graph: graph)
    }
    
}
