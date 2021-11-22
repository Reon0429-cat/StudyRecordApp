//
//  Constant.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/18.
//

import Foundation

struct Constant {

    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    static let privacyPolicyJaWebPage = "https://Reon0429-cat.github.io/Reon0429.github.io/index.html"
    static let privacyPolicyEnWebPage = "https://Reon0429-cat.github.io/Reon0429.github.io/index_en.html"
    static let appShareURLString = "https://itunes.apple.com/jp/app/id1596528644?mt=8"
    static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

}
