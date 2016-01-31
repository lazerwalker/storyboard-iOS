import UIKit

class ProjectListViewController : UITableViewController {
    let projects:[String]
    let handler:(String?) -> Void

    required init(projects:[String], handler:((String?) -> Void)) {
        self.projects = projects
        self.handler = handler

        super.init(style: .Plain)

        self.title = "Projects"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let project = projects[indexPath.row]
        self.handler(project)
    }

    //- UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = projects[indexPath.row]
        return cell
    }

}
