//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didTapClose()
    func didTapConfirm(with number: String, cvc: String, expiry: String)
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {

    weak var listener: AddPaymentMethodPresentableListener?
    
    lazy var cardNumberTextField: UITextField = {
       let textfield = makeTextField()
        textfield.placeholder = "카드번호"
        return textfield
    }()
    
    lazy var securityTextField: UITextField = {
       let textfielf = makeTextField()
        textfielf.placeholder = "CVC"
        return textfielf
    }()
    
    lazy var expirationTextField: UITextField = {
       let textfielf = makeTextField()
        textfielf.placeholder = "만료기간"
        return textfielf
    }()

    
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillEqually
        stackview.spacing = 14
        return stackview
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.backgroundColor = .primaryRed
        button.setTitle("추가하기", for: .normal)
        button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    
    private func setupView() {
        title = "카드 추가"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(didTapClosed)
        )
        
        view.addSubview(cardNumberTextField)
        view.addSubview(stackView)
        view.addSubview(addCardButton)
        
        stackView.addArrangedSubview(securityTextField)
        stackView.addArrangedSubview(expirationTextField)
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardNumberTextField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            securityTextField.heightAnchor.constraint(equalToConstant: 60),
            expirationTextField.heightAnchor.constraint(equalToConstant: 60),
            addCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func makeTextField() -> UITextField {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        return textfield
    }
    
    @objc
    private func didTapAddCard() {
        if let number = cardNumberTextField.text,
           let cvc = securityTextField.text,
           let expiry = expirationTextField.text {
            listener?.didTapConfirm(with: number, cvc: cvc, expiry: expiry)
        }
    }
    
    
    @objc
    private func didTapClosed() {
        listener?.didTapClose()
    }

    
}
