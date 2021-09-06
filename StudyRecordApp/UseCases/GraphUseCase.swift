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
    
    var graphs: [Graph] {
        repository.readAll()
    }
    
}
