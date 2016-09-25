//
//  MasterViewController.swift
//  Traildevils Mapbox PoC
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    
    private let dataSource = ExampleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RootViewCell else {fatalError()}
        
        let experiment = dataSource.examples[(indexPath as NSIndexPath).row]
        cell.titleLabel.text  = experiment.title
        cell.detailLabel.text = experiment.detail
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = dataSource.examples[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(sample.controller(), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
