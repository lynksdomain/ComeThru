//
//  CreateWhimView.swift
//  wmsy
//
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class CreateWhimView: UIView {

    // Category Collection View
    
    // Title Textfield with max 100 characters
    // Dynamic label with remaining characters out of 100
    
    // Description Textview with Max 200 Characters
    // Dynamic label with remaining characters out of 200
    
    // Label instructions for Pickerview: "Whim will expire in __ hours"
    // Pickerview with 1 - 24 hours
    
    // Button to select address: "Open Map to Select Meeting Location"
    // Address Label
    
    // "Host a Whim" button
    
    
    // setup custom view
    var creatWhimTVC = CreateWhimTVC()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var tableView: UITableView = {
       let tV = UITableView()
        return tV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        setupContainerView()
        setUpTableView()
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.90).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.80).isActive = true
    }

    private func setUpTableView() {
        containerView.addSubview(creatWhimTVC.tableView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}