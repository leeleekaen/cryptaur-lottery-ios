import UIKit

class PinCodeViewController: BaseViewController {
    
    enum Flow {
        case setPin
        case confirmPin(previous: String)
        case askPin
    }
    
    enum ExitType {
        case changePin
        case defaultPin
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var pinCodePageControl: UIPageControl! {
        didSet {
            pinCodePageControl.pageIndicatorTintColor = UIColor.blueGrey
            pinCodePageControl.numberOfPages = pinCodeCount
        }
    }
    @IBOutlet weak var enterByLoginButton: UIButton!
    
    // MARK: - Dependency
    let viewModel = PinCodeViewModel()
    var flow: Flow = .askPin
    var exitTypeValue: ExitType = .defaultPin
    
    // MARK: - IBAction
    @IBAction func enterByLogindAction(_ sender: UIButton) {
        UIApplication.sharedCoordinator.showUnauth()
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        
        guard let number = sender.titleLabel?.text else {
            return
        }
        pinCode += number
    }
    
    @IBAction func exitAction(_ sender: UIButton) {
        switch exitTypeValue {
        case .changePin:
            UIApplication.sharedCoordinator.showAuth()
        case .defaultPin:
            UIApplication.sharedCoordinator.showUnauth()
        }
    }
    
    @IBAction func backspaceAction(_ sender: UIButton) {
        if !pinCode.isEmpty {
            pinCode.removeLast()
        }
    }
    
    // MARK: - Private properties
    private let pinCodeCount = 4
    private var pinCode = "" {
        didSet {
            switch pinCode.count {
            case 0:
                pinCodePageControl.currentPage = 1
                pinCodePageControl.currentPageIndicatorTintColor = UIColor.blueGrey
            case 1...3:
                pinCodePageControl.currentPage = pinCode.count - 1
                pinCodePageControl.currentPageIndicatorTintColor = UIColor.hotPink
            case 4:
                pinCodePageControl.currentPage = pinCode.count - 1
                showNext()
            case 5:
                pinCode.removeLast()
            default:
                fatalError("unexpected pin code")
            }
        }
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlertMessage()
        bind(viewModel)
    }
    
    //MARK: loadView
    func showAlertMessage() {
        switch flow {
        case .setPin:
            self.presentAlert(message: "Set PIN code")
        case .confirmPin( _):
            self.presentAlert(message: "Set PIN code again")
        default:
            break
        }
    }
    
    // MARK: - Public methods
    func configureGetPIN() {
        enterByLoginButton.isHidden = true
    }
    
    func configureLoginByPin() {
        enterByLoginButton.isHidden = false
    }
    
    // MARK: - Private methods
   private func configureConfirmPin() {
        let confirm = PinCodeViewController.controllerFromStoryboard(StoryboardType.login.name)
        confirm.flow = .confirmPin(previous: pinCode)
        if exitTypeValue == ExitType.changePin {
            confirm.exitTypeValue = .changePin
        }
        reset()
        UIApplication.sharedCoordinator.transition(type: .present(controller: confirm, completion: nil))
    }
    
    private func showNext() {
        switch flow {
        case .askPin:
            viewModel.submit(pincode: pinCode)
        case .setPin:
            configureConfirmPin()
        case .confirmPin(let previous):
            guard previous == pinCode else {
                presentAlert(message: "Pin codes are not equals")
                reset()
                return
            }
            viewModel.registerPin(pincode: pinCode)
        }
    }
    
    func reset() {
        pinCode = ""
    }
}
