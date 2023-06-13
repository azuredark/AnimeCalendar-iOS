//
//  UIStackView+Spacing.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 2/01/23.
//

import UIKit

enum SpacingNeighbor: Hashable {
    case previous(spacing: CGFloat)
    case next(spacing: CGFloat)

    var spacing: CGFloat {
        switch self {
            case .previous(let spacing):
                return spacing
            case .next(let spacing):
                return spacing
        }
    }
}

extension UIStackView {
    /// The view **must** already be added as an **arrangedSubView**.
    /// This will attempt to add **custom**
    func addCustomSpacing(from currentView: UIView, neighbors: [SpacingNeighbor]) {
        // There can only be up to 2 neighbors.
        guard neighbors.count <= 2 else { return }

        // There cannot be a neighbor list with all repeated elments.
        if neighbors.count == 2, neighbors.allItemsAreRepeated { return }

        /// # Check view is already in **arrangedSubviews** of the **stack**.
        // This check may not be necessary as the API already makes this check.
        // And ignores custom spacing for views that are not in the **arrangedSubiew** list.
        guard viewIsInStack(currentView) else { return }

        /// If the item is the *initial* element, then there is no *previous-neighbor*, so account for the missing part.
        let missingNeighborSpacing: CGFloat = (arrangedSubviewsCount == 1) ? getMissingNeighborSpacing(neighbors) : 0
        
        neighbors.forEach { neighborView in
            switch neighborView {
                case .next(let spacing):
                    // Get current view -> Add customSpacing(:after)
                    addCustomNextSpacing(to: currentView, spacing: spacing + missingNeighborSpacing)
                case .previous(let spacing) where neighbors.count > 1:
                    // Get previous subview -> Add customSpacing(:after)
                    addCustomPreviousSpacing(to: currentView, spacing: spacing)
                default: break
            }
        }
    }

    func addCustomNextSpacing(to view: UIView, spacing: CGFloat) {
        setCustomSpacing(spacing, after: view)
    }

    func addCustomPreviousSpacing(to view: UIView, spacing: CGFloat) {
        // There must be at least 2 views (Including the currentView) currently added.
        // in order to add spacing to the previous one.
        guard arrangedSubviews.count >= 2 else { return }

        // Get the current view's index
        guard let currentViewIndex = arrangedSubviews.firstIndex(where: { $0 == view }) else {
            return
        }

        // Access the previous view
        let previousView: UIView = arrangedSubviews[currentViewIndex - 1]

        setCustomSpacing(spacing, after: previousView)
    }

    /// Check if view is in the current **UIStackView**
    ///
    /// - Parameter view: View to check.
    /// - Returns: If it's in the stack already or not.
    func viewIsInStack(_ view: UIView) -> Bool {
        let inStack = arrangedSubviews.first(where: { $0 == view }) != nil
        if !inStack {
            print("senku [❌] \(String(describing: type(of: self))) - Error: \(view) is not in \(self).")
        }
        return inStack
    }
    
    var arrangedSubviewsCount: Int { self.arrangedSubviews.count }
}

private extension UIStackView {
    func getMissingNeighborSpacing(_ neighbors: [SpacingNeighbor]) -> CGFloat {
        /// The spacing value is being ignored when comparing them
        var spacing: CGFloat = 0
        for neighbor in neighbors {
            // Ignores (let spacing) comparison.
            if case .previous = neighbor {
                spacing = neighbor.spacing
                return spacing
            }
        }
        
        return spacing
    }
}
