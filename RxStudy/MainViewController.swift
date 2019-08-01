//
//  ViewController.swift
//  RxStudy
//
//  Created by Milkyo on 31/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var mainOwnView: UITableView {
        return self.view as! UITableView
    }

    override func loadView() {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        view.tableFooterView = UIView()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Start! RxSwift"
        self.mainOwnView.dataSource = self
        self.mainOwnView.delegate = self
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)

        cell.textLabel?.text = "Observable"

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextViewController = DownloadImageView()
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
