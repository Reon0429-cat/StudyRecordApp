//
//  MailSender.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/18.
//

import Foundation

struct MailSender {
    
    func send(emailText: String,
              passwordText: String,
              titleText: String,
              bodyText: String,
              handler: @escaping ResultHandler<Any?>) {
        let session = MCOSMTPSession()
        session.hostname = "smtp.gmail.com"
        session.username = emailText
        session.password = passwordText
        session.port = 465
        session.isCheckCertificateEnabled = false
        session.authType = MCOAuthType.saslPlain
        session.connectionType = .TLS
        session.connectionLogger = { connectionID, type, data in
            guard let data = data else { return }
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print("DEBUG_PRINT: ", string)
            }
        }
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "大西玲音", mailbox: emailText)!]
        builder.header.from = MCOAddress(displayName: "お客様", mailbox: emailText)
        builder.header.subject = titleText
        builder.htmlBody = bodyText
        let sendOperation = session.sendOperation(with: builder.data()!)
        sendOperation?.start { error in
            if let error = error {
                handler(.failure(error.localizedDescription))
                return
            }
            handler(.success(nil))
        }
    }
    
}
