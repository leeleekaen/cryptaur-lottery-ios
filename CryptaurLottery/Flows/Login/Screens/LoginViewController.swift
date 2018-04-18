import UIKit

class LoginViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - IBAction
    @IBAction func loginButtonAction(_ sender: UIButton) {
        print("Login button tapped")
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
