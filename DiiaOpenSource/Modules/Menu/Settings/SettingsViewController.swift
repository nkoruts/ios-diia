import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol SettingsView: BaseView { }

final class SettingsViewController: UIViewController, SettingsView, Storyboarded {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

	// MARK: - Properties
	var presenter: SettingsAction!

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    private func initialSetup() {
        titleLabel.font = FontBook.smallHeadingFont
        titleLabel.text = R.Strings.menu_title_settings.localized()
        
        tableView.register(TitleTableCell.nib, forCellReuseIdentifier: TitleTableCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Private Methods
    @IBAction private func backButtonTapped() {
        presenter.onBackTapped()
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingVM = presenter.item(at: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableCell.reuseID, for: indexPath) as? TitleTableCell
        else { return UITableViewCell() }
        
        cell.configure(viewModel: settingVM)

        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
