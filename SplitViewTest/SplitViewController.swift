//
//  SplitViewController.swift
//  SplitViewTest
//
//  Created by Lai Evan on 10/3/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController, ContentViewControllerDelegate, LeftMenuViewControllerDelegate {
    
    fileprivate var left: UINavigationController!;
    
    fileprivate var right: UINavigationController!;
    
    @IBOutlet var leadingToMenuLeftConstraint: NSLayoutConstraint!;
    
    @IBOutlet var leadingToMenuRightConstraint: NSLayoutConstraint!;
    
    fileprivate var isClosed: Bool = false

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LeftMenu" {
            
            let navigation = segue.destination as! UINavigationController
            
            let leftMenu = navigation.viewControllers[0] as! LeftMenuViewController
            
            leftMenu.delegate = self
            
            self.left = navigation
            
            
        }
        else if segue.identifier == "ContentView" {
            
            let navigation = segue.destination as! UINavigationController
            
            let contentView = navigation.viewControllers[0] as! ContentViewController
            
            contentView.delegate = self
            
            self.right = navigation

        }
        
    }
    
    // MARK: ContentViewControllerDelegate
    
    func contentViewDidTapMenu(_ sender: ContentViewController) {
        
        self.isClosed = !self.isClosed
        
        UIView.animate(withDuration: 0.5, animations: {
            
            if self.isClosed == true {
                
                self.leadingToMenuLeftConstraint.priority = 800
                
                self.leadingToMenuRightConstraint.priority = 850
                
            }
            else {
                
                self.leadingToMenuLeftConstraint.priority = 850
                
                self.leadingToMenuRightConstraint.priority = 800
                
            }
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
        }
        
    }
    
    // MARK: LeftMenuViewControllerDelegate

    func leftMenuViewDidTapAtIndexPath(_ sender: LeftMenuViewController, indexPath: IndexPath) {
   
        
        if indexPath.row == 0 {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "A") as! ContentViewController
            
            controller.delegate = self
            
            self.right.setViewControllers([controller], animated: false)
            
        }
        else if indexPath.row == 1 {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "B")  as! ContentViewBController

            controller.delegate = self

            self.right.setViewControllers([controller], animated: false)

        }
        
    }

}
