//
//  TwoButtonsTableViewCell.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/24/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import UIKit

class TwoButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    var chatButtonPushed: ((UIButton) -> Void)?
    var callButtonPushed: ((UIButton) -> Void)?
    
    let chatButton = UIButton()
    let callButton = UIButton()
    
    var isChatEnabled: Bool = false {
        didSet {
            checkAndSetButtons()
        }
    }
    
    var isCallEnabled: Bool = false {
        didSet {
            checkAndSetButtons()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.callButton.backgroundColor = .green
        self.callButton.setTitleColor(.white, for: .normal)
        self.chatButton.setTitleColor(.white, for: .normal)
        self.chatButton.backgroundColor = .blue
        
        self.callButton.setTitle("Call", for: .normal)
        self.chatButton.setTitle("Chat", for: .normal)
        
        self.chatButton.layer.cornerRadius = 10
        self.callButton.layer.cornerRadius = 10
        
        self.chatButton.addTarget(self, action: #selector(TwoButtonsTableViewCell.chatButtonTouchInside(_:)), for: .touchUpInside)
        self.callButton.addTarget(self, action: #selector(TwoButtonsTableViewCell.callButtonTouchInside(_:)), for: .touchUpInside)
        checkAndSetButtons()
    }
    
    @objc func chatButtonTouchInside(_ sender: UIButton) {
        self.chatButtonPushed?(sender)
    }
    
    @objc func callButtonTouchInside(_ sender: UIButton) {
        self.callButtonPushed?(sender)
    }
    
    func checkAndSetButtons() {
        guard stackView != nil else {return}
        if isCallEnabled && !stackView.subviews.contains(self.callButton) {
            stackView.addArrangedSubview(self.callButton)
        } else if !isCallEnabled {
            self.callButton.removeFromSuperview()
        }
        
        if (isChatEnabled && !stackView.subviews.contains(self.chatButton)) {
            self.stackView.addArrangedSubview(chatButton)
        } else if !isChatEnabled {
            self.chatButton.removeFromSuperview()
        }
    }
    
}
