//
//  ViewController.swift
//  PassingData
//
//  Created by 노민우 on 2023/01/17.
//

import UIKit

// 1. property (instance)
// 2. segue (unwind segue)
// 3. self instance <--- 좋은방법은 아님
// 4. delegate pattern
// 5. closure
// 6. notification (NotificationCenter) broadcat
// 7. closure -> async await (withCheckedContinuation)
class ViewController: UIViewController {
    
    var myAge = 20
    var myName = "Noh"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var callbackDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = myName
        
        // 6.notification 호출
        createObserver()
    }
    
    // 6. notification
    func createObserver() {
        
        let notiName = Notification.Name("changeName")
        NotificationCenter.default.addObserver(self, selector: #selector(changeName), name: notiName, object: nil)

    }
    
    @objc func changeName(notification: Notification){
        
        if let hasName = notification.userInfo?["name"] as? String {
            callbackDataLabel.text = hasName
        }
    }
    
    // 6---------

    // 1. property (instance)스토리보드 ------
    @IBAction func moveToDetailVC(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.detailName = myName
        detailVC.detailAge = myAge
        detailVC.updateLabel()
        
        self.present(detailVC, animated: true)
    }
    // 1------
    
    // 2. unwind Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            // destination : 목적(도착)지
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.detailAge = myAge
                detailVC.detailName = myName
            }
        }
    }
    // unwind Segue
    @IBAction func unwind(segue: UIStoryboardSegue){
        // source : DetailController 의 정보를 다 확인할 수 있다.
        if let detailVC = segue.source as? DetailViewController {
            self.callbackDataLabel.text = detailVC.detailName
        }
    }
    //2 ---------
    
    // 3. self instance <--- 좋은방법은 아님----
    // 나 자신의 instance를 넘겨주고 넘겨 받은곳에서 나의 정보를 변경하는 것
    // 즉, A 의 instance를 넘겨주고 B에서 A의 인스턴스를 받아 B에서 A를 수정하는 것
    // 이 방법은 좋지 않다.
    @IBAction func selfInstanceMoveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.mainVC = self
        
        self.present(detailVC, animated: true)
    }
    
    @IBAction func delegateMoveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // self지만 detailVC.delegate의 type이 ViewControllerDelegate이기 때문에 같은 Type의 내용만 넘겨줄수있다.
        // 즉, self가 가진 구현 내용만 넘겨주는것이다.
        detailVC.delegate = self
        
        self.present(detailVC, animated: true)
    }
    //3 -----------------
    
    
    // 4. delegate pattern
    // 5. closure
    func rightTopName(str: String){
        self.callbackDataLabel.text = str
    }
    
    @IBAction func closureMoveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        
        
        // 구현부
        /* 이 부분은 func(rightTopName())와 동일하다
         { str in
            self.callbackDataLabel.text = str
          }
         즉, str in 가 파라미터라고 생각하면 된다.
         */
//        detailVC.detailClosure = { str in
//            // Label 의 값을 봐까주기위해 구현
//            self.callbackDataLabel.text = str
//        }
        
        //5. closure 를 통해 값을 받아오는 것
//        detailVC.closureWithFunc { str in
//            self.callbackDataLabel.text = str
//        }
//
//        detailVC.detailClosure = rightTopName
//        detailVC.closureWithFunc(completion: rightTopName)
        
        Task{
            self.callbackDataLabel.text = await detailVC.closureWithFunc()
        }
        
        
        self.present(detailVC, animated: true)
    }
    
}

// 4-3. 채택해서 내용을 구현한 것.
extension ViewController: ViewControllerDelegate {
    func rightLabelString(str: String) {
        callbackDataLabel.text = str
    }
}

// 4-2. Delegate 정의
protocol ViewControllerDelegate: AnyObject {
    func rightLabelString(str: String)
}

// ---------------------------
