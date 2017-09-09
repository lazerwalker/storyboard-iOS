import UIKit

class ProjectListViewController : UITableViewController {
    let projects:[String]
    let handler:(String?) -> Void

    required init(projects:[String], handler:@escaping ((String?) -> Void)) {
        self.projects = projects
        self.handler = handler

        super.init(style: .plain)

        self.title = "Projects"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ProjectListViewController.cancel))
    }

    required init?(coder aDecoder: NSCoder) {
        projects = []
        handler = { _ in }
        super.init(coder: aDecoder)
    }

    //-

    func cancel() {
        self.handler(nil)
    }

    //- UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let project = projects[indexPath.row]
        self.handler(project)
    }

    //- UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = projects[indexPath.row]
        return cell
    }

}
