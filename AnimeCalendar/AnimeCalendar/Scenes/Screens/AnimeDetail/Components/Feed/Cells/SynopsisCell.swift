//
//  SynopsisCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 11/06/23.
//

import UIKit

final class SynopsisCell: UICollectionViewCell, FeedCell {
    // MARK: Public State
    weak var synopsisContent: SynopsisContent?
    
    // MARK: Private State
    
    // MARK: UI
    private lazy var synopsisLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Color.lightGray
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        contentView.addSubview(label)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        synopsisLabel.text = nil
    }

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setup() {
        synopsisLabel.text = synopsisContent?.synopsis
    }
}

private extension SynopsisCell {
    func layoutUI() {
        layoutSynopsisLabel()
    }
    
    func layoutSynopsisLabel() {
        synopsisLabel.fitViewTo(contentView)
    }
}
