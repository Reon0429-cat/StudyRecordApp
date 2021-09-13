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
    case Edit
    case completion
    case login
    case signUp
    case mailAddress
    case password
    case passwordConfirmation
    case passwordForgot
    case here
    case communicationEnvironmentIsNotGood
    case passwordsDoNotMatch
    case send
    case passwordForgotDetail
    case passwordForgotTitle
    case doYouReallyWantToDeleteThis
    case delete
    case doYouWantToCloseWithoutSaving
    case title
    case Title
    case add
    case Add
    case memo
    case Memo
    case doYouWantToDiscardYourEdits
    case discard
    case recordTime
    case moreThan24Hours
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    case graphColor
    case decision
    case doYouWantToCloseTheNoteWithoutSaving
    case Sort
    case category
    case Category
    case simple
    case Priority
    case dueDate
    case createdDate
    case photo
    case takeAPhoto
    case selectFromLibrary
    case deletePhoto
    
    
    
    
    
    
    
    
    
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue,
                                 comment: "")
    }
}

enum Month: Int {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}
