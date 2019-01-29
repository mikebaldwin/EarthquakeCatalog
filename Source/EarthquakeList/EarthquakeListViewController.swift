//
//  EarthquakeListViewController.swift
//  EarthquakeCatalog
//
//  Created by Michael Baldwin on 1/28/19.
//  Copyright © 2019 mikebaldwin.co. All rights reserved.
//

import UIKit
import SafariServices

// MARK: - Named Constants
private extension Int {
    static var tableSections = 1
}

private extension String {
    static var cellId = "EarthquakeCell"
}

// MARK: - Class declaration

class EarthquakeListViewController: UITableViewController {
    
    let earthquakeCatalog = EarthquakeCatalog()
    var earthquakes: [Earthquake] = []
    
    typealias localized = LocalizedStrings.EarthquakeList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = localized.title
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshEarthquakeData), for: .valueChanged)
        
        getEarthquakeDataForTableView(completion: nil)
    }
    
}

// MARK: - Networking
private extension EarthquakeListViewController {
    
    @objc
    func refreshEarthquakeData() {
        refreshControl?.beginRefreshing()
        getEarthquakeDataForTableView(completion: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    func getEarthquakeDataForTableView(completion: (() -> Void)?) {
        earthquakeCatalog.earthquakesFromLast30Days(
            // Refresh data and reload tableview
            success: { [weak self] earthquakes in
                self?.earthquakes = earthquakes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    if let completion = completion {
                        completion()
                    }
                }
            },
            // Display an alert to the user
            failure: { [weak self] error in
                debugPrint("API failure: \(error)")
                self?.presentDownloadFailedAlert()
            }
        )
    }
    
}

// MARK: - Helpers
private extension EarthquakeListViewController {
    
    func presentDownloadFailedAlert() {
        let alertController = UIAlertController(
            title: localized.errorAlertTitle,
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: localized.okButtonTitle,
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func timestamp(for earthquake: Earthquake) -> String {
        let timeInterval = TimeInterval(earthquake.timeZone)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let date = Date(timeIntervalSince1970: timeInterval)
        return formatter.string(from: date)
    }

}

// MARK: - Table view data source + helpers
extension EarthquakeListViewController {
    
    var emptyStateCell: UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = localized.downloadInProgressMessage
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
        cell.textLabel?.text = earthquake.location
        cell.detailTextLabel?.text = "M \(earthquake.magnitude) - \(timestamp(for: earthquake))"
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
