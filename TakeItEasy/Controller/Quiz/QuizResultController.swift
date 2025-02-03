//
//  QuizResultController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/15/25.
//

import UIKit
import AVFoundation

class QuizResultController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var letterGradeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var updateBack: UIView!
    @IBOutlet weak var updateLabel: UILabel!
    
    // Initialized by sender
    var currentQuiz: StoredQuiz?
    var score: Int = 0
    var charScore: String?
    var pointUpdate: Int32?

    // Used internally
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            if let audioURL = Bundle.main.url(forResource: "success", withExtension: "mp3") {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL, fileTypeHint: AVFileType.mp3.rawValue)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
            }
        } catch {
            return
        }

        backView.backgroundColor = ThemeManager.backColor
        backView.layer.borderColor = UIColor.black.cgColor
        backView.layer.borderWidth = 0.2
        backView.layer.cornerRadius = 12
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowOffset = CGSize(width: 4, height: 4)
        backView.layer.shadowRadius = 3
        backView.layer.shadowPath = UIBezierPath(
            roundedRect: backView.bounds,
            cornerRadius: backView.layer.cornerRadius
        ).cgPath

        let maxScore = currentQuiz?.totalScore ?? 1
        let percentageScore = Float(score) / Float(maxScore)

        switch percentageScore {
            case let p where p == 1.0:
                audioPlayer?.play()
                successEffect()
                charScore = "S"
            case let p where p >= 0.8:
                audioPlayer?.play()
                successEffect()
                charScore = "A"
            case let p where p >= 0.6:
                charScore = "B"
            case let p where p >= 0.4:
                charScore = "C"
            case let p where p >= 0.2:
                charScore = "D"
            default:
                charScore = "F"
        }
        
        if percentageScore > 0.6 {
            messageLabel.text = "You did well!"
        } else {
            messageLabel.text = "Maybe try again?"
        }
        
        scoreLabel.text = "\(score)/\(maxScore)"
        
        letterGradeLabel.text = charScore
        backImage.tintColor = ThemeManager.primaryColor

        updateBack.layer.cornerRadius = 5
        updateBack.backgroundColor = ThemeManager.backColor

        if let pointUpdate {
            var updateString = "You gained \(pointUpdate) point"
            if pointUpdate != 1 {
                updateString += "s"
            }
            updateLabel.text = updateString
        } else {
            updateLabel.text = "No points gained"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
    }

    func successEffect() {
        let emitterLayer = CAEmitterLayer()

        emitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 0)

        emitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        emitterLayer.emitterShape = .line

        let systemImage = UIImage(systemName: "star.fill")?.withTintColor(ThemeManager.customColor(r: 255, g: 175, b: 55))
        let renderer = UIGraphicsImageRenderer(size: systemImage!.size)
        let particleImage = renderer.image { ctx in
            systemImage?.draw(at: .zero)
        }

        let particleCell = CAEmitterCell()
        particleCell.contents = particleImage.cgImage
        particleCell.birthRate = 7
        particleCell.lifetime = 10
        particleCell.velocity = 150
        particleCell.velocityRange = 10
        particleCell.emissionLongitude = .pi
        particleCell.emissionRange = .pi/7
        particleCell.scale = 0.3
        particleCell.scaleRange = 0.05

        emitterLayer.emitterCells = [particleCell]
        view.layer.addSublayer(emitterLayer)

    }

    @IBAction func exitAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
