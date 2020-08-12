//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Soundrapandian T on 30/07/20.
//  Copyright © 2020 Soundrapandian T. All rights reserved.
//

import UIKit
enum QuestionType : String
{
    case GK = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple"
    case Computer = "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple"
    case Film = "https://opentdb.com/api.php?amount=10&category=11&difficulty=easy&type=multiple"
    case Music = "https://opentdb.com/api.php?amount=10&category=12&difficulty=easy&type=multiple"
}

struct Questions : Codable {
    var response_code : Int!
    var results :[EachQue]!
    public enum CodingKeys: String, CodingKey
    {
        case response_code
        case results
    }
    init() {
        
    }
    init(from decoder:Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {response_code = try values.decode(Int.self, forKey: .response_code)}catch{}
        do {results = try values.decode([EachQue].self, forKey: .results)}catch{}
    }
    func getValueForKey(key : CodingKeys)-> AnyObject
    {
        switch key.rawValue {
        case CodingKeys.response_code.rawValue:
            return self.response_code as AnyObject
        case CodingKeys.results.rawValue:
            return self.results as AnyObject
        default:return "" as AnyObject
        }
    }
}

struct EachQue : Codable{
    var category : String!
     var type : String!
     var difficulty : String!
     var question : String!
     var correct_answer : String!
    var incorrect_answers : [String]!
    
    public enum CodingKeys: String, CodingKey
    {
        case category
        case type
        case difficulty
        case question
        case correct_answer
        case incorrect_answers
    }
    init() {
        
    }
    init(from decoder:Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {category = try values.decode(String.self, forKey: .category)}catch{}
        do {type = try values.decode(String.self, forKey: .type)}catch{}
        do {difficulty = try values.decode(String.self, forKey: .difficulty)}catch{}
        do {question = try values.decode(String.self, forKey: .question)}catch{}
        do {correct_answer = try values.decode(String.self, forKey: .correct_answer)}catch{}
        do {incorrect_answers = try values.decode([String].self, forKey: .incorrect_answers)}catch{}
    }
    func getValueForKey(key : CodingKeys)-> AnyObject
    {
        switch key.rawValue {
        case CodingKeys.category.rawValue:
            return self.category as AnyObject
        case CodingKeys.type.rawValue:
            return self.type as AnyObject
        case CodingKeys.difficulty.rawValue:
            return self.difficulty as AnyObject
        case CodingKeys.question.rawValue:
            return self.question as AnyObject
        case CodingKeys.correct_answer.rawValue:
            return self.correct_answer as AnyObject
        case CodingKeys.incorrect_answers.rawValue:
            return self.incorrect_answers as AnyObject
        default:return "" as AnyObject
        }
    }
}
class BaseError: Error {
var message: String = ""
}
class QuestionsViewController: UIViewController {

    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var tblViewChoices: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblCorrectAnswer: UILabel!
    
    
    var isShowedCorrectAns : Bool = false
    var count : Int = 0
    var marks : Int = 0
    var queType : QuestionType!
    var queArray : [EachQue]!
    fileprivate var selectedrow : Int?
    fileprivate var loader = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewChoices.isHidden = true
        configureLoader()
        busy()
        sendQuestionReq(successHandler: {[unowned self] (queArray) in
            self.ready()
            self.queArray = queArray
            self.updateValues()
        }) {[unowned self] (error) in
            self.ready()
           let alert = UIAlertController.init(title: "Quiz", message: error.message, preferredStyle: .alert)
           let actionOk = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
           alert.addAction(actionOk)
           self .present(alert, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    func updateValues()
    {
        if count != queArray.count
        {
            self.navigationController?.navigationBar.topItem?.title = "Question No:\(count+1)"
            setTitle(title: "Submit")
            lblQuestions.text = queArray[count].question
            queArray[count].incorrect_answers += [queArray[count].correct_answer]
            queArray[count].incorrect_answers.shuffle()
            tblViewChoices.reloadData()
            tblViewChoices.isHidden = false
            btnSubmit.isHidden = false
        }
        else
        {
            self.navigationController?.navigationBar.topItem?.title = "Results"
            tblViewChoices.isHidden = true
            btnSubmit.isHidden = true
            lblQuestions.text = "Your mark is \(marks)"
        }
    }
    func setTitle(title : String)
    {
        btnSubmit.setTitle(title, for: .normal)
        btnSubmit.setTitle(title, for: .highlighted)
    }
    @IBAction func submitAction(_ sender: Any) {
        
        if(!isShowedCorrectAns)
        {
            guard selectedrow != nil else {
                let alert = UIAlertController.init(title: "Quiz", message: "Please select the answer", preferredStyle: .alert)
                let actionOk = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                alert.addAction(actionOk)
                self.present(alert, animated: true, completion: nil)
                return
            }
            isShowedCorrectAns = true
            lblCorrectAnswer.text = "Ans : \(queArray[count].correct_answer ?? "Unavailable")"
            setTitle(title: "Next")
        }
        else
        {
            calculatingmarks()
            isShowedCorrectAns = false
            lblCorrectAnswer.text = ""
            count += 1
            selectedrow = nil
            updateValues()
        }
    }
    
    func calculatingmarks()
    {
        guard let row = selectedrow else {
            return
        }
        if queArray[count].incorrect_answers[row] == queArray[count].correct_answer
        {
            marks += 1
        }
    }
}
extension QuestionsViewController {
    func configureLoader() {
        loader.color = UIColor.darkGray
        loader.hidesWhenStopped = true
        view.addSubview(loader)
        loader.center = view.center
        loader.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    }
    func busy() {
        loader.isHidden = false
        loader.startAnimating()
//         loader.center = view.center
//          view.bringSubviewToFront(loader)
 //           baseView.content.isUserInteractionEnabled = false
    }

    func ready() {
        loader.stopAnimating()
        loader.isHidden = true
    }
}

extension QuestionsViewController
{
    
    func sendQuestionReq(successHandler: @escaping ([EachQue]) -> Void, errorHandler: @escaping (BaseError) -> Void)
    {
        guard let url = URL(string: queType.rawValue) else{
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in

            DispatchQueue.main.async {
            guard let data = data else {
                 let error = BaseError()
                 error.message = "API Unavailable"
                 errorHandler(error)
                 return
            }
            do {
                let res = try JSONDecoder().decode(Questions.self, from: data)
                if(res.response_code == 0)
                {
                    successHandler(res.results)
                }
                else
                {
                    let error = BaseError()
                    error.message = "API Unavailable"
                    errorHandler(error)
                }
            }
            catch {
                let error = BaseError()
                error.message = "Parsing failure"
                errorHandler(error)
            }
            }
            

        }.resume()
    }
}
extension QuestionsViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ary = queArray
        {
            return ary[count].incorrect_answers.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choiceCell = tableView.dequeueReusableCell(withIdentifier: "QuestionChoiceCell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "QuestionChoiceCell")
        choiceCell.textLabel?.text = queArray[count].incorrect_answers[indexPath.row]
        return choiceCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedrow = indexPath.row
    }


}
