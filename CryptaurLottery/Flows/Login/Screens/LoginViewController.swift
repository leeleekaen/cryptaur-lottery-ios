import UIKit
import RxSwift
import RxCocoa

protocol FlowController {
    func setFlowCompletion(_ completion: @escaping () -> ())
}

final class LoginViewController: BaseViewController, FlowController {
    private let viewModel: LoginViewModel! = LoginViewModel()
    
    func setFlowCompletion(_ completion: @escaping () -> ()) {
        viewModel.loginCompletion = completion
    }
    
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
