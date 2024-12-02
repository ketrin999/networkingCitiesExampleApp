//
//  CitiesViewController.swift
//  Cities
//
//  Created by Ekaterina Yashunina on 08.09.2023.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableCities: UITableView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var city: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableCities.delegate = self
        tableCities.dataSource = self


        tableCities.isHidden = true
        activityIndicator.startAnimating()

        getCititesFromNetwork()
    }

    func getCititesFromNetwork() {
        let url = URL(string: "http://192.168.1.143:8080/api/v1/cities")!

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
                    let cities = try! JSONDecoder().decode([City].self, from: data!)
                    self.city.append(contentsOf: cities)

                    DispatchQueue.main.async {
                        self.tableCities.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.tableCities.isHidden = false
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
        return city.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        let index = indexPath.row
        let city = city[index]
        cell.cityNameLabel.text = city.name

        return cell
    }
}
