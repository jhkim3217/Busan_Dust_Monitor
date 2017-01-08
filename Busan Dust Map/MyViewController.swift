//
//  MyViewController.swift
//  Busan Dust Map
//
//  Created by 김종현 on 2016. 11. 26..
//  Copyright © 2016년 김종현. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView  =   UITableView()
        
    var dataItem = ["측정시간", "미세먼지(PM10)", "초미세먼지(PM2.5)", "설치위치", "용도", "측정망"]
    var data: [String] = []
    var rPM10: String?
    var rPM25: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        
        let rect = CGRect(x: 0, y: 0, width: 272, height: 250)
        tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
        
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        let view1: UIView = UIView.init(frame: CGRectMake(30, 0, 230, 20));
//        let label: UILabel = UILabel.init(frame: CGRectMake(30, 0, 230, 20))
//        label.text = "  (측정시간 : " + currentTime! + ")"
//        label.textColor = UIColor.darkGrayColor()
//        view1.addSubview(label);
//        self.tableView.tableHeaderView = view1;
        
        self.view.addSubview(self.tableView)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataItem.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        cell.textLabel!.text = dataItem[indexPath.row]
        cell.textLabel?.textColor = UIColor.orange
        cell.detailTextLabel?.text = data[indexPath.row]
        return cell;
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let view1: UIView = UIView.init(frame: CGRectMake(0, 0, 320, 600));
//        let label: UILabel = UILabel.init(frame: CGRectMake(0, 0, 320, 600))
//        label.text = "측정 시간"
//        
//        view1.addSubview(label);
//        self.tableView.tableHeaderView = view1;
//    
//    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
