//
//  ViewController.swift
//  TestTask
//
//  Created by Никита on 26.03.2022.
//

import UIKit
import SnapKit
import TTGTags

class ViewController: UIViewController {
    private var presenter: ICocktailPresenter
    var tagView = TTGTextTagCollectionView()
    
    private var nameCoktailTextField = UITextField()
    public var drinksArrayHandler: (() -> [Drink])?
    var coctail = [Drink]()
    
    init(presenter: CocktailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter = CocktailPresenter()
        self.presenter.didLoadView(vc: self)
        self.presenter.show()
        keyboardNotificationCenter()
        setupNameCoktailTextField()
        hideKeyboard()
    }
    
    func update() {
        DispatchQueue.main.async {
            guard let coctails = self.drinksArrayHandler?() else {return}
            self.coctail = coctails
            self.addCollectionView()
        }
    }
    
    private func selectOnTag(_ index: UInt) {
        DispatchQueue.main.async {
            self.tagView.getTagAt(index).selected = true
            self.tagView.reload()
        }
        
    }
    
}
//MARK: UI
extension ViewController {
    
    private func setupNameCoktailTextField() {
        nameCoktailTextField = CustomTextField()
        nameCoktailTextField.delegate = self
        self.view.addSubview(self.nameCoktailTextField)
        
        createDefeatConstraintForTextField()
    }
    private func createNewConstraint(keyboard: CGFloat){
        nameCoktailTextField.snp.removeConstraints()
        nameCoktailTextField.layer.cornerRadius = 0
        nameCoktailTextField.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view).offset(0)
            make.width.equalTo(self.view.frame.height)
            make.height.equalTo(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        tagView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.nameCoktailTextField.snp_topMargin).offset(-16)
            make.top.equalToSuperview().offset(keyboard + 35)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    private func createOldConstraint() {
        createDefeatConstraintForTextField()
        createDefeatConstraintForTagView()
    }
    private func createDefeatConstraintForTextField() {
        nameCoktailTextField.snp.removeConstraints()
        nameCoktailTextField.layer.cornerRadius = 15
        nameCoktailTextField.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(-30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
    }
    private func createDefeatConstraintForTagView() {
        tagView.snp.removeConstraints()
        tagView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.nameCoktailTextField.snp_topMargin).offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    private func addCollectionView(){
        tagView = TTGTextTagCollectionView.init(frame: CGRect.init(x: 16, y: 100, width: UIScreen.main.bounds.width - 32, height: 300))
        tagView.backgroundColor = UIColor.white
        tagView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tagView)
        
        createDefeatConstraintForTagView()
        for text in coctail {
            let content = TTGTextTagStringContent.init(text: text.strDrink)
            content.textColor = UIColor.white
            content.textFont = UIFont.boldSystemFont(ofSize: 14)
            
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = UIColor.gray
            normalStyle.cornerRadius = 8
            normalStyle.borderColor = UIColor.gray
            normalStyle.extraSpace = CGSize.init(width: 8, height: 8)
            
            let selectedStyle = TTGTextTagStyle.init()
            selectedStyle.cornerRadius = 8
            selectedStyle.gradientBackgroundStartColor = UIColor.red
            selectedStyle.gradientBackgroundEndColor = UIColor.purple
            selectedStyle.gradientBackgroundStartPoint = CGPoint(x: 0.5, y: 0.0)
            selectedStyle.gradientBackgroundEndPoint = CGPoint(x: 0.5, y: 1.0)
            selectedStyle.enableGradientBackground = true
            selectedStyle.extraSpace = CGSize.init(width: 8, height: 8)
            
            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = selectedStyle
            
            tagView.addTag(tag)
        }
        tagView.reload()
    }
    
    
}

//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(nameCoktailTextField.text!)")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        coctail.enumerated().forEach { num, element in
            if element.strDrink.contains(text!) {
                self.selectOnTag(UInt(num))
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

//MARK: Keyboard
extension ViewController {
    private func hideKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    private func keyboardNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                DispatchQueue.main.async {
                    self.createNewConstraint(keyboard: keyboardSize.height)
                    self.tagView.reload()
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            DispatchQueue.main.async {
                self.createOldConstraint()
            }
        }
    }
}
