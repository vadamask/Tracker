//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 23.09.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let viewControllers: [UIViewController] = [
        PageViewController(imageName: "first onboarding", textLabel: "Отслеживайте только то, что хотите"),
        PageViewController(imageName: "second onboarding", textLabel: "Даже если это не литры воды и йога")
    ]
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 2
        control.currentPageIndicatorTintColor = .blackYP
        control.pageIndicatorTintColor = .blackYP30
        return control
    }()
    
    private let button = UIButton(title: "Вот это технологии!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let first = viewControllers.first {
            pageViewController.setViewControllers([first], direction: .forward, animated: true)
        }
        pageViewController.dataSource = self
        pageViewController.delegate = self
        setupLayout()
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    @objc private func buttonDidTapped() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let vc = TabBarController()
            delegate.window?.rootViewController = vc
            UserDefaults.standard.setValue(true, forKey: "onboardingDidVisited")
        }
    }
    
    private func setupLayout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(button)
        view.addSubview(pageControl)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24)
        ])
            
        pageViewController.didMove(toParent: self)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else {
            return viewControllers.last
        }
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < viewControllers.count else {
            return viewControllers.first
        }
        return viewControllers[nextIndex]
    }
    
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentVC = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
        
    }
}