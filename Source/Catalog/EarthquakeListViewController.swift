//
//  EarthquakeListViewController.swift
//  EarthquakeCatalog
//
//  Created by Michael Baldwin on 1/28/19.
//  Copyright © 2019 mikebaldwin.co. All rights reserved.
//

import UIKit

class EarthquakeListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Table view data source
extension EarthquakeListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

}
