//
//  HomeViewModel.swift
//  Note
//
//  Created by Toi Nguyen on 20/05/2022.
//

import Foundation

class HomeViewModel {
    private var isEdit: Bool = false
    private var isEditTap: Bool = false
    private var folders: [Folder] = []
    private var items: [HomeTableViewCellViewModel] = []
    private let context = AppDelegate.shared.persistentContainer.viewContext
    
    func fetchData() {
        isEdit = false
        do {
            folders = try context.fetch(Folder.fetchRequest())
            items = folders.compactMap { item in
                HomeTableViewCellViewModel.init(isOpen: false, folder: item)
            }
        } catch {
            print("Can't fetch data")
        }
    }
    
    func editTapCheck() -> Bool {
        return isEditTap
    }
    
    func edit() -> Bool {
        return isEdit
    }
    
    func updateFolder(folderName: String,  completion:() -> Void, index: Int) {
        isEditTap = true
        folders[index].name = folderName
        items.forEach { item in
            item.isChecked = false
        }
        do {
            try context.save()
            fetchData()
            completion()
        } catch {
            print("Can't save data")
        }
    }
    
    func addFolder(folderName: String, completion:() -> Void) {
        let item = Folder(context: context)
        item.name = folderName
        item.items = 0
        isEditTap = false
        do {
            try context.save()
            fetchData()
            completion()
        } catch {
            print("Can't save data")
        }
    }
    
    func tapAtItem(index: Int) {
        if index >= 0 && index < items.count {
            items[index].isChecked.toggle()
        }
    }
    
    func deleteItem() {
        for (index, _ ) in folders.enumerated() {
            if items[index].isChecked {
                context.delete(folders[index])
            }
        }
        do {
            try context.save()
        } catch {
            print("Can't delete data")
        }
        fetchData()
    }
    
    func editTap(completion: ((Bool)) -> Void) {
        isEditTap = true
        items.forEach { item in
            item.isChecked = false
        }
        isEdit.toggle()
        completion(isEdit)
    }
    
    func allCheckedItem() -> Bool{
        let results = items.filter { item in
            item.isChecked
        }
        return !results.isEmpty
    }
    
    func configTap(completion: ((Bool)) -> Void) {
        completion(isEdit)
    }
    
    func numberOfItem() -> Int {
        return items.count
    }
    
    func itemAtIndex(index: Int) -> HomeTableViewCellViewModel {
        if index >= 0 && index < items.count {
            return items[index]
        } else {
            return HomeTableViewCellViewModel(isOpen: false, folder: Folder())
        }
    }
}
