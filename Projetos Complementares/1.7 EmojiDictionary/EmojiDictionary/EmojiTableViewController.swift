import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//import RxDataSources


class EmojiTableViewController: UIViewController, UITableViewDelegate{
    
    var disposeBag = DisposeBag()
    let viewModel = ViewModel()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Emoji>>(
                    configureCell: { (_, tableView, indexPath, element) in
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
                    cell.update(with: element)
                    return cell
                    },
                    titleForHeaderInSection: { dataSource, sectionIndex in
                        return dataSource[sectionIndex].model
                    }
                )
                dataSource.canEditRowAtIndexPath = { dataSource, indexPath  in
                    return true
                }
                
                viewModel.getUsers()
                    .bind(to: tableView.rx.items(dataSource: dataSource))
                    .disposed(by: disposeBag)
                
                tableView.rx
                    .itemSelected
                    .map { indexPath in
                        return (indexPath, dataSource[indexPath])
                    }
                    .subscribe(onNext: { pair in
                        print("Tapped \(pair.1) @ \(pair.0)")
                    })
                    .disposed(by: disposeBag)
        
//        let emoji = Observable.from([emojis])
//        emoji
//            .bind(to: tableView.rx.items) {
//                (tableView: UITableView, index: Int, element: Emoji) in
//                let indexPath =  IndexPath(item: index, section: 0)
//                let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
//                cell.update(with: element)
//                return cell
//            }
//            .disposed(by: disposeBag)

        // para habilitar o Delete
        tableView.rx
                    .itemDeleted
                    .subscribe(onNext: {
                        self.viewModel.removeItem(at: $0)
                        print($0)
                    })
                    .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
                    .disposed(by: disposeBag)
        
        tableView.rx
            // tratar um evento
            .modelSelected(Emoji.self)
            .subscribe(onNext:  { value in
                DefaultWireframe.presentAlert("Tapped `\(value)`")
            })
            .disposed(by: disposeBag)

        
        func showDetailsForEmoji(_ emoji: Emoji) {
           let storyboard = UIStoryboard(name: "TableViewWithEditingCommands", bundle: Bundle(identifier: "RxExample-iOS"))
           let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! AddEditEmojiTableViewController
           viewController.emoji = emoji
           self.navigationController?.pushViewController(viewController, animated: true)
       }

//        tableView.rx
//            /// acessory é o (i) da table aquele pra mais detalhes
//            .itemAccessoryButtonTapped
//            .subscribe(onNext: { indexPath in
//                DefaultWireframe.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
//                print(indexPath.row)
//            })
//            .disposed(by: disposeBag)

    }
    
 
    
//        navigationItem.leftBarButtonItem = editButtonItem
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 44.0
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
//
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            // Editing Emoji
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding Emoji
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditEmojiTableViewController,
            let emoji = sourceViewController.emoji else { return }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            viewModel.addItem(at: IndexPath(row: emojis.count, section: 0), emoji)
        }

        
    }
    
//    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return emojis.count
//        } else {
//            return 0
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //Step 1: Dequeue cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
//
//        //Step 2: Fetch model object to display
//        let emoji = emojis[indexPath.row]
//
//        //Step 3: Configure cell
//        cell.update(with: emoji)
//        cell.showsReorderControl = true
//
//        //Step 4: Return cell
//        return cell
//    }

    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            emojis.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let movedEmoji = emojis.remove(at: fromIndexPath.row)
//        emojis.insert(movedEmoji, at: to.row)
//    }
//
//
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }

}
//extension EmojiTableViewController: UITableViewDelegate {
//   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
//            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
//            return
//        }
//
//        return [deleteButton]
//    }
//}
