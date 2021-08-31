//
//  GoalUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

final class GoalUseCase {
    
    private let repository: GoalRepositoryProtocol
    init(repository: GoalRepositoryProtocol) {
        self.repository = repository
    }
    
    var goals: [Goal] {
        repository.readAll()
    }
    
}
