//
//  BalanceView.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class BalanceView: UIView {
    @IBOutlet weak var balanceTextButton: UIButton!

    private var viewModel: BalanceViewModel!
    
    func bind(viewModel: BalanceViewModel, disposeBag: DisposeBag) {
        self.viewModel = viewModel
        viewModel.balance.drive(onNext: { [weak self] in
            self?.balanceTextButton.setTitle($0, for: .normal)
        }).disposed(by: disposeBag)
    }

    @IBAction private func didTapPurseButton(_ sender: UIButton) {
        viewModel.purseAction()
    }

    @IBAction private func didTapBalanceTextButton(_ sender: UIButton) {
        viewModel.balanceAction()
    }
}
