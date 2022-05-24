//
//  HomeTableViewCellViewModel.swift
//  Note
//
//  Created by Toi Nguyen on 23/05/2022.
//

import Foundation

class HomeTableViewCellViewModel {
    var isChecked: Bool = false
    var folder: Folder = Folder()
    
    init(isOpen: Bool,folder: Folder) {
        self.isChecked = isOpen
        self.folder = folder
    }
}

