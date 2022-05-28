//
//  ComponentCollectionItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/22.
//

import Foundation

protocol ComponentCollectionItem {
  func configureCollectionItem()
  func configureCollectionItemBindings()
  func configureView()
  func configureInitialValues()
  func configureSubViews()
}
