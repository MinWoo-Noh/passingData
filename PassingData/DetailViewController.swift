//
//  DetailViewController.swift
//  PassingData
//
//  Created by 노민우 on 2023/01/17.
//

import UIKit

class DetailViewController: UIViewController {
    
    // closure 옵셔널 변수 선언
    var detailClosure: ((String) -> Void)?
    
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var ageLabel: UILabel?
    
    var detailName = ""
    var detailAge = 0
    
    // instance를 받기위한 변수
    // 값을 받을수 있을지 없을지 모르기 때문에 옵셔널로 선언
    var mainVC: ViewController?
    
    // 2. Delegate 사용할 변수 선언
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        // Do any additional setup after loading the view.
    }
    
    func updateLabel() {
        nameLabel?.text = detailName
        ageLabel?.text = detailAge.description
    }
    
    // A의 instance를 받아 가공하는 메소드(버튼)
    @IBAction func backInsteance(_ sender: Any) {
        mainVC?.myName = "kim"
        mainVC?.nameLabel.text = mainVC?.myName
        self.dismiss(animated: true)
    }
    
    @IBAction func backDelegate(_ sender: Any) {
        delegate?.rightLabelString(str: "min")
        self.dismiss(animated: true)
    }
    
    
    @IBAction func backClosure(_ sender: Any) {
        
        // 클로져 호출해 파라미터를 넘겨준다.
       detailClosure?("han")
        self.dismiss(animated: true)
    }
    
    func closureWithFunc(completion: (String) -> Void){
        completion("han func")
    }
    
    // 7. closure 위 closureWithFunc 를 이용해 async 를 만듬
    
    func closureWithFunc() async -> String {
        
        await withCheckedContinuation { continuation in
            closureWithFunc { str in
                continuation.resume(returning: str)
            }
        }
        
    }
    
    // 6
    @IBAction func postNotification(_ sender: Any) {
        
        let notiName = Notification.Name("changeName")
        
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: ["name" : "noti name"])
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
