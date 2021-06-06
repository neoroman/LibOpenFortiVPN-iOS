//
//  OZViewController.swift
//  LibOpenFortiVPN-iOS
//
//  Created by Henry Kim on 2021/06/06.
//

import UIKit
import LibOpenFortiVPN_iOS

class OZViewController: UIViewController, OpenFortiVPNListener {
    
    @IBOutlet weak var launchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vpn = OZVPN.init()
        vpn.connectVPN()
        
        OpenFortiVPN.shared().setOpenFortiVPNListener(self)
        OpenFortiVPN.shared().run()
    }

}

