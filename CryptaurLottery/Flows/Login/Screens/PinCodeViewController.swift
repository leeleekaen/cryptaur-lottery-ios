import UIKit

class PinCodeViewController: BaseViewController, FlowController {
    
    private var flowCompletion: (() -> ())?
    func setFlowCompletion(_ completion: @escaping () -> ()) {
        flowCompletion = completion
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
        switch pinCodeState {
        case .notStarted:
            pinCodeState = .process(0)
        case let .process(index):
            if index < pinCodeCount - 1 {
                pinCodeState = .process(index + 1)
            } else {
                break
            }
        }
    }
    
    @IBAction func exitAction(_ sender: UIButton) {
        print("Exit button tapped")
    }
    
    @IBAction func backspaceAction(_ sender: UIButton) {
        switch pinCodeState {
        case let .process(index):
            if index == 0 {
                pinCodeState = .notStarted
            } else {
                pinCodeState = .process(index - 1)
            }
        case .notStarted:
            break
        }
    }
    
    // MARK: - Dependency
    let viewModel = PinCodeViewModel()
    
    // MARK: - Private properties
    let pinCodeCount = 4
    private var pinCodeState: PinCodeState = .notStarted {
        didSet {
            switch pinCodeState {
            case .notStarted:
                pinCodePageControl.currentPage = 1
                pinCodePageControl.currentPageIndicatorTintColor = UIColor.blueGrey
            case let .process(index):
                pinCodePageControl.currentPage = index
                pinCodePageControl.currentPageIndicatorTintColor = UIColor.hotPink
            }
        }
    }
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        viewModel.submit()
    }
}

// MARK: - Private methods
private extension PinCodeViewController {
    
    func configureSubviews() {
        pinCodeState = .notStarted
    }
}

// MARK: - Embedded
private extension PinCodeViewController {
    
    enum Segue: String {
        case toLogin
    }
    
    enum PinCodeState {
        case notStarted
        case process(Int)
    }
}

// MARK: - Segue
extension PinCodeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.toLogin.rawValue:
            print("Go to login screen")
        default:
            fatalError("Unexpected segue")
        }
    }
}
