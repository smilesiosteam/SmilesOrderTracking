//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 03/12/2023.
//

import Foundation

import UIKit

final class FloatingView: UIView {

    var didLeadingButton: (() -> Void)?
    var didTrailingButton: (() -> Void)?
    
    private let leadingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .closeIconPurple), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.fontTextStyle = .smilesTitle1
        button.layer.cornerRadius = 20
        button.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        return button
    }()

   private let trailingButton: UIButton = {
        let button = UIButton()
        button.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.fontTextStyle = .smilesTitle1
        button.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        return button
    }()
    
    private let lineView: UIView = {
         let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addButtonsAction()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addButtonsAction()
    }

    private func setupUI() {
        addSubview(leadingButton)
        addSubview(trailingButton)
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            // Leading button constraints
            leadingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leadingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            leadingButton.heightAnchor.constraint(equalToConstant: 40),

            // Trailing button constraints
            trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trailingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            trailingButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Line view
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    private func addButtonsAction() {
        leadingButton.addTarget(self, action: #selector(leadingAction), for: .touchUpInside)
        trailingButton.addTarget(self, action: #selector(trailingAction), for: .touchUpInside)
    }
    
    @objc private func leadingAction() {
        didLeadingButton?()
    }
    
    @objc private func trailingAction() {
        didTrailingButton?()
    }
}
