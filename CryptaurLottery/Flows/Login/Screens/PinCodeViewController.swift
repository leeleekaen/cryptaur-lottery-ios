import UIKit

class PinCodeViewController: BaseViewController {
    
    // MARK: - Public properties
    var pincodeCompletion: ((String) -> ())?
    var enterByLoginCompletion: (() -> ())?
    var exitButtonCompletion: (() -> ())?
    
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
    
    // MARK: - IBAction
    @IBAction func enterByLogindAction(_ sender: UIButton) {
        enterByLoginCompletion?()
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        
        guard let number = sender.titleLabel?.text else {
            return
        }
        pinCode += number
    }
    
    @IBAction func exitAction(_ sender: UIButton) {
        exitButtonCompletion?()
        print("EXit button pressed")
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
                pincodeCompletion?(pinCode)
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
        configureSubviews()
        bind(viewModel)
    }
    
    // MARK: - Public methods
    func configureGetPIN() {
        enterByLoginButton.isHidden = true
    }
    func configureLoginByPin() {
        enterByLoginButton.isHidden = false
    }
    func reset() {
        pinCode = ""
    }
}

// MARK: - Private methods
private extension PinCodeViewController {
    
    func configureSubviews() {
        pinCode = ""
    }
}

// MARK: - Embedded
private extension PinCodeViewController {
    
    enum Segue: String {
        case toLogin
    }
    
    enum PinCodeState {
        case notStarted
        case process(String)
    }
}
