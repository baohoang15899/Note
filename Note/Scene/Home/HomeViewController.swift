//
//  HomeViewController.swift
//  Note
//
//  Created by Toi Nguyen on 20/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var lbConfig: UILabel!
    @IBOutlet weak var tbContent: UITableView!
    var viewModel: HomeViewModel = HomeViewModel()
    var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchData()
    }
    
    deinit {
        print("deinit")
    }
    
    private func setupUI() {
        title = "Folder"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(title: "Edit", style: .plain, target: self, action: #selector(editTap))
        navigationItem.rightBarButtonItem?.tintColor = Colors.Yellow
        lbConfig.text = "New Folder"
        lbConfig.textColor = Colors.Yellow
        let tap = UITapGestureRecognizer(target: self, action: #selector(configTap))
        lbConfig.addGestureRecognizer(tap)
        tbContent.tableFooterView = UIView()
        tbContent.delegate = self
        tbContent.dataSource = self
        tbContent.register(cell: HomeTableViewCell.self)
        tbContent.rowHeight = 45
    }
    
    private func createAlert(title: String,
                             message: String,
                             placeholder: String,
                             text: String = "",
                             completion: @escaping((String)) -> Void) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { [unowned self] textField in
            textField.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            textField.placeholder = placeholder
            textField.text = text 
        }
        alert.addAction(.init(title: "Save", style: .default, handler: { [unowned self] _ in
            let textField = self.alert.textFields![0]
            completion(textField.text ?? "")
            tbContent.reloadData()
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        alert.actions[0].isEnabled = false
        alert.view.tintColor = Colors.Yellow
        present(alert, animated: true)
    }
    
    @objc
    private func textChange(_ sender: UITextField) {
        alert.actions[0].isEnabled = !sender.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @objc
    private func configTap() {
        viewModel.configTap { [weak self] isEdit in
            if !isEdit {
                self?.createAlert(title: "New Folder",
                                  message: "Enter a name for this folder",
                                  placeholder: "Name",
                                  completion: { text in self?.viewModel.addFolder(folderName: text, completion: {
                    self?.tbContent.reloadData()
                    if let indexRow = self?.viewModel.numberOfItem() {
                        self?.tbContent.scrollToRow(at: IndexPath(row: indexRow - 1, section: 0), at: .bottom, animated: true)
                    }
                })})
            } else {
                self?.viewModel.deleteItem()
                self?.setNavigationTitle(isEdit: viewModel.edit())
                self?.tbContent.reloadData()
            }
        }
    }
    
    @objc
    private func editTap() {
        viewModel.editTap(completion: { [weak self] isEdit in
            self?.setNavigationTitle(isEdit: isEdit)
            tbContent.reloadData()
            lbConfig.fadeIn { _ in
                self?.lbConfig.fadeOut { _ in
                    self?.lbConfig.text = isEdit ? "Delete" : "New Folder"
                    if isEdit {
                        self?.lbConfig.alpha = self?.viewModel.allCheckedItem() ?? false ? 1 : 0.5
                        self?.lbConfig.isUserInteractionEnabled = self?.viewModel.allCheckedItem() ?? false
                    } else {
                        self?.lbConfig.isUserInteractionEnabled = true
                    }
                }
            }
        })
    }
    
    private func setNavigationTitle(isEdit: Bool) {
        navigationItem.rightBarButtonItem?.title = isEdit ? "Done" : "Edit"
        lbConfig.text = isEdit ? "Delete" : "New Folder"
        lbConfig.alpha = 1
        lbConfig.isUserInteractionEnabled = true
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let oldName = viewModel.itemAtIndex(index: indexPath.row).folder.name ?? ""
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self]  _, _, complete in
            self?.createAlert(title: "Rename Folder", message: "Enter a new name for this folder", placeholder: "Name", text: oldName) { text in
                self?.viewModel.updateFolder(folderName: text, completion: {
                    self?.tbContent.reloadData()
                    self?.setNavigationTitle(isEdit: self?.viewModel.edit() ?? false)
                }, index: indexPath.row)
            }
            complete(true)
        }
        editAction.backgroundColor = Colors.Yellow
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(customClass: HomeTableViewCell.self, for: indexPath)
        cell.configure(item: viewModel.itemAtIndex(index: indexPath.row), isEdit: viewModel.edit(), isEditTap: viewModel.editTapCheck())
        cell.onTapCheckbox = { [weak self] in
            self?.viewModel.tapAtItem(index: indexPath.row)
            self?.lbConfig.alpha = self?.viewModel.allCheckedItem() ?? false ? 1 : 0.5
            self?.viewModel.configTap { isEdit in
                if isEdit {
                    self?.lbConfig.isUserInteractionEnabled = ((self?.viewModel.allCheckedItem()) != nil)
                } else {
                    self?.lbConfig.isUserInteractionEnabled = true
                }
            }
            self?.tbContent.reloadData()
        }
        return cell
    }
}
