//
//  TrackerSetupView.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.09.2023.
//

import Foundation

final class TrackerSetupViewModel {
    
    @Observable var textTooLong = false
    @Observable var createButtonIsAllowed = false
    @Observable var error: Error?
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                  "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let model: TrackerSetupModel
    private var isTracker = true
    
    init(model: TrackerSetupModel) {
        self.model = model
    }
    
    func createButtonTapped() {
        model.addTracker()
    }
    
    func saveButtonTapped(_ id: UUID) {
        do {
           try self.model.replaceTracker(with: id)
        } catch {
            self.error = error
        }
    }
    
    func eventIsSelected() {
        model.eventIsSelected()
        isTracker = false
    }
    
    func trackerIsPinned(_ isPinned: Bool) {
        model.trackerIsPinned(isPinned)
    }
    
}

// MARK: - TextField

extension TrackerSetupViewModel {
    
    func textDidChanged(_ text: String) {
        textTooLong = model.textTooLong(text)
        model.textDidChanged(text)
        createButtonIsAllowed = model.isAllSetup
    }
    
    func clearTextButtonTapped() {
        textTooLong = false
        createButtonIsAllowed = false
    }
}

// MARK: - TableView

extension TrackerSetupViewModel {
    
    func didSelectCategory(_ category: String) {
        model.didSelectCategory(category)
        createButtonIsAllowed = model.isAllSetup
    }
    
    func didSelectSchedule(_ schedule: Set<WeekDay>) {
        model.didSelectSchedule(schedule)
        createButtonIsAllowed = model.isAllSetup
    }
    
    func didDeselectCategory() {
        model.didDeselectCategory()
        createButtonIsAllowed = false
    }
    
    func didDeselectSchedule() {
        model.didDeselectSchedule()
        createButtonIsAllowed = false
    }
}

// MARK: - CollectionView

extension TrackerSetupViewModel {
    
    func emojiForCollectionView(at indexPath: IndexPath) -> String {
        emojis[indexPath.row]
    }
    
    func didSelectEmoji(at indexPath: IndexPath) {
        model.didSelectEmoji(emojis[indexPath.row])
        createButtonIsAllowed = model.isAllSetup
    }
    
    func didSelectColor(at indexPath: IndexPath) {
        model.didSelectColor(at: indexPath)
        createButtonIsAllowed = model.isAllSetup
    }
    
    func didDeselectEmoji() {
        model.didDeselectEmoji()
        createButtonIsAllowed = false
    }
    
    func didDeselectColor() {
        model.didDeselectColor()
        createButtonIsAllowed = false
    }
}
