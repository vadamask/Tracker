//
//  PageViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 23.09.2023.
//

import SnapKit
import UIKit

final class PageViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let label = UILabel(text: "", textColor: .blackYP, font: UIFont.systemFont(ofSize: 32, weight: .bold))
    private let button = UIButton(title: "Вот это технологии!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
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
    
    private func setupViews() {
        label.numberOfLines = 0
        label.textAlignment = .center
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(button.snp.top).offset(-160)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
}
