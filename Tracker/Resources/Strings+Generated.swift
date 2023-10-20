// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// InfoPlist.strings
    ///   Tracker
    /// 
    ///   Created by Вадим Шишков on 08.10.2023.
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName", fallback: "Трекер")
  }
  internal enum Localizable {
    /// Каждый день
    internal static let everyday = L10n.tr("Localizable", "everyday", fallback: "Каждый день")
    /// Пятница
    internal static let fridayFull = L10n.tr("Localizable", "fridayFull", fallback: "Пятница")
    /// Пт
    internal static let fridayShort = L10n.tr("Localizable", "fridayShort", fallback: "Пт")
    /// Localizable.strings
    ///   Tracker
    /// 
    ///   Created by Вадим Шишков on 05.10.2023.
    internal static let mondayFull = L10n.tr("Localizable", "mondayFull", fallback: "Понедельник")
    /// Пн
    internal static let mondayShort = L10n.tr("Localizable", "mondayShort", fallback: "Пн")
    /// Plural format key: "%#@days@"
    internal static func numberOfDays(_ p1: Int) -> String {
      return L10n.tr("Localizable", "numberOfDays", p1, fallback: "Plural format key: \"%#@days@\"")
    }
    /// Суббота
    internal static let saturdayFull = L10n.tr("Localizable", "saturdayFull", fallback: "Суббота")
    /// Сб
    internal static let saturdayShort = L10n.tr("Localizable", "saturdayShort", fallback: "Сб")
    /// Воскресенье
    internal static let sundayFull = L10n.tr("Localizable", "sundayFull", fallback: "Воскресенье")
    /// Вс
    internal static let sundayShort = L10n.tr("Localizable", "sundayShort", fallback: "Вс")
    /// Четверг
    internal static let thursdayFull = L10n.tr("Localizable", "thursdayFull", fallback: "Четверг")
    /// Чт
    internal static let thursdayShort = L10n.tr("Localizable", "thursdayShort", fallback: "Чт")
    /// Вторник
    internal static let tuesdayFull = L10n.tr("Localizable", "tuesdayFull", fallback: "Вторник")
    /// Вт
    internal static let tuesdayShort = L10n.tr("Localizable", "tuesdayShort", fallback: "Вт")
    /// Среда
    internal static let wednesdayFull = L10n.tr("Localizable", "wednesdayFull", fallback: "Среда")
    /// Ср
    internal static let wednesdayShort = L10n.tr("Localizable", "wednesdayShort", fallback: "Ср")
    internal enum CategoriesScreen {
      /// Удалить
      internal static let deleteCategoryTitle = L10n.tr("Localizable", "categoriesScreen.deleteCategoryTitle", fallback: "Удалить")
      /// Редактировать
      internal static let editCategoryTitle = L10n.tr("Localizable", "categoriesScreen.editCategoryTitle", fallback: "Редактировать")
      internal enum AlertController {
        /// Отменить
        internal static let cancel = L10n.tr("Localizable", "categoriesScreen.alertController.cancel", fallback: "Отменить")
        /// Удалить
        internal static let delete = L10n.tr("Localizable", "categoriesScreen.alertController.delete", fallback: "Удалить")
        /// Эта категория точно не нужна?
        internal static let message = L10n.tr("Localizable", "categoriesScreen.alertController.message", fallback: "Эта категория точно не нужна?")
      }
      internal enum Button {
        /// Добавить категорию
        internal static let addTitle = L10n.tr("Localizable", "categoriesScreen.button.addTitle", fallback: "Добавить категорию")
      }
      internal enum EmptyState {
        /// Привычки и события можно объединить по смыслу
        internal static let title = L10n.tr("Localizable", "categoriesScreen.emptyState.title", fallback: "Привычки и события можно объединить по смыслу")
      }
      internal enum TopLabel {
        /// Категория
        internal static let title = L10n.tr("Localizable", "categoriesScreen.topLabel.title", fallback: "Категория")
      }
    }
    internal enum CollectionScreen {
      /// Фильтры
      internal static let filterButton = L10n.tr("Localizable", "collectionScreen.filterButton", fallback: "Фильтры")
      /// Закрепленные
      internal static let pinHeader = L10n.tr("Localizable", "collectionScreen.pinHeader", fallback: "Закрепленные")
      internal enum AlertController {
        /// Отменить
        internal static let cancelAction = L10n.tr("Localizable", "collectionScreen.alertController.cancelAction", fallback: "Отменить")
        /// Удалить
        internal static let deleteAction = L10n.tr("Localizable", "collectionScreen.alertController.deleteAction", fallback: "Удалить")
        /// Уверены, что хотите удалить трекер?
        internal static let message = L10n.tr("Localizable", "collectionScreen.alertController.message", fallback: "Уверены, что хотите удалить трекер?")
      }
      internal enum ContextMenu {
        /// Удалить
        internal static let deleteAction = L10n.tr("Localizable", "collectionScreen.contextMenu.deleteAction", fallback: "Удалить")
        /// Редактировать
        internal static let editAction = L10n.tr("Localizable", "collectionScreen.contextMenu.editAction", fallback: "Редактировать")
        /// Закрепить
        internal static let pinAction = L10n.tr("Localizable", "collectionScreen.contextMenu.pinAction", fallback: "Закрепить")
        /// Открепить
        internal static let unpinAction = L10n.tr("Localizable", "collectionScreen.contextMenu.unpinAction", fallback: "Открепить")
      }
      internal enum EmptySearch {
        /// Ничего не найдено
        internal static let title = L10n.tr("Localizable", "collectionScreen.emptySearch.title", fallback: "Ничего не найдено")
      }
      internal enum EmptyState {
        /// Что будем отслеживать?
        internal static let title = L10n.tr("Localizable", "collectionScreen.emptyState.title", fallback: "Что будем отслеживать?")
      }
      internal enum NavigationItem {
        /// Трекеры
        internal static let title = L10n.tr("Localizable", "collectionScreen.navigationItem.title", fallback: "Трекеры")
      }
      internal enum SearchBar {
        /// Отменить
        internal static let cancelButton = L10n.tr("Localizable", "collectionScreen.searchBar.cancelButton", fallback: "Отменить")
        /// Поиск
        internal static let placeholder = L10n.tr("Localizable", "collectionScreen.searchBar.placeholder", fallback: "Поиск")
      }
    }
    internal enum FiltersScreen {
      internal enum Filter {
        /// Все трекеры
        internal static let all = L10n.tr("Localizable", "filtersScreen.filter.all", fallback: "Все трекеры")
        /// Завершенные
        internal static let completed = L10n.tr("Localizable", "filtersScreen.filter.completed", fallback: "Завершенные")
        /// Незавершенные
        internal static let incomplete = L10n.tr("Localizable", "filtersScreen.filter.incomplete", fallback: "Незавершенные")
        /// Трекеры на сегодня
        internal static let today = L10n.tr("Localizable", "filtersScreen.filter.today", fallback: "Трекеры на сегодня")
      }
      internal enum TopLabel {
        /// Фильтры
        internal static let title = L10n.tr("Localizable", "filtersScreen.topLabel.title", fallback: "Фильтры")
      }
    }
    internal enum NewCategoryScreen {
      /// Готово
      internal static let doneButtonTitle = L10n.tr("Localizable", "newCategoryScreen.doneButtonTitle", fallback: "Готово")
      /// Редактирование категории
      internal static let topLabelForEdit = L10n.tr("Localizable", "newCategoryScreen.topLabelForEdit", fallback: "Редактирование категории")
      /// Новая категория
      internal static let topLabelForNew = L10n.tr("Localizable", "newCategoryScreen.topLabelForNew", fallback: "Новая категория")
      internal enum AlertController {
        /// Ок
        internal static let action = L10n.tr("Localizable", "newCategoryScreen.alertController.action", fallback: "Ок")
        /// Такое название уже есть
        internal static let message = L10n.tr("Localizable", "newCategoryScreen.alertController.message", fallback: "Такое название уже есть")
        /// Ошибка
        internal static let title = L10n.tr("Localizable", "newCategoryScreen.alertController.title", fallback: "Ошибка")
      }
      internal enum TextField {
        /// Введите название категории
        internal static let placeholder = L10n.tr("Localizable", "newCategoryScreen.textField.placeholder", fallback: "Введите название категории")
      }
    }
    internal enum NewTrackerScreen {
      internal enum EventButton {
        /// Нерегулярное событие
        internal static let title = L10n.tr("Localizable", "newTrackerScreen.eventButton.title", fallback: "Нерегулярное событие")
      }
      internal enum TopLabel {
        /// Создание трекера
        internal static let title = L10n.tr("Localizable", "newTrackerScreen.topLabel.title", fallback: "Создание трекера")
      }
      internal enum TrackerButton {
        /// Привычка
        internal static let title = L10n.tr("Localizable", "newTrackerScreen.trackerButton.title", fallback: "Привычка")
      }
    }
    internal enum OnboardingScreen {
      internal enum Button {
        /// Вот это технологии!
        internal static let title = L10n.tr("Localizable", "onboardingScreen.button.title", fallback: "Вот это технологии!")
      }
      internal enum FirstPage {
        internal enum Label {
          /// Отслеживайте только то, что хотите
          internal static let title = L10n.tr("Localizable", "onboardingScreen.firstPage.label.title", fallback: "Отслеживайте только то, что хотите")
        }
      }
      internal enum SecondPage {
        internal enum Label {
          /// Даже если это не литры воды и йога
          internal static let title = L10n.tr("Localizable", "onboardingScreen.secondPage.label.title", fallback: "Даже если это не литры воды и йога")
        }
      }
    }
    internal enum ScheduleScreen {
      /// Готово
      internal static let doneButtonTitle = L10n.tr("Localizable", "scheduleScreen.doneButtonTitle", fallback: "Готово")
      internal enum TopLabel {
        /// Расписание
        internal static let title = L10n.tr("Localizable", "scheduleScreen.topLabel.title", fallback: "Расписание")
      }
    }
    internal enum SetupTrackerScreen {
      internal enum CancelButton {
        /// Отменить
        internal static let title = L10n.tr("Localizable", "setupTrackerScreen.cancelButton.title", fallback: "Отменить")
      }
      internal enum Category {
        /// Категория
        internal static let title = L10n.tr("Localizable", "setupTrackerScreen.category.title", fallback: "Категория")
      }
      internal enum Color {
        /// Цвет
        internal static let header = L10n.tr("Localizable", "setupTrackerScreen.color.header", fallback: "Цвет")
      }
      internal enum CreateButton {
        /// Создать
        internal static let title = L10n.tr("Localizable", "setupTrackerScreen.createButton.title", fallback: "Создать")
      }
      internal enum Emoji {
        /// Emoji
        internal static let header = L10n.tr("Localizable", "setupTrackerScreen.emoji.header", fallback: "Emoji")
      }
      internal enum SaveButton {
        /// Сохранить
        internal static let title = L10n.tr("Localizable", "setupTrackerScreen.saveButton.title", fallback: "Сохранить")
      }
      internal enum Schedule {
        /// Расписание
        internal static let title = L10n.tr("Localizable", "setupTrackerScreen.schedule.title", fallback: "Расписание")
      }
      internal enum TextField {
        /// Введите название трекера
        internal static let placeholder = L10n.tr("Localizable", "setupTrackerScreen.textField.placeholder", fallback: "Введите название трекера")
      }
      internal enum TopLabel {
        /// Редактирование привычки
        internal static let editingMode = L10n.tr("Localizable", "setupTrackerScreen.topLabel.editingMode", fallback: "Редактирование привычки")
        /// Новое нерегулярное событие
        internal static let eventTitle = L10n.tr("Localizable", "setupTrackerScreen.topLabel.eventTitle", fallback: "Новое нерегулярное событие")
        /// Новая привычка
        internal static let trackerTitle = L10n.tr("Localizable", "setupTrackerScreen.topLabel.trackerTitle", fallback: "Новая привычка")
      }
      internal enum WarningLabel {
        /// Ограничение 38 символов
        internal static let title = L10n.tr("Localizable", "setupTrackerScreen.warningLabel.title", fallback: "Ограничение 38 символов")
      }
    }
    internal enum StatisticsScreen {
      /// Среднее значение
      internal static let avgValue = L10n.tr("Localizable", "statisticsScreen.avgValue", fallback: "Среднее значение")
      /// Лучший период
      internal static let bestPeriod = L10n.tr("Localizable", "statisticsScreen.bestPeriod", fallback: "Лучший период")
      /// Идеальные дни
      internal static let perfectDays = L10n.tr("Localizable", "statisticsScreen.perfectDays", fallback: "Идеальные дни")
      /// Трекеров завершено
      internal static let trackersCompleted = L10n.tr("Localizable", "statisticsScreen.trackersCompleted", fallback: "Трекеров завершено")
      internal enum AlertController {
        /// Ок
        internal static let ok = L10n.tr("Localizable", "statisticsScreen.alertController.ok", fallback: "Ок")
        /// Ошибка
        internal static let title = L10n.tr("Localizable", "statisticsScreen.alertController.title", fallback: "Ошибка")
      }
      internal enum EmptyState {
        /// Анализировать пока нечего
        internal static let title = L10n.tr("Localizable", "statisticsScreen.emptyState.title", fallback: "Анализировать пока нечего")
      }
      internal enum NavigationItem {
        /// Статистика
        internal static let title = L10n.tr("Localizable", "statisticsScreen.navigationItem.title", fallback: "Статистика")
      }
    }
    internal enum TabBarItem {
      /// Трекеры
      internal static let collection = L10n.tr("Localizable", "tabBarItem.collection", fallback: "Трекеры")
      /// Статистика
      internal static let statistics = L10n.tr("Localizable", "tabBarItem.statistics", fallback: "Статистика")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
