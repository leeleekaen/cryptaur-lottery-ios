//
//  ServiceErrorAlertPresenter.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceErrorAlertPresenter: class {
    func present(error: ServiceError)
}

fileprivate struct QueueHolder {
    private init() {}
    static let instance = QueueHolder()
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

extension ServiceErrorAlertPresenter where Self: UIViewController {
    private var isPresenting: Bool {
        get {
            return QueueHolder.instance.operationQueue.isSuspended
        }
        set {
            QueueHolder.instance.operationQueue.isSuspended = newValue
        }
    }

    func present(error: ServiceError) {
        guard !isPresenting else {
            enqueue { [weak self] in
                self?.present(error: error)
            }
            return
        }
        isPresenting = true
        
        var alertTitle = ""
        var alertMessage = ""
        
        switch error {
        case .api(let code, let message):
            alertTitle = code
            if message != nil {
                alertMessage = message!
            }
        case .deserializationFailure:
            alertTitle = "deserializationFailure"
        case .unknown( _):
            alertTitle = "unknownError"
        default:
            return
        }
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: actionDismiss))
        present(alertController, animated: true, completion: nil)

    }

    private func actionDismiss(_ sender: UIAlertAction) {
        isPresenting = false
    }

    private func enqueue(_ action: @escaping () -> ()) {
        QueueHolder.instance.operationQueue.addOperation {
            DispatchQueue.main.async {
                action()
            }
        }
    }
}
