//
//  ViewController.swift
//  SplitViewTest
//
//  Created by Lai Evan on 10/3/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import UIKit

protocol ContentViewControllerDelegate {
    
    func contentViewDidTapMenu(_ sender: ContentViewController)
    
}

class ContentViewController: UIViewController {
    
    var delegate: ContentViewControllerDelegate?

    @IBAction func didTapMenu(_ sender: Any) {
        
        self.delegate?.contentViewDidTapMenu(self)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }

}

