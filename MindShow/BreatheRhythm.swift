//
//  BreatheRhythm.swift
//  Feedback
//
//  Created by yanguo sun on 2022/1/12.
//

import Foundation
import UIKit

enum WoofError: Error {
    case invalidServerResponse
    case unsupportedImage
}


class BreatheRhythm: ObservableObject {
    @Published private var breath = Breathe()
    var countOfBreath: Int8 = 0
    var countOfBreathMax: Int8 = 10
    let roles = ["10", "20", "30", "40"]
    @Published var countOfBreathMaxString: String = "10" {
        didSet {
            countOfBreathMax = Int8(countOfBreathMaxString) ?? 10
        }
    }
    var canBegin: Bool {
        countOfBreath == 0
    }

    func beginIn() {
        var count = 10
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard count < 50 else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.beginOut()
                }
                return
            }
            self.breath.deep = Double(count) / 40
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: self.intensity)
            count += 2
        }
    }


    private func beginOut() {
        var count = 50
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard count > 10 else {
                timer.invalidate()
                self.countOfBreath += 1
                if self.countOfBreath < self.countOfBreathMax {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.beginIn()
                    }
                } else {
                    self.countOfBreath = 0
                    self.breath.deep = 0.25
                }
                return
            }
            self.breath.deep = Double(count) / 40
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: self.intensity)
            count -= 2
        }
    }

    var intensity: Double {
        breath.deep
    }

    func loadWebImage() async -> UIImage {
        do {
            let image = try await self.fetchPhoto(url: URL(string: "https://p6-passport.byteacctimg.com/img/user-avatar/9ccfbcb48d9ddf36da228dab88732966~300x300.image")!)
            return image
        } catch {
            return UIImage(systemName: "wifi.exclamationmark")!
        }
    }

    // Fetch photo with async/await
    func fetchPhoto(url: URL) async throws -> UIImage
    {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw WoofError.invalidServerResponse
              }

        guard let image = UIImage(data: data) else {
            throw WoofError.unsupportedImage
        }

        return image
    }
}
