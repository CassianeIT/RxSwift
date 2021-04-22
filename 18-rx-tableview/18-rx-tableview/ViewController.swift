//
//  ViewController.swift
//  18-rx-tableview
//
//  Created by Curitiba on 05/04/21.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindTableView()
        
        tableView.rx
         .modelSelected(String.self)
         .subscribe(onNext: { model in
         print("\(model) was selected")
         })
         .disposed(by: disposeBag)
    }
    
    func bindTableView() {
        let cities = Observable.of(["Lisbon", "Copenhagen", "London", "Madrid", "Vienna"])
        
        cities
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
        
    }
    
}

