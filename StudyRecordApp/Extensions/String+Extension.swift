//
//  String+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/13.
//

import Foundation

extension String {
    
    func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}
