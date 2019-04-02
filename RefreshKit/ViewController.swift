//
//  ViewController.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/22.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import UIKit
import MJRefresh



class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    var count = 0//54

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        
        

        tableView.rf.config.headerTime = .always
        tableView.rf.config.footerTime = .successOnce
        
        tableView.rf.config.headerView = DefaultHeaderContainer()
        tableView.rf.config.headerBlock = {[weak self] in
            guard let `self` = self else{return}
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                self.tableView.rf.config.headerEndRefreshingWithSuccess()
                self.count = 100
                self.tableView.reloadData()
            })
        }
        
        tableView.rf.config.footerView = DefaultFooterContainer()
        tableView.rf.config.footerBlock = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                if self.count > 102{
                    self.tableView.rf.config.footerEndRefreshingWithEmpty()
                } else{
                    self.tableView.rf.config.footerEndRefreshingWithSuccess()
                }
                self.count = self.count + 1
                self.tableView.reloadData()
            })
        }
        
        self.tableView.rf.config.headerBeginRefreshing()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.tableView.contentSize)
        print(self.tableView.contentInset)
        print(self.tableView.contentOffset)
    }


}


extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
