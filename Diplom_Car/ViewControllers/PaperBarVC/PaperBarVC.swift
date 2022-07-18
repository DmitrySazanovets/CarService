//
//  PaperBarVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import UIKit

class PaperBarVC: UIViewController {
    
    private var vechicleModel = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let swiping = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        view.addGestureRecognizer(swiping)
        
        emptyLabel.isHidden = !(vechicleModel?.papers.isEmpty ?? true) ? true : false
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: PaperCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PaperCell.self))
        tableView.rowHeight = 60
    }
    
    @IBAction func addDockButtonAction(_ sender: Any) {
        let vc = AddPaperVC(nibName: String(describing: AddPaperVC.self), bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSwipes(sender:UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            self.tabBarController?.selectedIndex = (self.tabBarController?.selectedIndex ?? 0) - 1
        default: break
        }
    }

}
extension PaperBarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vechicleModel?.papers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaperCell.self), for: indexPath) as? PaperCell else {
            return UITableViewCell()
        }
        
        cell.paper = vechicleModel?.papers[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cell
//        RealmManager.delete(object: TransportPaper[indexPath.row])
        }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let alertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let model = self.vechicleModel?.papers [indexPath.row]
                
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

extension PaperBarVC: AddPaperVCDelegate {
    func paperDidSaved() {
        emptyLabel.isHidden = !(vechicleModel?.papers.isEmpty ?? true) ? true : false
        tableView.reloadData()
    }
}
