//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import UIKit

final class AddPaymentMethodButton: UIControl {
    private let plusIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        setupViews()
    }
    
    private func setupViews() {
        addSubview(plusIcon)
        
        NSLayoutConstraint.activate([
            plusIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
