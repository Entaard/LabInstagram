//
//  DetailsViewController.swift
//  Instagram
//
//  Created by Enta'ard on 10/12/16.
//  Copyright © 2016 Enta'ard. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    var url:String!
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.setImageWith(URL(string:url)!)
        // Do any additional setup after loading the view.
    }
}
