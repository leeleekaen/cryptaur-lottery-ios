import RxSwift

extension UIBarButtonItem {
    
    class func badge(viewModel: BadgeViewModelProtocol, disposeBag: DisposeBag) -> UIBarButtonItem {
        let badgeView = BadgeView.loadFromNib()
        badgeView.bind(viewModel: viewModel, disposeBag: disposeBag)
        return UIBarButtonItem(customView: badgeView)
    }
    
    class func menu(target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: target, action: action)
    }
}
