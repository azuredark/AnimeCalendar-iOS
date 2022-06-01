//
//  NewAnimeTitleTextField.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/06/22.
//

import UIKit

final class NewAnimeTitleTextField: UITextField {
  private let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: self.padding)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: self.padding)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: self.padding)
  }
}
