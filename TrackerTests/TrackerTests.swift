//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Вадим Шишков on 08.10.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testCollectionVCLight() {
        let params = GeometricParameters(
            cellCount: 2,
            leftInset: 16,
            rightInset: 16,
            cellSpacing: 9
        )
        let vc = TrackersCollectionViewController(params: params)
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testStatisticsVCLight() {
        let vc = StatisticsViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testNewTrackerVCLight() {
        let vc = NewTrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testSetupVCLight() {
        let trackerVC = TrackerSetupViewController(isTracker: true)
        let eventVC = TrackerSetupViewController(isTracker: false)
        assertSnapshot(of: trackerVC, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(of: eventVC, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testNewCategoryVCLight() {
        let vc = NewCategoryViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testCollectionVCDark() {
        let params = GeometricParameters(
            cellCount: 2,
            leftInset: 16,
            rightInset: 16,
            cellSpacing: 9
        )
        let vc = TrackersCollectionViewController(params: params)
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testStatisticsVCDark() {
        let vc = StatisticsViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testNewTrackerVCDark() {
        let vc = NewTrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testSetupVCDark() {
        let trackerVC = TrackerSetupViewController(isTracker: true)
        let eventVC = TrackerSetupViewController(isTracker: false)
        assertSnapshot(of: trackerVC, as: .image(traits: .init(userInterfaceStyle: .dark)))
        assertSnapshot(of: eventVC, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testNewCategoryVCDark() {
        let vc = NewCategoryViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
