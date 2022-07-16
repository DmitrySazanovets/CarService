//
//  ServiceBarVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import UIKit

class ServiceBarVC: UIViewController {
    
    private let vechicleModel = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyLabel.isHidden = !(vechicleModel?.services.isEmpty ?? true) ? true : false
        
        setupTableView()

    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: ServiceCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServiceCell.self))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        RealmManager.updating { [weak self] in
//            self?.models[indexPath.row].isSelected = true
//        }
    }
}

// MARK: - AddServiceDelegate
extension ServiceBarVC: AddServiceDelegate {
    func serviseDidSaved() {
        tableView.reloadData()
    }
}
