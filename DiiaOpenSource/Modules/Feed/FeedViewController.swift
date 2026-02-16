
import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol FeedView: BaseView {
    func configure(with model: DSConstructorModel)
}

final class FeedViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var topNavigationView: TopNavigationBigView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bodyGroupStackView: UIStackView!
    
    // MARK: - Properties
    var presenter: FeedAction!
    
    // MARK: - Init
    init() {
        super.init(nibName: FeedViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.configureView()
        initialSetup()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .clear
    }
}

// MARK: - View logic
extension FeedViewController: FeedView {
    func configure(with model: DSConstructorModel) {
        let topGroupTitle = model.topGroup.compactMap { item in
            if let topGroup: DSTopGroupOrg = item.parseValue(forKey: "topGroupOrg") {
                return topGroup.titleGroupMlc
            }
            return nil
        }.first
        topNavigationView.isHidden = topGroupTitle == nil
        if let topGroup = topGroupTitle {
            topNavigationView.configure(
                viewModel: TopNavigationBigViewModel(title: topGroup.heroText)
            )
        }
        
        bodyGroupStackView.safelyRemoveArrangedSubviews()
        bodyGroupStackView.addArrangedSubviews(
            DSViewFabric.instance.bodyViews(for: model) { [weak self] event in
                self?.presenter.handleEvent(event: event)
            }
        )
    }
}
