//
//  ViewController.swift
//  ATTwitterClone
//
//  Created by Alvin Tu on 2/8/21.
//  Copyright © 2021 Alvin Tu. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import Combine


class ViewController: UIViewController {
    var tweets = [Tweet]()
    @Published var canPressSearch: Bool = false

    private var collectionView: UICollectionView?
    
    private var textField: UITextField = UITextField()
    private var robotLabel: UILabel?
    private var robotToggle: UISwitch?
    private var searchButton: UIButton = UIButton()

    private var toggleSubscriber:AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpCollectionView()
        setUpProcessingChain()
    }
    
    func setUpProcessingChain() {
        toggleSubscriber = $canPressSearch.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: searchButton)
    }
    
    func setUpSearchBar() {
        
        let textFieldFrame = CGRect(x: 20, y: 50, width: view.frame.size.width * 0.75, height: 80)
        let buttonFrame = CGRect(x: view.frame.size.width - 100, y: 50, width: 100, height: 80)
        let toggleFrame = CGRect(x: view.frame.size.width - 100, y: 150, width: 100, height: 50)
        let labelFrame = CGRect(x: 20, y: 140, width: view.frame.size.width * 0.65, height: 50)

        
        textField = UITextField(frame: textFieldFrame)
        textField.placeholder = "Search Twitter"
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.systemGray4
        searchButton = UIButton(frame: buttonFrame)
        searchButton.addTarget(self, action: #selector(ViewController.pressed(_:)), for: .touchUpInside)

        searchButton.setTitle("Search", for: .normal)
        searchButton.isEnabled = false
        
        let toggle = UISwitch(frame: toggleFrame)
        toggle.isOn = canPressSearch
        toggle.addTarget(self, action:#selector(ViewController.categorySwitchValueChanged(_:)), for: .valueChanged)
        let label = UILabel(frame: labelFrame)
            label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.text = "ENABLE SEARCH IF NOT ROBOT"

        
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(toggle)
        view.addSubview(label)
    }
    
    @objc func pressed(_ sender: UIButton) {
        print("button pressed")
        guard textField.text!.count > 0  else {return}
        if let text = textField.text {
            searchWith(query: text)
        }
        textField.text = ""
    }
    
    @objc func categorySwitchValueChanged(_ sender : UISwitch!){
        canPressSearch = sender.isOn
        print("not a robot")
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height/5)
        let collectionViewFrame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: view.frame.size.height - 100)
        collectionView = UICollectionView(frame:collectionViewFrame, collectionViewLayout: layout)
        collectionView?.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: TweetCollectionViewCell.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
    }


    override func viewDidLayoutSubviews() {
        let collectionViewFrame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: view.frame.size.height - 100)

        collectionView?.frame = collectionViewFrame
    }
    
}
extension ViewController {
    //put in your own bearer token you get from twitter developer
    func searchWith(query: String) {
        let bearerToken = "AAAAAAAAAAAAAAAAAAAAAIcdNQEAAAAAkeMXs8apuXWhvv4VZ0r%2BD5wNaF4%3D6xQ9MsWGVryYUNUICaOa0RttaRIhFkqcJ8zs6hP2JoI00xFk2f"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Accept": "application/json"
        ]
        
        AF.request("https://api.twitter.com/2/tweets/search/recent?query=\(query)", headers: headers).responseDecodable(of:Tweets.self) { response in
            if let tweets = response.value {
                self.tweets = tweets.all
                self.collectionView?.reloadData()
            }
        }
    }
}




extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard tweets.count > 0 else {return 0}
        return tweets.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tweet = tweets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCollectionViewCell.identifier, for: indexPath) as! TweetCollectionViewCell
        cell.configure(with: tweet)
        return cell
    }
    
    
}
