//
//  OZVPNHandler.swift
//  LibOpenFortiVPN-iOS_Example
//
//  Created by Henry Kim on 2021/06/06.
//  Copyright © 2021 neoroman. All rights reserved.
//

import Foundation
import NetworkExtension
import KeychainAccess

class OZVPN {
    
    let vpnManager = NEVPNManager.shared();
    let keychain = Keychain(accessGroup: "3YPFANSDXN.org.cocoapods.demo.LibOpenFortiVPN-iOS-Example")
    
    private var vpnLoadHandler: (Error?) -> Void { return  
        { (error:Error?) in
            if ((error) != nil) {
                print("Could not load VPN Configurations")
                return;
            }
            let p = NEVPNProtocolIPSec()
            p.username = "MY_ID"
            p.serverAddress = "SERVER_ADDR:PORT"
            
            try? self.keychain.set("MY_PASSWORD", key: "MY_PASSWORD")
            try? self.keychain.set("db117aaf1b25cd18c0fb8165d3412a3182f2f0707db653a683189cd7dc3ef1e1", key: "MY_SHARED_KEY")
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
            p.sharedSecretReference = try? self.keychain.get("MY_SHARED_KEY")?.data(using: .utf8)
            p.useExtendedAuthentication = false
            p.passwordReference = try? self.keychain.get("MY_PASSWORD")?.data(using: .utf8)
            p.disconnectOnSleep = false
            if #available(iOS 14.2, *) {
                p.enforceRoutes = true
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 14.0, *) {
                p.includeAllNetworks = true
            } else {
                // Fallback on earlier versions
            }
            self.vpnManager.protocolConfiguration = p
            self.vpnManager.localizedDescription = "UA-FortiVPN"
            self.vpnManager.isEnabled = true
            self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        } 
    }
    
    private var vpnSaveHandler: (Error?) -> Void { return  
        { (error:Error?) in
            if (error != nil) {
                print("Could not save VPN Configurations")
                return
            } else {
                do {
                    let username = "MY_ID"
                    let password = (try? self.keychain.get("MY_PASSWORD"))!
                    try self.vpnManager.connection.startVPNTunnel(options: 
                                                                    [NEVPNConnectionStartOptionUsername: NSString(string: username), 
                                                                     NEVPNConnectionStartOptionPassword: NSString(string: password)])
                } catch let error {
                    print("Error starting VPN Connection \(error.localizedDescription)");
                }
            }
        }
    }
    
    public func connectVPN() {  
        //For no known reason the process of saving/loading the VPN configurations fails.On the 2nd time it works
        self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
//        do {
//            try self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
//        } catch let error {
//            print("Could not start VPN Connection: \(error.localizedDescription)" )
//        }
    }
    
    public func disconnectVPN() ->Void {  
        vpnManager.connection.stopVPNTunnel()
    }
}
