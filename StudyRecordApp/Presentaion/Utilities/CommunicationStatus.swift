//
//  CommunicationStatus.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/28.
//

import Foundation
import Reachability

struct CommunicationStatus {
    
    func unstable() -> Bool {
        let reachability = try! Reachability()
        return reachability.connection == .unavailable
    }
    
}
