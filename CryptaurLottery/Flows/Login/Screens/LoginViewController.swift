import UIKit
import RxSwift
import RxCocoa
import KeychainSwift

protocol FlowController {
    func setFlowCompletion(_ completion: @escaping () -> ())
}

final class LoginViewController: BaseViewController {
    
    private let viewModel: LoginViewModel! = LoginViewModel()
    private let keychain = KeychainSwift()
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    private var login: Driver<String?> {
        return loginTextField.rx.value.asDriver(onErrorJustReturn: nil)
    }
    private var password: Driver<String?> {
        return passwordTextField.rx.value.asDriver(onErrorJustReturn: nil)
    }

    // MARK: - IBAction
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let username = loginTextField.text,
            let password = passwordTextField.text else {
                return
        }
        viewModel.submit()
    }

    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        print("Forgot password button tapped")
    }

    @IBAction func endInputText(_ sender: UITextField) {
        
    }

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        viewModel.delegate = self
        
        if let username = keychain.get(PlayersKey.username) {
            loginTextField.text = username
            loginTextField.becomeFirstResponder()
        }
    }
    
    override func bind() {
        bind(viewModel)

        login.drive(onNext: { [weak viewModel = self.viewModel] in
            viewModel?.usernameRelay.accept($0)
        }).disposed(by: disposeBag)
        
        password.drive(onNext: { [weak viewModel = self.viewModel] in
            viewModel?.passwordRelay.accept($0)
        }).disposed(by: disposeBag)
        
        viewModel.canSubmit.drive(onNext: { [weak self] in
            self?.submitButton.isEnabled = $0
        }).disposed(by: disposeBag)
    }
}

// MARK: LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func showAlertWith(message: String) {
        presentAlert(message: message)
    }
}

// MARK: - Private methods
private extension LoginViewController {

    func configureSubviews() {

        let textFieldAttributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: UIColor.blueGrey,
            .font: UIFont.openSansSemibold14
        ]

        loginTextField.attributedPlaceholder = NSAttributedString(string: "LOGIN",
                                                                  attributes: textFieldAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD",
                                                                     attributes: textFieldAttributes)
    }
}
