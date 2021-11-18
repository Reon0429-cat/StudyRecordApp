//
//  BackupRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation

protocol BackupRepositoryProtocol {
    func backup(documentURL: URL)
    func getRealmFileURL() -> URL?
    func updateRealm(fileURL: URL)
}
