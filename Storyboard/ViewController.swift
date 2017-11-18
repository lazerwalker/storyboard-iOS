import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var stateLabel:UILabel?

    var game:Game?
    var activePassageId:String?

    var projectName:String?

    var playButton:UIBarButtonItem?
    var restartButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(ViewController.start))
        restartButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.restart))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ViewController.showGamePicker))

        loadProject("elevator")
    }

    //- 

    func loadProject(_ projectName:String) {
        self.projectName = projectName
        self.title = projectName
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setMode(AVAudioSessionModeSpokenAudio)
        } catch {
            print("Error initializing audio session")
        }

        let inputs:[String:SensorInput] = [
            "proximity": ProximitySensor(threshold: 2),
            "headphones": HeadphoneSensor(),
            "altitude": AltimeterSensor(),
            "device": DeviceSensor(),
            "insideTheMediaLab": MediaLabSensor()
        ]

        let outputs:[String:Output] = [
            "speech": TextToSpeechOutput(),
            "mp3": AudioOutput(project: projectName)
        ]

        let onStateUpdate:StateUpdateBlock = { state in
            if let stateLabel = self.stateLabel {
                stateLabel.text = state
                stateLabel.sizeToFit()
            }
        }

        self.game?.stop()
        let game = Game(gameFile: projectName, inputs: inputs, outputs: outputs, onStateUpdate: onStateUpdate)
        self.game = game

        navigationItem.rightBarButtonItem = playButton
    }

    @objc func start() {
        if let game = game {
            game.start()
            navigationItem.rightBarButtonItem = restartButton
        }
    }

    @objc func restart() {
        if let name = projectName {
            loadProject(name)
            start()
        }
    }

    @objc func showGamePicker() {
        let paths = Bundle.main
            .paths(forResourcesOfType: "json", inDirectory: "examples")
            .flatMap { $0.components(separatedBy: "/").last }
            .flatMap { $0.components(separatedBy: ".").first }

        let vc = ProjectListViewController(projects: paths) { project in
            if let project = project {
                self.loadProject(project)
            }
            self.dismiss(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}

