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
