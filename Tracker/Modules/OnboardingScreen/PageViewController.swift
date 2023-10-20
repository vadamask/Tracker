//
//  PageViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 23.09.2023.
//

import SnapKit
import UIKit

final class PageViewController: UIViewController {
    
    private let colors = Colors.shared
    private let imageView = UIImageView()
    private let label = UILabel()
    private let button = UIButton()
    
    init(image: UIImage?, textLabel: String) {
        imageView.image = image
        label.text = textLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    @objc
    private func buttonDidTapped() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let vc = TabBarController()
            delegate.window?.rootViewController = vc
            UserDefaults.standard.setValue(true, forKey: "onboardingDidVisited")
        }
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = colors.blackStaticYP
        label.font = .systemFont(ofSize: 32, weight: .bold)
        
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        button.setTitle(L10n.Localizable.OnboardingScreen.Button.title, for: .normal)
        button.setTitleColor(colors.whiteStaticYP, for: .normal)
        button.backgroundColor = colors.blackStaticYP
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
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
            make.bottom.equalTo(button.snp.top).offset(-190)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
}
