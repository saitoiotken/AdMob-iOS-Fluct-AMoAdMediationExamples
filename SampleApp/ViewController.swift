//
//  ViewController.swift
//  SampleApp
//
//  Created by y-saito21 on 2023/07/07.
//

import UIKit
import FluctSDK
import GoogleMobileAdsMediationFluct
import GoogleMobileAds

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "ca-app-pub-3940256099942544/1712485313"

class ViewController: UIViewController {
    
    @IBOutlet weak var showButton: UIButton!

    private var rewardedAd: GADRewardedAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showButton.isEnabled = false
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        let request = GADRequest()

        // 特別な設定はしない
        let setting = FSSRewardedVideoSetting.default
        let extra = GADMAdapterFluctExtras()
        extra.setting = setting
        request.register(extra)

        GADRewardedAd.load(withAdUnitID: adUnitID, request: request) {[weak self] (ad, error) in
            if let error = error {
                print(error)
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.showButton.isEnabled = true
        }
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard let rewardedAd = self.rewardedAd else { return }
        rewardedAd.present(fromRootViewController: self) {[rewardedAd] in
            print(rewardedAd.adReward)
        }
    }

}

extension ViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print(#function, error)
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }

    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
        self.showButton.isEnabled = false
    }
}
