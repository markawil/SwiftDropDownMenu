//
//  ViewController.swift
//  DropDownSwift
//
//  Created by Mark Wilkinson on 6/27/16.
//  Copyright © 2016 Mark Wilkinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let orangeSegueId = "orangeSegue"
    let redSegueId = "redSegue"
    
    lazy var viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewController1")
    lazy var viewController2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewController2")
    lazy var viewController3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewController3")
    
    fileprivate var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeftEdgeConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var containerView: UIView!
    var blurView: UIVisualEffectView?
    
    @IBAction func button_View1_Tapped(_ sender: AnyObject) {
        activeViewController = viewController1
        hideDropDownMenu()
    }
    
    @IBAction func button_View2_Tapped(_ sender: AnyObject) {
        activeViewController = viewController2
        hideDropDownMenu()
    }
    
    @IBAction func button_View3_Tapped(_ sender: AnyObject) {
        activeViewController = viewController3
        hideDropDownMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "SlideOut Menus Example"
        self.topLayoutConstraint.constant = -self.dropDownViewHeightConstraint.constant
        self.tableViewLeftEdgeConstraint.constant = -self.tableViewWidthConstraint.constant
        
        let menuButton = UIBarButtonItem(title: "Menu 2", style: .plain, target: self, action: #selector(ViewController.menuButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = menuButton
        
        let slideOutButton = UIBarButtonItem(title: "Menu 1", style: .plain, target: self, action: #selector(ViewController.slideOutTapped(_:)))
        self.navigationItem.leftBarButtonItem = slideOutButton
        
        self.activeViewController = viewController1
        
        self.blurView = UIVisualEffectView(frame: self.view.frame)
        self.blurView?.effect = nil
        self.view.addSubview(blurView!)
        self.view.bringSubview(toFront: self.tableView)
        self.view.bringSubview(toFront: self.dropDownView)
        
        let tableViewSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedTableView(_:)))
        tableViewSwipe.direction = .left
        self.tableView.addGestureRecognizer(tableViewSwipe)
        self.tableView.delaysContentTouches = true
        
        let dropDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedDropDownUp(_:)))
        dropDownSwipe.direction = .up
        self.dropDownView.addGestureRecognizer(dropDownSwipe)
    }
    
    @objc func swipedTableView(_ swipeGuesture: UISwipeGestureRecognizer) {
        
        self.hideTableView()
    }
    
    @objc func swipedDropDownUp(_ swipeGesture: UISwipeGestureRecognizer) {
        
        self.hideDropDownMenu()
    }
    
    @objc func menuButtonTapped(_ sender: AnyObject) {
        
        if topLayoutConstraint.constant == 0 {
            hideDropDownMenu()
        } else {
            showDropDownMenu()
        }
    }
    
    @objc func slideOutTapped(_ sender: AnyObject) {
        
        if tableViewLeftEdgeConstraint.constant == 0 {
            hideTableView()
        } else {
            showTableView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    fileprivate func hideDropDownMenu() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.topLayoutConstraint.constant = -self.dropDownViewHeightConstraint.constant
            self.dropDownView.alpha = 0.0
            self.blurView?.effect = nil
            self.view.layoutIfNeeded()
        }) 
    }
    
    fileprivate func showDropDownMenu() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.topLayoutConstraint.constant = 0
            self.dropDownView.alpha = 1.0
            self.blurView?.effect = UIBlurEffect(style: .dark)
            self.view.layoutIfNeeded()
        }) 
    }
    
    fileprivate func hideTableView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewLeftEdgeConstraint.constant = -self.tableViewWidthConstraint.constant
            self.blurView?.effect = nil
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func showTableView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewLeftEdgeConstraint.constant = 0
            self.blurView?.effect = UIBlurEffect(style: .dark)
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func removeInactiveViewController(_ vc: UIViewController?) {
        if isViewLoaded {
            if let validVC = vc {
                validVC.willMove(toParentViewController: nil)
                validVC.view.removeFromSuperview()
                validVC.removeFromParentViewController()
            }
        }
    }
    
    fileprivate func updateActiveViewController() {
        if isViewLoaded {
            if let validVC = activeViewController {
                addChildViewController(validVC)
                validVC.view.frame = containerView.bounds
                containerView.addSubview(validVC.view)
                validVC.didMove(toParentViewController: self)
            }
        }
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Menu Item \(indexPath.row)"
        return cell
    }
}

