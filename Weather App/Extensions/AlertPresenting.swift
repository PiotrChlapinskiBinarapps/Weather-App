import Foundation
import UIKit

public protocol ViewController: AnyObject {
    var viewController: UIViewController { get }
}

protocol AlertPresenting {
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction])
    func dismiss()
}

extension AlertPresenting where Self: UIViewController {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func presentAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        actions.forEach { alertController.addAction($0) }

        present(alertController, animated: true, completion: nil)
    }
}
