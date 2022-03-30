//
//  CustomTextField.swift
//  TestTask
//
//  Created by Никита on 26.03.2022.
//
import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.frame = CGRect(x: 0, y: 0, width: 100.00, height: 40.00)
        self.textColor = .black
        self.backgroundColor = .white
        self.placeholder = "Coctail name"
        self.textAlignment = .center
//        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.7
        self.layer.cornerRadius = 15
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
