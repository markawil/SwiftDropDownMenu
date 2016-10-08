//
//  ViewController.swift
//  DropDownSwift
//
//  Created by Mark Wilkinson on 6/27/16.
//  Copyright © 2016 Mark Wilkinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let orangeSegueId = "orangeSegue"
    let redSegueId = "redSegue"
    
    lazy var viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("viewController1")
    lazy var viewController2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("viewController2")
    lazy var viewController3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("viewController3")
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var view_HeightConstraint: NSLayoutConstraint!
    
    @IBAction func button_View1_Tapped(sender: AnyObject) {
        activeViewController = viewController1
        hideDropDownMenu()
    }
    
    @IBAction func button_View2_Tapped(sender: AnyObject) {
        activeViewController = viewController2
        hideDropDownMenu()
    }
    
    @IBAction func button_View3_Tapped(sender: AnyObject) {
        activeViewController = viewController3
        hideDropDownMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "DropDown Example"
        self.view_HeightConstraint.constant = 0
        
        let menuButton = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: #selector(ViewController.menuButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = menuButton
        self.activeViewController = viewController1
    }
    
    func menuButtonTapped(sender: AnyObject) {
        
        if view_HeightConstraint.constant == 0 {
            showDropDownMenu()
        } else {
            hideDropDownMenu()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func hideDropDownMenu() {
        UIView.animateWithDuration(0.3) { 
            self.view_HeightConstraint.constant = 0
            self.dropDownView.layoutIfNeeded()
        }
    }
    
    private func showDropDownMenu() {
        UIView.animateWithDuration(0.3) { 
            self.view_HeightConstraint.constant = 128
            self.dropDownView.layoutIfNeeded()
        }
    }
    
    private func removeInactiveViewController(vc: UIViewController?) {
        if isViewLoaded() {
            if let validVC = vc {
                validVC.willMoveToParentViewController(nil)
                validVC.view.removeFromSuperview()
                validVC.removeFromParentViewController()
            }
        }
    }
    
    private func updateActiveViewController() {
        if isViewLoaded() {
            if let validVC = activeViewController {
                addChildViewController(validVC)
                validVC.view.frame = containerView.bounds
                containerView.addSubview(validVC.view)
                validVC.didMoveToParentViewController(self)
            }
        }
    }
}

