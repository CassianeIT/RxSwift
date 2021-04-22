import Foundation
import UIKit
import RxSwift
import RxDataSources

class ViewModel {
  
let sectionListSubject = BehaviorSubject(value: [SectionModel<String, Emoji>]())
  
func tempUser() {
    sectionListSubject.onNext([
    SectionModel(model: "", items: emojis)])
      }
  
  func getUsers() -> Observable<[SectionModel<String, Emoji>]> {
    self.tempUser()
    return sectionListSubject.asObservable()
  }

  func removeItem(at indexPath: IndexPath) {
    guard var sections = try? sectionListSubject.value() else { return }
    
    // Get the current section from the indexPath
    var currentSection = sections[indexPath.section]
    
    // Remove the item from the section at the specified indexPath
    currentSection.items.remove(at: indexPath.row)
    
    // Update the section on section list
    sections[indexPath.section] = currentSection
    
    // Inform your subject with the new changes
    sectionListSubject.onNext(sections)
  }
    
    func addItem(at indexPath: IndexPath, _ emoji: Emoji) {
        guard var sections = try? sectionListSubject.value() else { return }
        
        // Get the current section from the indexPath
        var currentSection = sections[indexPath.section]
        
        // Remove the item from the section at the specified indexPath
        currentSection.items.append(emoji)
        
        // Update the section on section list
        sections[indexPath.section] = currentSection
        
        // Inform your subject with the new changes
        sectionListSubject.onNext(sections)
    }
}
