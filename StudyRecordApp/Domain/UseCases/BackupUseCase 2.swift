//
//  BackupUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/21.
//

import Foundation

final class BackupUseCase {
    
    private let repository: BackupRepository
    init(repository: BackupRepository) {
        self.repository = repository
    }
    
    func backup(documentURL: URL) {
        repository.backup(documentURL: documentURL)
    }
    
    func getRealmFileURL() -> URL? {
        return repository.getRealmFileURL()
    }
    
    func updateRealm(fileURL: URL) {
        repository.updateRealm(fileURL: fileURL)
    }
    
}
