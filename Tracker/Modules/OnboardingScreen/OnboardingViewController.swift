//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 23.09.2023.
//

import SnapKit
import UIKit

final class OnboardingViewController: UIViewController {
    
    private var viewControllers: [UIViewController] = []
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let colors = Colors.shared
    
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        let vc1 = PageViewController(
            image: UIImage(asset: Asset.Assets.OnboardingScreen.firstOnboarding),
            textLabel: L10n.Localizable.OnboardingScreen.FirstPage.Label.title
        )
        let vc2 = PageViewController(
            image: UIImage(asset: Asset.Assets.OnboardingScreen.secondOnboarding),
            textLabel: L10n.Localizable.OnboardingScreen.SecondPage.Label.title
        )
        viewControllers.append(contentsOf: [vc1, vc2])
        
        if let first = viewControllers.first {
            pageViewController.setViewControllers([first], direction: .forward, animated: true)
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        pageControl.currentPageIndicatorTintColor = colors.blackStaticYP
        pageControl.pageIndicatorTintColor = colors.blackStaticYP30
        pageControl.isEnabled = false
    }
    
    private func setupLayout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-134)
        }
            
        pageViewController.didMove(toParent: self)
    }
}

// MARK: - UIPageViewControllerDataSource

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

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentVC = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
        
    }
}
