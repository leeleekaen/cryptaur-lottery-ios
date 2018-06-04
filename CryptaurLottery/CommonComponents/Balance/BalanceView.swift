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
    
    private var viewModel: BalanceViewModelProtocol!

    @IBOutlet private weak var balanceTextButton: UIButton!
    @IBOutlet private weak var purseButton: UIButton!
    
    func setColor(_ color: UIColor) {
        balanceTextButton.setTitleColor(color, for: .normal)
        if color == .white {
            purseButton.setImage(#imageLiteral(resourceName: "purse"), for: .normal)
        } else {
            purseButton.setImage(#imageLiteral(resourceName: "purse-dark"), for: .normal)
        }
    }
    
    func bind(viewModel: BalanceViewModelProtocol, disposeBag: DisposeBag) {
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
