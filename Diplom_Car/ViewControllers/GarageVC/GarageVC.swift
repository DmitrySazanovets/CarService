//
//  GarageVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/4/22.
//

import UIKit
import Realm


class GarageVC: UIViewController {
    
    private var models = [TransportVehicleModel]() { didSet {
        emptyLabel.isHidden = !models.isEmpty ? true : false
    } }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupUI()
        fetchTransportVehicle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    
        tableView.rowHeight = 70
        
        
        
        RealmManager.updating { [weak self] in
            self?.models.forEach { $0.isSelected = false }
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - IBActions
    @IBAction func addCarActionButton(_ sender: Any) {
        let vc = AddCarVC(nibName: String(describing: AddCarVC.self), bundle: nil)
        vc.saveBlock = { [weak self] in
            self?.fetchTransportVehicle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private Functions
    // MARK: - UI
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: GarageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GarageCell.self))
    }
    
    private func fetchTransportVehicle() {
        models = RealmManager.read(type: TransportVehicleModel.self)
    }
    
}

extension GarageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GarageCell.self), for: indexPath) as? GarageCell else {
            return UITableViewCell()
        }
        cell.model = models[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        RealmManager.updating { [weak self] in
            self?.models[indexPath.row].isSelected = true
        }
        
        let barController = BarController()
        navigationController?.pushViewController(barController, animated: true)
    }
    
    
}
