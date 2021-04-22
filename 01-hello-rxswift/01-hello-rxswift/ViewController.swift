//
//  ViewController.swift
//  01-hello-rxswift
//
//  Created by Curitiba on 01/04/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = Observable.of("Hello")
    }


}

