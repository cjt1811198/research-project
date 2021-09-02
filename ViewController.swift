/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import ARKit
import RealityKit
import Speech

class ViewController: UIViewController {
    
    /// The app's root view.
    @IBOutlet var arView: ARView!
    
    
    @IBOutlet weak var group1btn: UIButton!
    @IBOutlet weak var group2btn: UIButton!
    
    @IBOutlet var group1btncollection: [UIButton]!
    
    @IBOutlet var group2btncollection: [UIButton]!
    
    
    var SpecialModel: Entity?
    var sound: String?
    var Modelname: String?
    var ModelID: String?
    var exist = false
    //var objectAnchor: AnchorEntity?
    var anchors: Scene.AnchorCollection?
    var moveToLocation: Transform = Transform()
    var moveDuration: Double = 5
    
    //Speech Recognition
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechTask = SFSpeechRecognitionTask()
    
    //Audio
    let audioEngine = AVAudioEngine()
    let audioSession = AVAudioSession.sharedInstance()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        group1btncollection.forEach { (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }
        
        group2btncollection.forEach { (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }
        // Configure the AR session for horizontal plane tracking
        startPlaneDetection()
        
        //Create Model
        
        //2Dpoint
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
        //move(direction: "foward", Model: Model)
        startSpeechRecognition()
        
        
    }
    

    @IBOutlet weak var Objects: UILabel!
    
    
    @IBAction func Group1select(_ sender: UIButton) {
        group1btncollection.forEach { (btn) in
            UIView.animate(withDuration: 0.7){
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func group2select(_ sender: UIButton) {
        group2btncollection.forEach { (btn) in
            UIView.animate(withDuration: 0.7){
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func Waterfall(_ sender: UIButton) {
        Objects.text = "Waterfall"
    }
    
    
    @IBAction func Tree1(_ sender: UIButton) {
        Objects.text = "Tree1"
    }
    
    
    @IBAction func Tree2(_ sender: UIButton) {
        Objects.text = "Tree2"
    }
    
    
    @IBAction func Tree3(_ sender: UIButton) {
        Objects.text = "Tree3"
    }
    
    @IBAction func Eagle(_ sender: UIButton) {
        Objects.text = "Eagle"
    }
    
    
    @IBAction func Cat(_ sender: UIButton) {
        Objects.text = "Cat"
    }
    
    
    @IBAction func Dog(_ sender: UIButton) {
        Objects.text = "Dog"
    }
    
    
    @IBAction func Girl(_ sender: UIButton) {
        Objects.text = "Girl"
    }
    
    @IBAction func RocketBike(_ sender: UIButton) {
        Objects.text = "RocketBike"
    }
    
    @IBAction func Robot(_ sender: UIButton) {
        Objects.text = "Robot"
    }
    
    
    @IBAction func Spaceman(_ sender: UIButton) {
        Objects.text = "Spaceman"
    }
    
    
    @IBAction func Example1(_ sender: UIButton) {
        Objects.text = "Example1"
    }
    
    
    @IBAction func Example2(_ sender: UIButton) {
        Objects.text = "Example2"
    }
    
    @IBAction func RemoveAll(_ sender: UIButton) {
        removeAllentities()
    }
    
    
    @IBAction func Add(_ sender: UIButton) {
        exist = false
    }
    
    
    @IBAction func Remove(_ sender: UIButton) {
        exist = true
    }
    
    
    @objc
    func handleTap(recognizer:UITapGestureRecognizer){
        //Touch location
        let tapLocation = recognizer.location(in: arView)
        //Recast (2D to 3D)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        if exist == false{
            if let firstResult = results.first{
                //3D point
                let worldPos = simd_make_float3(firstResult.worldTransform.columns.3)
                Modelname = Nameprint()
                createAnchor(Modelname: Modelname!, at: worldPos)
            }
        }else if exist == true{
            let removeLocation = recognizer.location(in: arView)
                removeObject(at: removeLocation)
            }
    }
    
    
    func Nameprint() -> String{
        guard let Modelname = Objects.text
        else { return "Error" }
        return Modelname
    }
    

    
    func startPlaneDetection(){
        
        arView.automaticallyConfigureSession = true
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.horizontal, .vertical]
        arConfiguration.environmentTexturing = .automatic
        //arView.debugOptions = .showAnchorGeometry
        arView.session.run(arConfiguration)
    }
    
    func addAudio(sound: String, Model: Entity, Loop: Bool){
        //let model = try! ModelEntity.load(named: name)
        do{
            let resource = try AudioFileResource.load(named: sound, in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: Loop)
            let audioController = Model.prepareAudio(resource)
            audioController.play()
        }catch{
            print("Error loading audio file")
        }
    }
    
    func createAnchor(Modelname: String, at location: SIMD3<Float>){
        
        switch Modelname{
            case "Tree1" :
                let Tree1Anchor = AnchorEntity(world: location)
                let Tree1Model = try! Entity.load(named: "Tree1")
                addAudio(sound: "leaves.wav", Model: Tree1Model, Loop: true)
                Tree1Anchor.name = String(Tree1Model.id)
                Tree1Anchor.addChild(Tree1Model)
                arView.scene.addAnchor(Tree1Anchor)
            case "Tree2" :
                let Tree2Anchor = AnchorEntity(world: location)
                let Tree2Model = try! Entity.load(named: "Tree2")
                addAudio(sound: "leaves.wav", Model: Tree2Model, Loop: true)
                Tree2Anchor.name = String(Tree2Model.id)
                Tree2Anchor.addChild(Tree2Model)
                arView.scene.addAnchor(Tree2Anchor)
            case "Tree3" :
                let Tree3Anchor = AnchorEntity(world: location)
                let Tree3Model = try! Entity.load(named: "Tree3")
                addAudio(sound: "leaves.wav", Model: Tree3Model, Loop: true)
                Tree3Anchor.name = String(Tree3Model.id)
                Tree3Anchor.addChild(Tree3Model)
                arView.scene.addAnchor(Tree3Anchor)
            case "Eagle" :
                let BirdAnchor = AnchorEntity(world: location)
                let BirdModel = try! Entity.load(named: "Eagle")
                addAudio(sound: "Birds.wav", Model: BirdModel, Loop: false)
                BirdAnchor.name = String(BirdModel.id)
                BirdAnchor.addChild(BirdModel)
                arView.scene.addAnchor(BirdAnchor)
            case "Robot" :
                let RobotAnchor = AnchorEntity(world: location)
                SpecialModel = try! Entity.load(named: "Robot")
                addAudio(sound: "Robot.wav", Model: SpecialModel!, Loop: true)
                RobotAnchor.name = String(SpecialModel!.id)
                RobotAnchor.addChild(SpecialModel!)
                arView.scene.addAnchor(RobotAnchor)
                //startSpeechRecognition()
            case "Spaceman" :
                let SpacemanAnchor = AnchorEntity(world: location)
                let SpacemanModel = try! Entity.load(named: "Spaceman")
                SpacemanAnchor.name = String(SpacemanModel.id)
                SpacemanAnchor.addChild(SpacemanModel)
                arView.scene.addAnchor(SpacemanAnchor)
            case "HAB" :
                let HABAnchor = AnchorEntity(world: location)
                let HABModel = try! Entity.load(named: "HAB")
                HABAnchor.name = String(HABModel.id)
                HABAnchor.addChild(HABModel)
                arView.scene.addAnchor(HABAnchor)
            case "RocketBike":
                let RocketBikeAnchor = AnchorEntity(world: location)
                let RocketBikeModel = try!Entity.load(named: "RocketBike")
                addAudio(sound: "Jet.wav", Model: RocketBikeModel, Loop: false)
                RocketBikeAnchor.addChild(RocketBikeModel)
                arView.scene.addAnchor(RocketBikeAnchor)
            case "Dog":
                let DogAnchor = AnchorEntity(world: location)
                let DogModel = try!Entity.load(named: "Dog")
                addAudio(sound: "Dog.wav", Model: DogModel, Loop: false)
                DogAnchor.addChild(DogModel)
                arView.scene.addAnchor(DogAnchor)
            case "Cat":
                let CatAnchor = AnchorEntity(world: location)
                let CatModel = try!Entity.load(named: "Cat")
                addAudio(sound: "Cat.wav", Model: CatModel, Loop: false)
                CatAnchor.addChild(CatModel)
                arView.scene.addAnchor(CatAnchor)
            case "Girl" :
                let GirlAnchor = AnchorEntity(world: location)
                SpecialModel = try! Entity.load(named: "Girl")
                let scale = 10 * SpecialModel!.scale
                SpecialModel?.setScale(scale, relativeTo: SpecialModel!)
                addAudio(sound: "footsteps.wav", Model: SpecialModel!, Loop: false)
                GirlAnchor.name = String(SpecialModel!.id)
                GirlAnchor.addChild(SpecialModel!)
                arView.scene.addAnchor(GirlAnchor)
            case "Waterfall":
                let WaterfallAnchor = AnchorEntity(world: location)
                let WaterfallModel = try!Entity.load(named: "Waterfall2")
                addAudio(sound: "waterfall.mp3", Model: WaterfallModel, Loop: true)
                WaterfallAnchor.addChild(WaterfallModel)
                arView.scene.addAnchor(WaterfallAnchor)
            case "Example1":
                let Example1Anchor = AnchorEntity(world: location)
                let Example1Model = try!Entity.load(named: "Example1")
                Example1Anchor.addChild(Example1Model)
                arView.scene.addAnchor(Example1Anchor)
            case "Example2":
                let Example2Anchor = AnchorEntity(world: location)
                let Example2Model = try!Entity.load(named: "Example2")
                Example2Anchor.addChild(Example2Model)
                arView.scene.addAnchor(Example2Anchor)
        default:
            print("No Anchor")
        }
    }
    
    
    func removeObject(at location: CGPoint){
        //1. Anchor
        if let entity = arView.entity(at: location){
            if let anchorEntity = entity.anchor{
                anchorEntity.removeFromParent()
            }
        }
    }
    
    func move(direction:String, Model: Entity){
        
        switch direction{
            
            case "forward":
            //move
                moveToLocation.translation = Model.transform.translation + simd_float3 (x:0 , y:0 , z:20)
                Model.move(to: moveToLocation, relativeTo: Model, duration: moveDuration)
            //walking animation
                walkAnimation(moveDuration: moveDuration, Model: Model)
            case "back":
                moveToLocation.translation = Model.transform.translation + simd_float3 (x:0 , y:0 , z:-20)
                Model.move(to: moveToLocation, relativeTo: Model, duration: moveDuration)
            //walking animation
                walkAnimation(moveDuration: moveDuration, Model: Model)
            case "left":
                let rotateToAngle = simd_quatf(angle: GLKMathDegreesToRadians(90), axis: SIMD3(x: 0, y: 1, z: 0))
                Model.setOrientation(rotateToAngle, relativeTo: Model)
            case "right":
                let rotateToAngle = simd_quatf(angle: GLKMathDegreesToRadians(-90), axis: SIMD3(x: 0, y: 1, z: 0))
                Model.setOrientation(rotateToAngle, relativeTo: Model)
        default:
            print("No movement commands")
        }
    }
        
    func walkAnimation(moveDuration: Double, Model: Entity){
        
        if let robotAnimation = Model.availableAnimations.first{
            //play the animation
            Model.playAnimation(robotAnimation.repeat(duration: moveDuration), transitionDuration: 0.5, startsPaused: false)
        }else{
            print("No animation present in USDZ animation")
        }
    }
        
    func startSpeechRecognition(){
        //1. Permission
        requestPermission()
        //2. Audio Record
        startAudioRecording()
        //3. Speech Recognition
        speechRecognize()
    }
        
        

    func requestPermission(){
        
        SFSpeechRecognizer.requestAuthorization{(authorizationStatus) in
            
            if (authorizationStatus == .authorized){
                print("Authorized")
            }else if (authorizationStatus == .denied){
                print("Dedied")
            }else if (authorizationStatus == .notDetermined){
                print("Waiting")
            }else if (authorizationStatus == .restricted){
                print("Speech Recognition not available")
            }
        }
    }
        
        
    func startAudioRecording(){
        //Input node
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { (buffer, _) in
            //Pass the audio samples to Speech Recognition
            self.speechRequest.append(buffer)
        }
        //Audio Engine start
        do{
        //try audioSession.setPrefersNoInterruptionsFromSystemAlerts(true)
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            audioEngine.prepare()
            try audioEngine.start()
        
        }catch{
            
        }
    }
        
        
    func speechRecognize(){
        
        //Availability?
        guard let speechRecognizer = SFSpeechRecognizer() else{
            print("Speech recognizer not available")
            return
        }
        
        if (speechRecognizer.isAvailable == false){
            print("Temporarily not working")
        }
        //Task (recognized text)
        var count = 0
        speechTask = speechRecognizer.recognitionTask(with: speechRequest, resultHandler: { (result,error) in
            
            count = count + 1
            if (count == 1){
            
                //get last word spoken
                guard let result = result else{return}
                let recognizedText = result.bestTranscription.segments.last
            
            //robot move
                self.move(direction: recognizedText!.substring, Model: self.SpecialModel!)
            }else if (count>=3){
                count = 0
            }
            
        })
    }
        
    func removeAllentities(){
        arView.scene.anchors.removeAll()
    }

}
