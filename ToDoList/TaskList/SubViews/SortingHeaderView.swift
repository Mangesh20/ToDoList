//
//  SortingHeaderView.swift
//  ToDoList
//
//  Created by mangesht on 20/04/23.
//

import Foundation
import UIKit

class SortingHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    let sortingLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        sortingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sortingLabel)
        
        NSLayoutConstraint.activate([
            sortingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sortingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
