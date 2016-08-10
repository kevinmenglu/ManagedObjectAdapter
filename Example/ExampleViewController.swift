//
//  ExampleViewController.swift
//  Example
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import ManagedObjectAdapter

class ExampleViewController: UITableViewController {
    var organizations = [Organization]()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CoreDataManager.coreDataStorePath)
        setupUI()
        loadData()

        let org = organizations.first
        let moOrg = org?.toManagedObject(CoreDataManager.context) as? _Organization
        print("\n********** Transferred ManagedObject **********")
        print(moOrg)

//        let context = CoreDataManager.context
//        let fetchRequest = NSFetchRequest()
//        let entity = NSEntityDescription.entityForName(Organization.managedObjectEntityName(), inManagedObjectContext: context)!
//        fetchRequest.entity = entity
//        do {
//            let organization = try context.executeFetchRequest(fetchRequest).first as? ManagedObject
//            print("\n********** Local ManagedObject **********")
//            print(organization)
//        } catch {
//
//        }
    }

    // MARK: - Helper
    private func setupUI() {
        navigationItem.title = "Example"
        tableView.tableFooterView = UIView()
    }

    private func loadData() {
        guard let path = NSBundle(identifier: "Teambition.ManagedObjectAdapter.Example")?.pathForResource("organizations", ofType: "json") ?? NSBundle.mainBundle().pathForResource("organizations", ofType: "json") else {
            return
        }
        print(path)

        guard let jsonData = NSData(contentsOfFile: path) else {
            return
        }
        guard let json = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [AnyObject] else {
            return
        }

        guard let organizations = Mapper<Organization>().mapArray(json) else {
            return
        }
        self.organizations = organizations
        tableView.reloadData()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("OrganizationCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "OrganizationCell")
        }
        let organization = organizations[indexPath.row]
        cell?.textLabel?.text = organization.name
        cell?.detailTextLabel?.text = String(organization.projects?.count ?? 0)
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let projectsViewController = ProjectsViewController()
        navigationController?.pushViewController(projectsViewController, animated: true)
    }
}
