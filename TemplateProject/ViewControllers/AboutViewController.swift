//
//  AboutViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 8/5/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    var sectionTitles = [ "App version", "Development & Design" ]
    
    var sectionData = [[ "Linker      1.0.0"], ["Darkhan Mukatay" ]]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 19)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: "ProfileSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProfileSectionHeader")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AboutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("aboutCell", forIndexPath: indexPath) as! AboutTableViewCell
        let value = sectionData[indexPath.section][indexPath.row]
        cell.tableText.text = value
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("ProfileSectionHeader") as! ProfileSectionHeader
        headerView.titleLabel.text = sectionTitles[section]
        return headerView
    }
    
}
