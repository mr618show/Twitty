//
//  ComposeViewController.swift
//  Tweeter
//
//  Created by Rui Mao on 4/16/17.
//  Copyright © 2017 Rui Mao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var thumImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.nameLabel.text = User.currentUser?.name as String?
        thumImageView.setImageWith(User.currentUser!.profileUrl as! URL)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}