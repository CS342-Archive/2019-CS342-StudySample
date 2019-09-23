//
//  ActivitiesTableViewController.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit
import ResearchKit

class ActivitiesTableViewController: UITableViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dateLabel.text = Date().fullFormattedString()
    }
}

extension ActivitiesTableViewController {
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return ActivityTableItem.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standardTableCell", for: indexPath)
        
        if let activity = ActivityTableItem(rawValue: (indexPath as NSIndexPath).row) {
            cell.textLabel?.text = activity.title
            cell.detailTextLabel?.text = activity.subtitle
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let activity = ActivityTableItem(rawValue: (indexPath as NSIndexPath).row) else { return }
        
        let taskViewController: ORKTaskViewController
        switch activity {
        case .survey:
            taskViewController = ORKTaskViewController(task: StudyTasks.surveyTask, taskRun: NSUUID() as UUID)
        case .activeTask:
            taskViewController = ORKTaskViewController(task: StudyTasks.walkingTask, taskRun: NSUUID() as UUID)
            
            do {
                let defaultFileManager = FileManager.default
                
                // Identify the documents directory.
                let documentsDirectory = try defaultFileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                
                // Create a directory based on the `taskRunUUID` to store output from the task.
                let outputDirectory = documentsDirectory.appendingPathComponent(taskViewController.taskRunUUID.uuidString)
                try defaultFileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true, attributes: nil)
                
                taskViewController.outputDirectory = outputDirectory
            }
            catch let error as NSError {
                fatalError("The output directory for the task with UUID: \(taskViewController.taskRunUUID.uuidString) could not be created. Error: \(error.localizedDescription)")
            }
        }
        
        taskViewController.delegate = self
        navigationController?.present(taskViewController, animated: true, completion: nil)
    }
    
}

extension ActivitiesTableViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        // Handle results using taskViewController.result
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
}
