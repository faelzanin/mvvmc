//
//  HomeViewController.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Variables
    var viewModel: HomeViewModel!
    
    // MARK: Outlet's
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var jokeImageView: UIImageView!
    
    // MARK: Init's
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: Lifecycles
	override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }

    // MARK: Actions
    @IBAction func changeJokeTapped(_ sender: Any) {
        viewModel.loadJoke()
    }
    
    // MARK: Observables
    func setupObservables() {
        viewModel.homeObservable.didChange = { [weak self] state in
            guard let vc = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    vc.view.showHUD()
                case .load(data: let homeModel):
                    vc.view.hideHUD()
                    vc.fillData(joke: homeModel.joke)
                case .errored(error: _):
                    vc.view.hideHUD()
                default:
                    vc.view.hideHUD()
                }
            }
        }
    }
    
    // MARK: Private methods
    private func fillData(joke: Joke?) {
        jokeLabel.text = joke?.value ?? ""
        jokeImageView.downloaded(from: joke?.icon_url ?? "")
    }
}
