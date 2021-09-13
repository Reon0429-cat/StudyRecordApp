//
//  LocalizeKey.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/13.
//

import Foundation

enum LocalizeKey: String {
    case languageCode
    case theEmailAddressFormatContainsAnError
    case pleaseEnterThePasswordWithAtLeast6Characters
    case thePasswordIsIncorrect
    case thisEmailAddressIsNotRegistered
    case thisEmailAddressIsAlreadyRegistered
    case loginFailed
    case anUnknownErrorHasOccurred
    
    case record
    case graph
    case goal
    case setting
    
    case natural
    case pop
    case elegant
    case season
    case japan
    case overseas
    case service
    case adultColor
    case gorgeous
    case art
    case intelligence
    case beautiful
    case tradition
    case moist
    case relax
    case feminine
    case organic
    case craft
    case living
    case botanical
    case foreignCountries
    case journey
    case mysterious
    case colorful
    case retro
    case kids
    case girly
    case active
    case catchu
    case happy
    case spring
    case summer
    case autumn
    case winter
    case business
    case digital
    case shop
    
    case save
    case close
    case edit
    case completion
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue,
                                 comment: "")
    }
}
