//
//  LocalizedStrings.swift
//  EarthquakeCatalog
//
//  Created by Michael Baldwin on 1/28/19.
//  Copyright © 2019 mikebaldwin.co. All rights reserved.
//

import Foundation

enum LocalizedStrings {
    
    enum EarthquakeList {
        static var title = NSLocalizedString("earthquakeListTitle", comment: "Title for EarthquakeListViewController")
        
        static var errorAlertTitle = NSLocalizedString("downloadErrorAlertTitle", comment: "Title for alert notifying user of download error")
        static var okButtonTitle = NSLocalizedString("okButtonTitle", comment: "Ok button title")
        
        static var downloadInProgressMessage = NSLocalizedString("downloadingMessage", comment: "Message to notify user that earthquake data is being downloaded")
    }

}
