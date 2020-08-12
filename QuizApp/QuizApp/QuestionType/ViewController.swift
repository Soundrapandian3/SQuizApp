//
//  ViewController.swift
//  QuizApp
//
//  Created by Soundrapandian T on 30/07/20.
//  Copyright © 2020 Soundrapandian T. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    let questionType = ["General Knowledge","Computers","Film","Music"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Question Type"
        tblQuestionType.tableFooterView = UIView()
        tblQuestionType.reloadData()
    }

    @IBOutlet weak var tblQuestionType: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeCell = tableView.dequeueReusableCell(withIdentifier: "QuestionTypeCell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "QuestionTypeCell")
        typeCell.textLabel?.text = questionType[indexPath.row]
        return typeCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Questions", bundle: nil)
        let questionVC = storyBoard.instantiateViewController(identifier: "Questions") as! QuestionsViewController
        switch indexPath.row {
        case 0:
            questionVC.queType = .GK
        case 1:
            questionVC.queType = .Computer
        case 2:
            questionVC.queType = .Film
        case 3:
            questionVC.queType = .Music
        default:
            questionVC.queType = .GK
        }
        self.navigationController?.pushViewController(questionVC, animated:true)
        
    }
    
}

