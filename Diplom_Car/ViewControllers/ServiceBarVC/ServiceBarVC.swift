//
//  ServiceBarVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import UIKit

class ServiceBarVC: UIViewController {
    
    private var vechicleModel = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyLabel.isHidden = !(vechicleModel?.services.isEmpty ?? true) ? true : false
        
        setupTableView()

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: ServiceCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServiceCell.self))
        tableView.rowHeight = 90

    }
    
    @objc func handleSwipes(sender:UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            self.tabBarController?.selectedIndex = (self.tabBarController?.selectedIndex ?? 0) + 1
        case .right:
            self.tabBarController?.selectedIndex = (self.tabBarController?.selectedIndex ?? 0) - 1
        default: break
        }
    }

    @IBAction func addServiceButtonAction(_ sender: Any) {
        let vc = AddService(nibName: String(describing: AddService.self), bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ServiceBarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vechicleModel?.services.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServiceCell.self), for: indexPath) as? ServiceCell else {
            return UITableViewCell()
        }
        
        cell.service = vechicleModel?.services[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let alertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let model = self.vechicleModel?.services[indexPath.row]
                
                RealmManager.delete(object: model!)
                
                self.vechicleModel = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
                self.emptyLabel.isHidden = !(self.vechicleModel?.papers.isEmpty ?? true) ? true : false
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        item.image = UIImage(systemName: "trash")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
        return swipeActions
    }
}

// MARK: - AddServiceDelegate
extension ServiceBarVC: AddServiceDelegate {
    func serviseDidSaved() {
        
        emptyLabel.isHidden = !(vechicleModel?.services.isEmpty ?? true) ? true : false
        tableView.reloadData()
    }
}
