//
//  DetailVC.swift
//  LifeSpeak_Youtube
//
//  Created by Gokula K Narasimhan on 8/29/18.
//  Copyright © 2018 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension DetailVC{
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
