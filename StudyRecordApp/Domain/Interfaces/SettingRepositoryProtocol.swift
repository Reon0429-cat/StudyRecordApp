//
//  SettingRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation

protocol SettingRepositoryProtocol {
    func create(setting: Setting)
    func read(at index: Int) -> Setting
    func readAll() -> [Setting]
    func update(setting: Setting)
    func delete(setting: Setting)
}
