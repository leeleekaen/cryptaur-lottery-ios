import UIKit
import RxSwift
import RxCocoa

protocol BarButtonItemTargetActions {
    func didTapMenuBarButtonItem()
    func didTapBadgeButton()
}

class BaseViewController: UIViewController, BarButtonItemTargetActions, ServiceErrorAlertPresenter {
    
    final let disposeBag = DisposeBag()
    let balanceViewModel = BalanceViewModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
    }
    
    final func bind(_ viewModel: BaseViewModel) {
        viewModel.error.drive(onNext: { [weak self] error in
            guard let error = error as? ServiceError else {
                return
            }
            self?.present(error: error)
        }).disposed(by: disposeBag)
    }
    
    final func configureNavigationItem(showBalance: Bool, color: UIColor = .white) {
        if showBalance {
            self.navigationItem.titleView = createBalanceView(color: color)
        }
        self.navigationItem.rightBarButtonItems = [createMenuBarButtonItem(), createBadgeBarButtonItem()]
    }
    
    private func createBalanceView(color: UIColor) -> BalanceView? {
        let balanceView = BalanceView.loadFromNib()
        balanceView.setColor(color)
        balanceView.bind(viewModel: balanceViewModel, disposeBag: disposeBag)
        return balanceView
    }
    
    private func createMenuBarButtonItem() -> UIBarButtonItem {
        return .menu(target: self, action: #selector(didTapMenuBarButtonItem(_:)))
    }
    
    @objc private func didTapMenuBarButtonItem(_ sender: UIBarButtonItem) {
        didTapMenuBarButtonItem()
    }
    
    private func createBadgeBarButtonItem() -> UIBarButtonItem {
        balanceViewModel.badgeActionCompletion = { [weak self] in
            let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
            UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
        }
        return .badge(viewModel: balanceViewModel, disposeBag: disposeBag)
    }
    
    func didTapMenuBarButtonItem() {
        let controller = MenuViewController.controllerFromStoryboard(StoryboardType.menuStory.name)
        UIApplication.sharedCoordinator.transition(type: .present(controller: controller, completion: nil))
        controller.bind(viewModel: balanceViewModel, disposeBag: disposeBag)
    }
    
    func didTapBadgeButton() {
        let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
        UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
    }
    
    func presentAlert(message: String) {
        
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
