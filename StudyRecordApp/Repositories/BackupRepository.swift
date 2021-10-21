//
//  BackupRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/21.
//

import Foundation

protocol BackupRepositoryProtocol {
    func backup(documentURL: URL)
    func getRealmFileURL() -> URL?
    func updateRealm(fileURL: URL)
}

final class BackupRepository: BackupRepositoryProtocol {
    
    func backup(documentURL: URL) {
        RealmManager().backup(documentURL: documentURL)
    }
    
    func getRealmFileURL() -> URL? {
        return RealmManager().getRealmFileURL()
    }
    
    func updateRealm(fileURL: URL) {
        RealmManager().updateRealm(fileURL: fileURL)
    }
    
}
