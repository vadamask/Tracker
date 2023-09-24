//
//  PageViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 23.09.2023.
//

import UIKit

final class PageViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let label = UILabel(text: "", textColor: .blackYP, font: UIFont.systemFont(ofSize: 32, weight: .bold))
    private let button = UIButton(title: "Вот это технологии!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        label.numberOfLines = 0
        label.textAlignment = .center
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    init(imageName: String, textLabel: String) {
        imageView.image = UIImage(named: imageName)
        label.text = textLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonDidTapped() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let vc = TabBarController()
            delegate.window?.rootViewController = vc
            UserDefaults.standard.setValue(true, forKey: "onboardingDidVisited")
        }
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -160),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
