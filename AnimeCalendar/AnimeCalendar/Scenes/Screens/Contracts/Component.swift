//
//  Component.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

protocol Component: AnyObject {
  func configureComponent()
  func configureView()
  func configureSubviews()
}

// Component: AnyObject
/// - configureComponent()
/// - configureView()
/// - configureSubviews()

// Bindable: AnyObject
/// - configureBindings()

// ScreenComponent: Component & UIViewController
/// - configureScreen()
/// - configureNavigationItems()
/// - configureScreenComponents()

// ScreenComponentTable: Component & UITableView
/// - configureTable()

// ScreenComponentCollection: Component & UICollectionView
/// - configureCollection()

// ScreenComponentItem: Component & Bindable
/// - configureInitialState()

// ScreenComponentItemTable: ScreenComponentItem & UITableViewCell
/// - configureTableItem()

// ScreenComponentItemCollection: ScreenComponentItem & UICollectionViewCell
/// - configureCollectionItem()
