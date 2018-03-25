//
//  ViewController.swift
//  CurrencyRates
//
//  Created by Shantanu Khanwalkar on 22/03/18.
//  Copyright © 2018 Shantanu Khanwalkar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblCurrencyRates: UITableView!
    
    var oldRates: Array<Rate> = Array()
    var newRates: Array<Rate> = Array()
    let repeatingTimer = RepeatingTimer()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl.beginRefreshing()
        self.repeatingTimer.eventHandler = self.getLatestCurrencyRates
        self.repeatingTimer.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setting up the table view
    func setupTableView() {
        // Estimated row height of the cell
        tblCurrencyRates.estimatedRowHeight = 66.0
        // Using automatic cell height calculation
        tblCurrencyRates.rowHeight = UITableViewAutomaticDimension
        // Setting the table footer view so that empty cells do not show as separator lines
        tblCurrencyRates.tableFooterView = UIView(frame: CGRect.zero)
        // Registering the reusable cell
        tblCurrencyRates.register(UINib(nibName: CellNames.currencyCell, bundle: nil), forCellReuseIdentifier: CellNames.currencyCell)
        // Adding the refresh control to the table view
        tblCurrencyRates.addSubview(refreshControl)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Will only show a table view cell if the array has some value
        if self.newRates.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oldRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.currencyCell, for: indexPath) as! CurrencyRateTableViewCell
        
        let oldRate = self.oldRates[indexPath.row]
        let newRate = self.newRates[indexPath.row]
        
        // Setting the symbol and current price
        cell.lblSymbol.text = newRate.symbol
        cell.lblRate.text = "\(newRate.price)"
        
        // Checking if the latest price is greater than or equal to the old price and setting the label color accordingly
        if newRate.price >= oldRate.price {
            cell.lblRate.textColor = UIColor.green
        } else if newRate.price < oldRate.price {
            cell.lblRate.textColor = UIColor.red
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Handling the refresh control action
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getLatestCurrencyRates()
    }
    
    // MARK: - API
    
    func getLatestCurrencyRates() {
        // Using the network manager class to make the API call
        NetworkManager.shared.makeServerCall(toAPI: API.getCurrencyApi) { (responseData: DataResponse<Any>, isSuccess: Bool, errorMessage: String) in
            
            // dismiss the refresh control if visible
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            if isSuccess {
                // decoder to decode the JSON response
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Rates.self, from: responseData.data!)
                    if response.rates.count > 0 {
                        // if the initial arrays are nil, then initializing them both with the response received
                        if self.oldRates.count == 0 && self.newRates.count == 0 {
                            self.oldRates = response.rates
                            self.newRates = response.rates
                        } else {
                            // if arrays have values, then setting the array values so they can be compared
                            self.oldRates = self.newRates
                            self.newRates = response.rates
                        }
                        DispatchQueue.main.async {
                            self.tblCurrencyRates.reloadData()
                        }
                    }
                } catch {
                    print("error trying to convert data to JSON")
                }
                
            } else {
                print(errorMessage)
                // server error
            }
        }
    }
}

