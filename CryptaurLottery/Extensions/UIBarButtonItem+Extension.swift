import RxSwift

extension UIBarButtonItem {
    
    class func badge(viewModel: BadgeViewModelProtocol, disposeBag: DisposeBag) -> UIBarButtonItem {
        let badgeView = BadgeView.loadFromNib()
        badgeView.bind(viewModel: viewModel, disposeBag: disposeBag)
        return UIBarButtonItem(customView: badgeView)
    }
    
    class func menu(target: Any, action: Selector) -> UIBarButtonItem {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        menuBtn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuBtn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: menuBtn)
    }
}
