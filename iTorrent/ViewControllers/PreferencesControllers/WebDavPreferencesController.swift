//
//  PreferencesWebDavController.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 10.11.2019.
//  Copyright © 2019  XITRIX. All rights reserved.
//

import UIKit

class WebDavPreferencesController: StaticTableViewController {
    override var toolBarIsHidden: Bool? {
        true
    }

    override func initSections() {
        title = Localize.get("Settings.FTPHeader")

        var pass = [CellModelProtocol]()
        pass.append(TextFieldCell.Model(title: "Settings.FTP.WebDav.Username", placeholder: "Settings.FTP.WebDav.Username.Placeholder", defaultValue: { UserPreferences.webDavUsername }) { username in
            UserPreferences.webDavUsername = username
        })
        pass.append(TextFieldCell.Model(title: "Settings.FTP.WebDav.Password", placeholder: "Settings.FTP.WebDav.Password.Placeholder", defaultValue: { UserPreferences.webDavPassword }, isPassword: true) { password in
            UserPreferences.webDavPassword = password
        })
        data.append(Section(rowModels: pass, footer: "Settings.FTP.WebDav.PassText"))

        var web = [CellModelProtocol]()
        web.append(SwitchCell.Model(title: "Enable", defaultValue: { UserPreferences.webServerEnabled }) { switcher in
            UserPreferences.webServerEnabled = switcher.isOn
            if switcher.isOn {
                if UserPreferences.ftpKey {
                    Core.shared.startFileSharing()
                }
            } else {
                if Core.shared.webUploadServer.isRunning {
                    Core.shared.webUploadServer.stop()
                }
            }
            self.view.endEditing(true)
        })
        data.append(Section(rowModels: web, header: "Settings.FTP.WebDav.WebTitle", footer: "Settings.FTP.WebDav.WebText"))

        var webDav = [CellModelProtocol]()
        webDav.append(SwitchCell.Model(title: "Enable", defaultValue: { UserPreferences.webDavServerEnabled }) { switcher in
            UserPreferences.webDavServerEnabled = switcher.isOn
            if switcher.isOn {
                if UserPreferences.ftpKey {
                    Core.shared.startFileSharing()
                }
            } else {
                if Core.shared.webDAVServer.isRunning {
                    Core.shared.webDAVServer.stop()
                }
            }
            self.updateData()
        })
        webDav.append(TextFieldCell.Model(title: "Settings.FTP.WebDav.WebDavPort", placeholder: "81", defaultValue: { String(UserPreferences.webDavPort) }, keyboardType: .numberPad, hiddenCondition: { !UserPreferences.webDavServerEnabled }) { port in
            if let intPort = Int(port) {
                UserPreferences.webDavPort = intPort
            } else {
                UserPreferences.webDavPort = 81
            }
            self.updateData()
        })
        data.append(Section(rowModels: webDav, header: "Settings.FTP.WebDav.WebDavTitle", footerFunc: { () -> String in
            let addr = Core.shared.webDAVServer.serverURL?.absoluteString
            let res = addr != nil ? ": \(addr!)" : ""
            return "\(Localize.get("Settings.FTP.WebDav.WebDavText"))\(res)"
        }))
    }

    deinit {
        print("PreferencesWebDavController Deinit")
    }
}
