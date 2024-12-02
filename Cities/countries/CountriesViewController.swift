//
//  CountriesViewController.swift
//  Cities
//
//  Created by Ekaterina Yashunina on 09.09.2023.
//

import UIKit

class CountriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var country: [Country] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выберите страну"
        tableView.delegate = self
        tableView.dataSource = self

        tableView.isHidden = true
        activityIndicator.startAnimating()

        getCountriesFromNetwork()

    }

    func getCountriesFromNetwork() {
        let url = URL(string: "http://192.168.1.143:8080/api/v1/countries")!

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(errorMessage: error?.localizedDescription ?? "Ошибка")
                }
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.showErrorAlert(errorMessage: "От сервиса получен ответ \(httpResponse.statusCode)")
                    }
                } else {
                    let countries = try! JSONDecoder().decode ([Country].self, from: data!)
                    self.country.append(contentsOf: countries)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.tableView.isHidden = false
                    }
                }
            }

        }.resume()
    }

    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Ошибка загрузки", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryTableViewCell

        let index = indexPath.row
        let country = country[index]
        cell.countryLabel.text = country.name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "citiesVC") as! MoreCitiesViewController

        let country = country[indexPath.row]
        viewController.cities = country.cities

        navigationController?.pushViewController(viewController, animated: true)
    }
}
