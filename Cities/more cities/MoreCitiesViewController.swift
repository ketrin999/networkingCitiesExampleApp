//
//  MoreCitiesViewController.swift
//  Cities
//
//  Created by Ekaterina Yashunina on 10.09.2023.
//

import UIKit

class MoreCitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewMoreCities: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Выберите город"

        tableViewMoreCities.delegate = self
        tableViewMoreCities.dataSource = self

    }

    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Ошибка загрузки", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MoreCitiesTableViewCell

        let index = indexPath.row
        let cities = cities[index]
        cell.labelMoreCities.text = cities.name

        return cell
    }

}
