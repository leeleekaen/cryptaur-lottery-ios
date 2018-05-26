import UIKit
import RxSwift
import RxCocoa

protocol BarButtonItemTargetActions {
    func didTapMenuBarButtonItem()
    func didTapBadgeButton()
}

protocol CoordinatorDelegate: class {
    func transition(class: BaseViewController, type: TransistionType)
}

class BaseViewController: UIViewController, BarButtonItemTargetActions, ServiceErrorAlertPresenter {
    
    weak var delegate: CoordinatorDelegate?
    
//    func transitionValue(transistionType: TransistionType) {
//        delegate?.transition(class: self, type: transistionType)
//    }
    
    //MARK: Transition
    var navigation: BaseNavigationController?
    
    func addVcNavigationController(vc: UIViewController) {
        navigation = BaseNavigationController()
        navigation?.viewControllers = [vc]
    }
    
    func transition(type: TransistionType) {
        switch type {
        case .push(let controller):
            self.navigationController?.pushViewController(controller, animated: true)
        case .present(let controller):
            self.present(controller, animated: true, completion: nil)
        case .setRootWindow(let controller):
            UIApplication.shared.keyWindow?.rootViewController = controller
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .dismiss:
            self.dismiss(animated: true, completion: nil)
        }
    }

    final let disposeBag = DisposeBag()
    
    // MARK: - Navigation
    var badgeActionCompletion: (() -> ())?
    var menuActionCompletion: ((_ viewController: BaseViewController) -> ())?

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
            self?.didTapBadgeButton()
        }
        return .badge(viewModel: viewModel, disposeBag: disposeBag)
    }
    
    func didTapMenuBarButtonItem() {
        //menuActionCompletion?(self)
        //TAsk menuStoryboard
        let menuStoryboard = UIStoryboard(name: "MenuStory", bundle: nil)
        let menuViewController = MenuViewController.controllerInStoryboard(menuStoryboard)
        self.transition(type: TransistionType.push(controller: menuViewController))
    }
    
    func didTapBadgeButton() {
        badgeActionCompletion?()
    }
    
    func present(message: String) {
        
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
