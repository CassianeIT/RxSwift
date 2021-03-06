//
//  EmojiTableViewController.swift
//  RxEmojiDictionary
//
//  Created by Curitiba on 05/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class EmojiTableViewController: ViewController {
    
    @IBOutlet var tableView: UITableView!

    private var disposeBag = DisposeBag()
    
    
    var emojis: [Emoji] = [
       Emoji(symbol: "π", name: "Grinning Face",
       description: "A typical smiley face.", usage: "happiness"),
       Emoji(symbol: "π", name: "Confused Face",
       description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
       Emoji(symbol: "π", name: "Heart Eyes",
       description: "A smiley face with hearts for eyes.",
       usage: "love of something; attractive"),
       Emoji(symbol: "π§βπ»", name: "Developer",
       description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
       Emoji(symbol: "π’", name: "Turtle", description:
       "A cute turtle.", usage: "something slow"),
       Emoji(symbol: "π", name: "Elephant", description:
       "A gray elephant.", usage: "good memory"),
       Emoji(symbol: "π", name: "Spaghetti",
       description: "A plate of spaghetti.", usage: "spaghetti"),
       Emoji(symbol: "π²", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
       Emoji(symbol: "βΊοΈ", name: "Tent", description: "A small tent.", usage: "camping"),
       Emoji(symbol: "π", name: "Stack of Books",
       description: "Three colored books stacked on each other.",
       usage: "homework, studying"),
       Emoji(symbol: "π", name: "Broken Heart",
       description: "A red, broken heart.", usage: "extreme sadness"), Emoji(symbol: "π€", name: "Snore",
       description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
       Emoji(symbol: "π", name: "Checkered Flag",
       description: "A black-and-white checkered flag.", usage: "completion")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTableView()

    }

    func bindTableView() {
        let emoji = Observable.from([emojis])
        
        emoji
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: Emoji) in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
                cell.textLabel?.text = "\(element.symbol) - \(element.name)"
                cell.detailTextLabel?.text = "\(element.description)"
                return cell
            }
            .disposed(by: disposeBag)
        
    }
}
