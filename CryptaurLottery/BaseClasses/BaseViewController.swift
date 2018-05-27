import UIKit
import RxSwift
import RxCocoa

protocol BarButtonItemTargetActions {
    func didTapMenuBarButtonItem()
    func didTapBadgeButton()
}

class BaseViewController: UIViewController, BarButtonItemTargetActions, ServiceErrorAlertPresenter {
    
    final let disposeBag = DisposeBag()

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
            navigationItem.titleView = createBalanceView(color: color)
        }
        navigationItem.rightBarButtonItems = [createMenuBarButtonItem(), createBadgeBarButtonItem()]
    }
    
    
    
    private func createBalanceView(color: UIColor) -> BalanceView? {
        let balanceView = BalanceView.loadFromNib()
        balanceView.setColor(color)
        balanceView.bind(viewModel: BalanceViewModel(), disposeBag: disposeBag)
        return balanceView
    }
    
    private func createMenuBarButtonItem() -> UIBarButtonItem {
        return .menu(target: self, action: #selector(didTapMenuBarButtonItem(_:)))
    }
    
    @objc private func didTapMenuBarButtonItem(_ sender: UIBarButtonItem) {
        didTapMenuBarButtonItem()
    }
    
    private func createBadgeBarButtonItem() -> UIBarButtonItem {
        let viewModel = BalanceViewModel()
        viewModel.badgeActionCompletion = { [weak self] in
            let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
            UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
        }
        return .badge(viewModel: viewModel, disposeBag: disposeBag)
    }
    
    func didTapMenuBarButtonItem() {
        let controller = MenuViewController.controllerFromStoryboard(StoryboardType.menuStory.name)
        UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
    }
    
    func didTapBadgeButton() {
        let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
        UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
    }
    
    func present(message: String) {
        
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
