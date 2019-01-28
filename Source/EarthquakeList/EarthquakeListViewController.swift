//
//  EarthquakeListViewController.swift
//  EarthquakeCatalog
//
//  Created by Michael Baldwin on 1/28/19.
//  Copyright © 2019 mikebaldwin.co. All rights reserved.
//

import UIKit
import SafariServices

// Mark: - Named Constants
private extension Int {
    static var tableSections = 1
}

private extension String {
    static var cellId = "EarthquakeCell"
}

// Mark: - Class declaration

class EarthquakeListViewController: UITableViewController {
    
    let earthquakeCatalog = EarthquakeCatalog()
    var earthquakes: [Earthquake] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Earthquakes"
        refreshEarthquakeData()
    }
    
}

private extension EarthquakeListViewController {
    
    func refreshEarthquakeData() {
        earthquakeCatalog.earthquakesFromLast30Days(
            // Refresh data and reload tableview
            success: { [weak self] earthquakes in
                self?.earthquakes = earthquakes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            },
            // Display an alert to the user
            failure: { [weak self] error in
                debugPrint("API failure: \(error)")
                self?.presentDownloadFailedAlert()
            }
        )
    }
    
    func presentDownloadFailedAlert() {
        let alertController = UIAlertController(
            title: "Failed to download Earthquake Catalog",
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Table view data source + helpers
extension EarthquakeListViewController {
    
    var emptyStateCell: UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Downloading earthquake data..."
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return .tableSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (earthquakes.count > 0) ? earthquakes.count : 1
    }
    
    func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let earthquake = earthquakes[indexPath.row]
        cell.textLabel?.text = earthquake.title
        cell.detailTextLabel?.text = "Detail text"
        cell.accessoryType = .disclosureIndicator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // check for empty state
        guard earthquakes.count > 0 else { return emptyStateCell }
        
        // populate cells
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellId)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: .cellId)
        configure(cell, at: indexPath)
        return cell
    }

}

// MARK: - Table view delegate
extension EarthquakeListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: earthquakes[indexPath.row].url) else {
            // TODO: present error
            return
        }
        let detailViewController = SFSafariViewController(url: url)
        present(detailViewController, animated: true, completion: nil)
    }

}