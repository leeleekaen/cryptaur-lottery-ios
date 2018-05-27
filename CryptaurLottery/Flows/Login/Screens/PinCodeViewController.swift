import UIKit

class PinCodeViewController: BaseViewController {
    
    enum Flow {
        case setPin
        case confirmPin(previous: String)
        case askPin
    }
    
    // MARK: - Public properties
    var pincodeCompletion: ((String) -> ())?
    
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
        UIApplication.sharedCoordinator.showUnauth()
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
        bind(viewModel)
    }
    
    // MARK: - Public methods
    func configureGetPIN() {
        enterByLoginButton.isHidden = true
    }
    
    func configureLoginByPin() {
        enterByLoginButton.isHidden = false
    }
    
    func showNext() {
        switch flow {
        case .askPin:
            viewModel.submit(pincode: pinCode)
        case .setPin:
            let confirm = PinCodeViewController.controllerFromStoryboard(StoryboardType.login.name)
            confirm.flow = .confirmPin(previous: pinCode)
            UIApplication.sharedCoordinator.transition(type: .present(controller: confirm, completion: nil))
        case .confirmPin(let previous):
            guard previous == pinCode else {
                present(message: "Pin codes are not equals")
                return
            }
            UIApplication.sharedCoordinator.showAuth()
        }
    }
    
    func reset() {
        if pinCode.count == 4 {
            viewModel.submit(pincode: pinCode)
        }
        pinCode = ""
    }
}
