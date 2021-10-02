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
    case today
    case recordedDataIsNotRegistered
    case Register
    case Line
    case Bar
    case Dot
    case straight
    case smooth
    case notFill
    case fill
    case addNotDot
    case addDot
    case circleDot
    case squareDot
    
    case themeColor
    case darkMode
    case passcode
    case pushNotification
    case multilingual
    case howToUseApp
    case evaluationApp
    case shareApp
    case reports
    case backup
    case privacyPolicy
    case logout
    
    case areYouSureYouWantToLogOut
    
    case `default`
    case custom
    case recommendation
    case yes
    case no
    case doYouWantTheDefaultColor
    
    case main
    case sub
    case accent
    case tile
    case slider
    
    case certification
    case create
    case change
    
    case oneTimeLeft
    case twoTimeLeft
    case pleaseEnterANewPasscode
    case pleaseEnterYourCurrentPasscode
    case changePasscode
    
    case mandatory
    case unselected
    
    case hour
    case minute
    case total
    case shortHour
    case shortMinute
    
    case thereIsNoData
    case graphDataIsNotRegistered
    
    case darkModeSettingApp
    case darkModeSettingAuto
    
    case uncategorized
    
    case fixed
    
    case year
    case month
    case day
    
    case turnOnFaceID
    case turnOnTouchID
    case useAuthenticationToUnlock
    case pleaseAllowBiometrics
    case turnOnBiometrics
    
    case unknownError
    
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue,
                                 comment: "")
    }
}

enum Month: Int {
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
    
    var text: String {
        switch self {
            case .january:
                return LocalizeKey.january.localizedString()
            case .february:
                return LocalizeKey.february.localizedString()
            case .march:
                return LocalizeKey.march.localizedString()
            case .april:
                return LocalizeKey.april.localizedString()
            case .may:
                return LocalizeKey.may.localizedString()
            case .june:
                return LocalizeKey.june.localizedString()
            case .july:
                return LocalizeKey.july.localizedString()
            case .august:
                return LocalizeKey.august.localizedString()
            case .september:
                return LocalizeKey.september.localizedString()
            case .october:
                return LocalizeKey.october.localizedString()
            case .november:
                return LocalizeKey.november.localizedString()
            case .december:
                return LocalizeKey.december.localizedString()
        }
    }
}

