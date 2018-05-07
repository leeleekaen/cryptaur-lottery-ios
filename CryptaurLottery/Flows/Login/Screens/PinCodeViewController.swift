import UIKit

class PinCodeViewController: BaseViewController, FlowController {
    
    var loginCompletion: (() -> ())? {
        didSet {
            viewModel.loginCompletion = loginCompletion
        }
    }
    func setFlowCompletion(_ completion: @escaping () -> ()) {
        loginCompletion = completion
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var pinCodePageControl: UIPageControl! {
        didSet {
            pinCodePageControl.pageIndicatorTintColor = UIColor.blueGrey
            pinCodePageControl.numberOfPages = pinCodeCount
        }
    }
    
    // MARK: - IBAction
    @IBAction func enterByLogindAction(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.toLogin.rawValue, sender: nil)
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        
        guard let number = sender.titleLabel?.text else {
            return
        }
        pinCode += number
    }
    
    @IBAction func exitAction(_ sender: UIButton) {
        print("Exit button tapped")
    }
    
    @IBAction func backspaceAction(_ sender: UIButton) {
        
        if !pinCode.isEmpty {
            pinCode.removeLast()
        }
    }
    
    // MARK: - Dependency
    let viewModel = PinCodeViewModel()
    
    // MARK: - Private properties
    let pinCodeCount = 4
    var pinCode = "" {
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
                viewModel.submit(pincode: pinCode)
            case 5:
                pinCode.removeLast()
            default:
                fatalError("unespected pin code")
            }
        }
    }
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bind(viewModel)
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

// MARK: - Segue
extension PinCodeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.toLogin.rawValue:
            print("Go to login screen")
            if let destination = segue.destination as? LoginViewController {
                destination.loginCompletion = loginCompletion
            }
        default:
            fatalError("Unexpected segue")
        }
    }
}
