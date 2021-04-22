import UIKit
import SafariServices
import MessageUI
import RxSwift
import RxCocoa
//import RxAlertController


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
  
    var disposeBag = DisposeBag()
    // criacao da chamada do UIAlertController
    

    var actionss: [UIAlertController.Action<UIImagePickerController.SourceType>] = [
    .action(title: "Galeria", style: .default, value: .photoLibrary),
  //  .action(title: "Camera", style: .default, value: .camera)
    ]
  
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  
  @IBAction func shareButtonTapped(_ sender: UIButton) {
    
    guard let image = imageView.image else { return }
    
    let activityController =
      UIActivityViewController(activityItems: [image],
                               applicationActivities: nil)
    activityController.popoverPresentationController?.sourceView = sender
    present(activityController, animated: true, completion: nil)
  }
  
  @IBAction func emailButtonTapped(_ sender: UIButton) {
    guard MFMailComposeViewController.canSendMail() else {
      print("Can not send mail")
      return
    }
    
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    
    mailComposer.setToRecipients(["example@example.com"])
    mailComposer.setSubject("Look at this")
    mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false)
    
    if let image = imageView.image, let jpegData =
        image.jpegData(compressionQuality: 0.9) {
      mailComposer.addAttachmentData(jpegData, mimeType:
                                      "image/jpeg", fileName: "photo.jpg")
    }
    
    present(mailComposer, animated: true, completion: nil)
    
  }
  
  
  override func viewDidLoad() {
    
    verifyAndAppendCamera()
    super.viewDidLoad()

    cameraButton.rx.tap.bind {
        // chamada do UIAlertController
      UIAlertController
        .present(in: self, title: "Selecione uma opção", message: nil , style: .actionSheet, actions: self.actionss)
        .bind { pickerType in
          return UIImagePickerController.rx.createWithParent(self) { picker in
            picker.sourceType = pickerType
            picker.allowsEditing = false
          }
          
          .flatMap {
            $0.rx.didFinishPickingMediaWithInfo
          }
          .take(1)
          .map { info in
            return info[.originalImage] as? UIImage
          }
          .bind(to: self.imageView.rx.image)
          .disposed(by: self.disposeBag)
        }.disposed(by: self.disposeBag)
    }.disposed(by: disposeBag)
  }

    func verifyAndAppendCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          actionss.append(.action(title: "Camera", style: .default, value: .camera))
        }
      }
  
  // MARK: - Delegates
  
  // Delegate para a ImagePickerController informar (delegar) a ação do usuário
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let selectedImage = info[.originalImage] as? UIImage else { return }
    
    imageView.image = selectedImage
    dismiss(animated: true, completion: nil)
    
  }
  
  // Para dispensar a system controller de email
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true, completion: nil)
  }
  
}

