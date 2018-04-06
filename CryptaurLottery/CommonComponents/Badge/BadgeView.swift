//
//  BadgeView.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 06.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class BadgeView: UIView {
    private var viewModel: BadgeViewModelProtocol!
    
    @IBOutlet private weak var badgeLabel: UILabel!
    
    func bind(viewModel: BadgeViewModelProtocol, disposeBag: DisposeBag) {
        self.viewModel = viewModel
        viewModel.badge.drive(onNext: { [weak self] in
            self?.badgeLabel.text = $0
        }).disposed(by: disposeBag)
    }
    
    @IBAction private func didTapBadgeButton(_ sender: UIButton) {
        viewModel.badgeAction()
    }
}
