//
//  GameScene.swift
//  Extra Letter
//
//  Created by Apurva Patel on 8/31/17.
//  Copyright © 2017 Apurva Patel. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds
class GameScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate, GADInterstitialDelegate, GADBannerViewDelegate{
    
    var interstital : GADInterstitial!

    
    var string = [String] ()
    var stringArray = [String] ()
    
    let PLAYER_CATEGORY: UInt32 = 0
    let WORDS_CATEGORY: UInt32 = 1
    let SPEECH_ACTIVATOR_CATEGORY: UInt32 = 2
    let ACTIVATE_THIS_CATEGORY: UInt32 = 3
    
    let speakTalk = AVSpeechSynthesizer()
    
    var anLabelNodes : AN_LABEL_NODE!
    var xtraLabelNodes : XTRA_LABEL_NODE!
    var letterLabelNodes : LETTER_LABEL_NODE!
    
    var gameOver = false
    var gameStarted = false
    
    func speakThisWord (speakThis: String) {
        if gameOver == false {
            let speechUtterance = AVSpeechUtterance(string : speakThis)
            speechUtterance.rate = 0.50
            speechUtterance.pitchMultiplier = 1.0
            speechUtterance.volume = 0.75
            speakTalk.speak(speechUtterance)
        }
    }
    
    func addGameName () {
        anLabelNodes = AN_LABEL_NODE()
        anLabelNodes.name = "An"
        xtraLabelNodes = XTRA_LABEL_NODE()
        xtraLabelNodes.name = "extra"
        anLabelNodes.addChild(xtraLabelNodes)
        letterLabelNodes = LETTER_LABEL_NODE()
        letterLabelNodes.name = "Letter"
        anLabelNodes.addChild(letterLabelNodes)
        addChild(anLabelNodes)
    }
    
    var statsData = SKSpriteNode ()
    func StatsNode () {
        statsData = SKSpriteNode(imageNamed: "StatsIcon")
        statsData.position = CGPoint (x: -150, y: -480)
        statsData.size = CGSize(width: 75, height: 75)
        statsData.name = "StatsIcon"
        addChild(statsData)
    }
    
    var statsInt = Int ()
    var checkStates = 0
    var afterStats = SKLabelNode()
    func afterClickOnStats () {
        afterStats = SKLabelNode(fontNamed: "Helvetica")
        afterStats.fontColor = UIColor.black
        afterStats.fontSize = 60
        afterStats.text = "afterStats"
        afterStats.position = CGPoint(x: 0, y: 100)
        afterStats.horizontalAlignmentMode = .center
        afterStats.verticalAlignmentMode = .center
        addChild(afterStats)
    }
    
    var howToPlayIcon = SKSpriteNode()
    func howToPlayNode () {
        howToPlayIcon = SKSpriteNode(imageNamed: "HowToPlay1")
        howToPlayIcon.position = CGPoint(x: 150, y: -480)
        howToPlayIcon.size = CGSize (width: 75, height: 75)
        howToPlayIcon.name = "HowToPlayIcon"
        addChild(howToPlayIcon)
    }
    
    var howToPlayData = SKSpriteNode()
    func howToPlayDataNode () {
        howToPlayData = SKSpriteNode(imageNamed: "HowToData")
        howToPlayData.position = CGPoint(x: 0, y: 0)
        howToPlayData.size = CGSize (width : 700, height : 1100)
        howToPlayData.zPosition = -7
        howToPlayData.name = "howToPlayData"
        addChild(howToPlayData)
    }
    
    var back = SKSpriteNode ()
    func backFromHowToPlay () {
        back = SKSpriteNode(imageNamed: "Back1")
        back.position = CGPoint(x: -300, y: 580)
        back.name = "Back"
        back.size = CGSize(width: 100, height : 50)
        back.zPosition = 10
        addChild(back)
    }
    
    var HighScore = Int ()
    var highScoreLabel = SKLabelNode()
    func addHighScoreLabel () {
        highScoreLabel = SKLabelNode(fontNamed: "Courier")
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.fontSize = 80
        highScoreLabel.name = "High Score"
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.position = CGPoint(x: 0, y: -100)
        addChild(highScoreLabel)
    }
    
    //Reading from myWords.txt
    func linesFromResourceForced(fileName: String) -> [String] {
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let content = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        stringArray = content.components(separatedBy: "\n")
        return content.components(separatedBy: "\n")
    }
    //Removing duplicate words
    func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
    //Search Algorithm
    func binarySearch<T:Comparable>(inputArr:Array<T>, searchItem: T) -> String {
        var lowerIndex = 0;
        var upperIndex = inputArr.count - 1
        
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex] == searchItem) {
                return inputArr[currentIndex] as! String
            } else if (lowerIndex > upperIndex) {
                return "Not Found"
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    //For SpriteNodes
    var speakWord = SKShapeNode()
    
    func SpriteNodes () {
        let randomNum4Word = Int (arc4random_uniform(UInt32(stringArray.count)))
        var randomWordIs = stringArray[randomNum4Word]
        let speakThisWord = randomWordIs
        let AtoZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomNum4AtoZ = arc4random_uniform(26)
        let ind = AtoZ.index(AtoZ.startIndex, offsetBy: String.IndexDistance(randomNum4AtoZ))
        let  addLetter : Character = AtoZ[ind]
        let pickPlace4addLetter = arc4random_uniform(UInt32(Int (randomWordIs.characters.count + 1)))
        randomWordIs.insert(addLetter, at: randomWordIs.index(randomWordIs.startIndex, offsetBy: String.IndexDistance(pickPlace4addLetter)))
        var xPositions = [-300, -150 , 0, 150 , 300]
        
        var wordSprite = SKShapeNode()
        var wordLabel = SKLabelNode()
        var pointOfContact = SKShapeNode()
        spriteColorsFunc()
        for i in 0 ..< randomWordIs.characters.count{
            wordSprite = SKShapeNode (rectOf: CGSize (width: 150, height: 150), cornerRadius: 20)
            wordSprite.fillColor = UIColor.clear
            wordSprite.strokeColor = UIColor.clear
            wordSprite.zPosition = 0
            wordSprite.position = CGPoint(x: xPositions[i], y: 720)
            wordSprite.name = randomWordIs
            wordSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 140, height : 150))
            wordSprite.physicsBody?.isDynamic = true
            wordSprite.physicsBody?.affectedByGravity = true
            wordSprite.physicsBody?.allowsRotation = false
            wordSprite.physicsBody?.categoryBitMask = WORDS_CATEGORY
            wordSprite.physicsBody?.collisionBitMask = 0
            
            pointOfContact = SKShapeNode(rectOf: CGSize (width: 140, height: 150), cornerRadius: 20)
            pointOfContact.fillColor = spriteColors[i]
            pointOfContact.strokeColor = spriteColors[i]
            pointOfContact.zPosition = -3
            
            wordLabel = SKLabelNode(fontNamed: "Helvetica")
            wordLabel.text = String (randomWordIs[randomWordIs.index(randomWordIs.startIndex, offsetBy: String.IndexDistance(i))])
            wordLabel.fontSize = 90
            wordLabel.fontColor = UIColor.black
            wordLabel.zPosition = -1
            wordLabel.horizontalAlignmentMode = .center
            wordLabel.verticalAlignmentMode = .center
            
            speakWord = SKShapeNode(rectOf: CGSize(width: 150, height: 155), cornerRadius: 10)
            speakWord.fillColor = UIColor.clear
            speakWord.strokeColor = UIColor.clear
            speakWord.name = speakThisWord
            speakWord.zPosition = -4
            speakWord.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 155))
            speakWord.physicsBody?.isDynamic = true
            speakWord.physicsBody?.affectedByGravity = true
            speakWord.physicsBody?.restitution = 0
            speakWord.physicsBody?.allowsRotation = false
            speakWord.physicsBody?.categoryBitMask = WORDS_CATEGORY
            speakWord.physicsBody?.collisionBitMask = 4
            wordSprite.addChild(pointOfContact)
            wordSprite.addChild(wordLabel)
            wordSprite.addChild(speakWord)
            addChild(wordSprite)
        }
    }
    
    func activateSpeech () {
        let speechActivator = SKShapeNode (rectOf: CGSize (width: 10, height : 10), cornerRadius: 1)
        speechActivator.fillColor = UIColor.clear
        speechActivator.strokeColor = UIColor.clear
        speechActivator.position = CGPoint(x: 0, y: 50)
        speechActivator.zPosition = 0
        speechActivator.name = "SpeechAvtivator"
        speechActivator.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: 11, height: 11))
        speechActivator.physicsBody?.isDynamic = false
        speechActivator.physicsBody?.affectedByGravity = false
        speechActivator.physicsBody?.restitution = 0
        speechActivator.physicsBody?.categoryBitMask = SPEECH_ACTIVATOR_CATEGORY
        speechActivator.physicsBody?.contactTestBitMask = WORDS_CATEGORY
        speechActivator.physicsBody?.collisionBitMask = 0
        addChild(speechActivator)
    }
    
    var ScoreLabelNode = SKLabelNode()
    var Score = Int ()
    func ScoreLabel () {
        ScoreLabelNode = SKLabelNode(fontNamed: "Courier")
        ScoreLabelNode.fontColor = UIColor.black
        ScoreLabelNode.fontSize = 85
        ScoreLabelNode.name = "ScoreLabelNode"
        ScoreLabelNode.position = CGPoint(x: 260, y: 600)
        Score = 0
        ScoreLabelNode.text = String(Score)
        addChild(ScoreLabelNode)
    }
    
    var checkMissed = 0
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.collisionBitMask == 4 {
            //print (contact.bodyB.node?.name)
            if contact.bodyA.node?.name != "GameOverNode" {
            speakThisWord(speakThis: (contact.bodyB.node?.name)!)
            }
            else {
                if checkMissed == 2 {
                gameOver = true
                gameOverFunc()
                print ("Touched")
                    PlayAdCounter = PlayAdCounter + 1
                    print ("PlayAdCounter : \(PlayAdCounter)")
                    if (PlayAdCounter % 3 == 0) {
                        playMyAd()
                    }
                }
                else if checkMissed == 1 {
                missedSignal2.fillColor = UIColor.red
                missedSignal2.strokeColor = UIColor.red
                }
                else if checkMissed == 0 {
                missedSignal1.fillColor = UIColor.red
                missedSignal1.strokeColor = UIColor.red
                }
                checkMissed = checkMissed + 1
            }
        }
    }
    func createNewAd () -> GADInterstitial {
        interstital = GADInterstitial(adUnitID: "ca-app-pub-1254075662388987/3960539668")
        let request = GADRequest()
        interstital.load(request)
        return interstital
    }
    func playMyAd () {
        if (interstital.isReady)
        {
            let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
            self.interstital.present(fromRootViewController: currentViewController)
        }
        interstital = createNewAd()
    }
    
    var PlayAdCounter = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            var newString = String()
            var forRemoveSafely = String()
            var trueAnswer = String()
            
            if atPoint(location).name == "Tap to start" {
                
                var coordinationX = [Int] ()
                var coordinationY = [Int] ()
                
                coordinationX = [20, -20, -20, 20]
                coordinationY = [30, 30, -30, -30]
                var roundShape = SKShapeNode()
                spriteColorsFunc()
                for i in 0 ..< 4{
                    roundShape = SKShapeNode(circleOfRadius: 8)
                    roundShape.fillColor = spriteColors[i]
                    roundShape.strokeColor = roundShape.fillColor
                    roundShape.position = node.position
                    let action1 = SKAction.moveBy(x: CGFloat(coordinationX[i]), y: CGFloat(coordinationY[i]), duration: 0.3)
                    roundShape.run(action1)
                    addChild(roundShape)
                    let wait = SKAction.wait(forDuration: 0.5)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([wait, remove])
                    roundShape.run(sequence)
                    
                }
                tapToStart.isHidden = true
                anLabelNodes.isHidden = true
                xtraLabelNodes.isHidden = true
                letterLabelNodes.isHidden = true
                GameOverNode()
                if tapToStart.text == "Tap to restart" {
                    print ("YES")
                    for child in children {
                    if child.position.y < 800 {
                        if child.name == "Tap to start" {
                        }
                        else if child.name == "Final Score" {
                            finalScore.text = " "
                        }
                        else if child.name == "ScoreLabelNode" {
                        }
                        else if child.name == "High Score"{
                        }
                        else if child.name == "GameOverNode" {
                        }
                        else if child.name == "SpeechAvtivator"{
                        }
                        else if child.name == "StatsIcon" {
                            print ("Checked StatsIcon")
                        }
                        else if child.name == "HowToPlayIcon" {
                            print ("Checked Howtoplayicon")
                        }
                        else if child.name == "An" {
                            print ("Checked An")
                        }
                        else if child.name == "extra" {
                            print ("Checked Extra")
                        }
                        else if child.name == "Letter" {
                            print ("Checked Letter")
                        }
                        else if child.name == "Missed1" {
                        }
                        else if child.name == "Missed2" {
                        }
                        else {
                        child.removeFromParent()
                        }
                    }
                }
                }
                TimerFunc()
                CorrectWordNode.isHidden = true
                physicsWorld.gravity = CGVector (dx: 0, dy: -1)
                gameOver = false
                ScoreLabel()
                highScoreLabel.isHidden = true
                statsData.isHidden = true
                howToPlayIcon.isHidden = true
                back.isHidden = true
                gameStarted = true
                MissedFunc()
                checkMissed = 0
                finalScore.isHidden = true
            }
            
            if atPoint(location).name == "HowToPlayIcon" {
                tapToStart.isHidden = true
                anLabelNodes.isHidden = true
                xtraLabelNodes.isHidden = true
                letterLabelNodes.isHidden = true
                finalScore.isHidden = true
                highScoreLabel.isHidden = true
                statsData.isHidden = true
                howToPlayIcon.isHidden = true
                howToPlayDataNode()
                backFromHowToPlay()
            }
            
            if atPoint(location).name == "Back" {
                print ("Back button")
                tapToStart.text = "Tap to start"
                tapToStart.isHidden = false
                
                anLabelNodes.isHidden = false
                xtraLabelNodes.isHidden = false
                letterLabelNodes.isHidden = false

               // finalScore.isHidden = false
                highScoreLabel.isHidden = false
                statsData.isHidden = false
                howToPlayIcon.isHidden = false
                howToPlayData.isHidden = true
                back.isHidden = true
                finalScore.isHidden = true
                CorrectWordNode.isHidden = true
                afterStats.isHidden = true
                
                if back.isHidden == true{
                    print ("Back button 0")
                    for child in children {
                        print ("Back remove 1")
                        if child.position.y < 800 {
                            if child.name == "Tap to start" {
                                print ("Checked Tap To start")
                            }
                            else if child.name == "Final Score" {
                                print ("Chedcked final Score")
                            }
                            else if child.name == "ScoreLabelNode" {
                                print ("Checked ScoreLabelNode")
                            }
                            else if child.name == "High Score"{
                                print ("Checked HighScore")
                            }
                            else if child.name == "StatsIcon" {
                                print ("Checked StatsIcon")
                            }
                            else if child.name == "HowToPlayIcon" {
                                print ("Checked Howtoplayicon")
                            }
                            else if child.name == "An" {
                                print ("Checked An")
                            }
                            else if child.name == "extra" {
                                print ("Checked Extra")
                            }
                            else if child.name == "Letter" {
                                print ("Checked Letter")
                            }
                            else if child.name == "SpeechAvtivator"{
                            }
                            else if child.name == "Missed1" {
                            }
                            else if child.name == "Missed2" {
                            }
                            else {
                                print ("Back remove")
                                child.removeFromParent()
                            }
                        }
                    }
                }
            }
            if atPoint(location).name == "StatsIcon" {
                tapToStart.isHidden = true
                anLabelNodes.isHidden = true
                xtraLabelNodes.isHidden = true
                letterLabelNodes.isHidden = true
                finalScore.isHidden = true
                highScoreLabel.isHidden = true
                statsData.isHidden = true
                howToPlayIcon.isHidden = true
                backFromHowToPlay()
                afterStats.isHidden = false
                //afterClickOnStats()
                
            }
            if node.physicsBody?.categoryBitMask == WORDS_CATEGORY && finalScore.isHidden == true{
                newString = node.name!
                trueAnswer = newString
                forRemoveSafely = newString
                node.removeFromParent()
                
                var coordinationX = [Int] ()
                var coordinationY = [Int] ()

                coordinationX = [20, -20, -20, 20]
                coordinationY = [30, 30, -30, -30]
                var roundShape = SKShapeNode()
                spriteColorsFunc()
                for i in 0 ..< 4{
                    roundShape = SKShapeNode(circleOfRadius: 8)
                    roundShape.fillColor = spriteColors[i]
                    roundShape.strokeColor = roundShape.fillColor
                    roundShape.position = node.position
                    let action1 = SKAction.moveBy(x: CGFloat(coordinationX[i]), y: CGFloat(coordinationY[i]), duration: 0.3)
                    roundShape.run(action1)
                    addChild(roundShape)
                    let wait = SKAction.wait(forDuration: 0.5)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([wait, remove])
                    roundShape.run(sequence)
                }
                
                if location.x >= -375 &&  location.x <= -225 {
                    let ind = newString.index(newString.startIndex, offsetBy: String.IndexDistance(0))
                    newString.remove(at: ind)
                    print (newString)
                    let answerFromBinSearch = binarySearch(inputArr: stringArray, searchItem: String (newString))
                    if (answerFromBinSearch == "Not Found") {
                        gameStarted = false
                        gameOver = true
                        gameOverFunc()
                        print ("Game Over")
                        TheCorrectWordWas(correctWord: trueAnswer)
                        PlayAdCounter = PlayAdCounter + 1
                        print ("PlayAdCounter : \(PlayAdCounter)")
                        if (PlayAdCounter % 3 == 0) {
                        playMyAd()
                        }
                    }
                    else {
                        if location.y >= 0 {
                            Score = Score + 5
                        }
                        else {
                            Score = Score + 1
                        }
                        ScoreLabelNode.text = String(Score)
                        removeSafely(spriteName: forRemoveSafely)
                    }
                }
                else if location.x >= -224 &&  location.x <= -74 {
                    let ind = newString.index(newString.startIndex, offsetBy: String.IndexDistance(1))
                    newString.remove(at: ind)
                    print (newString)
                    let answerFromBinSearch = binarySearch(inputArr: stringArray, searchItem: String (newString))
                    if (answerFromBinSearch == "Not Found") {
                        gameStarted = false
                        gameOver = true
                        gameOverFunc()
                        print ("Game Over")
                        TheCorrectWordWas(correctWord: trueAnswer)
                        PlayAdCounter = PlayAdCounter + 1
                        print ("PlayAdCounter : \(PlayAdCounter)")
                        if (PlayAdCounter % 3 == 0) {
                            playMyAd()
                        }                    }
                    else {
                        if location.y >= 0 {
                            Score = Score + 5
                        }
                        else {
                            Score = Score + 1
                        }
                        checkStates = checkStates + 1
                        ScoreLabelNode.text = String(Score)
                        removeSafely(spriteName: forRemoveSafely)
                    }
                }
                else if location.x >= -75 && location.x <= 74 {
                    let ind = newString.index(newString.startIndex, offsetBy: String.IndexDistance(2))
                    newString.remove(at: ind)
                    print (newString)
                    let answerFromBinSearch = binarySearch(inputArr: stringArray, searchItem: String (newString))
                    if (answerFromBinSearch == "Not Found") {
                        gameStarted = false
                        gameOver = true
                        gameOverFunc()
                        print ("Game Over")
                        TheCorrectWordWas(correctWord: trueAnswer)
                        PlayAdCounter = PlayAdCounter + 1
                        print ("PlayAdCounter : \(PlayAdCounter)")
                        if (PlayAdCounter % 3 == 0) {
                            playMyAd()
                        }
                    }
                    else {
                        if location.y >= 0 {
                            Score = Score + 5
                        }
                        else {
                            Score = Score + 1
                        }
                        checkStates = checkStates + 1
                        ScoreLabelNode.text = String(Score)
                        removeSafely(spriteName: forRemoveSafely)
                    }
                }
                else if location.x >= 75 && location.x <= 224 {
                    let ind = newString.index(newString.startIndex, offsetBy: String.IndexDistance(3))
                    newString.remove(at: ind)
                    print (newString)
                    let answerFromBinSearch = binarySearch(inputArr: stringArray, searchItem: String (newString))
                    if (answerFromBinSearch == "Not Found") {
                        gameStarted = false
                        gameOver = true
                        gameOverFunc()
                        print ("Game Over")
                        TheCorrectWordWas(correctWord: trueAnswer)
                        PlayAdCounter = PlayAdCounter + 1
                        print ("PlayAdCounter : \(PlayAdCounter)")
                        if (PlayAdCounter % 3 == 0) {
                            playMyAd()
                        }
                    }
                    else {
                        if location.y >= 0 {
                            Score = Score + 5
                        }
                        else {
                            Score = Score + 1
                        }
                        checkStates = checkStates + 1
                        ScoreLabelNode.text = String(Score)
                        removeSafely(spriteName: forRemoveSafely)
                    }
                }
                else if location.x >= 225 && location.x <= 375 {
                    let ind = newString.index(newString.startIndex, offsetBy: String.IndexDistance(4))
                    newString.remove(at: ind)
                    print (newString)
                    let answerFromBinSearch = binarySearch(inputArr: stringArray, searchItem: String (newString))
                    if (answerFromBinSearch == "Not Found") {
                        gameStarted = false
                        gameOver = true
                        gameOverFunc()
                        print ("Game Over")
                        TheCorrectWordWas(correctWord: trueAnswer)
                        PlayAdCounter = PlayAdCounter + 1
                        print ("PlayAdCounter : \(PlayAdCounter)")
                        if (PlayAdCounter % 3 == 0) {
                            playMyAd()
                        }
                    }
                    else {
                        if location.y >= 0 {
                            Score = Score + 5
                        }
                        else {
                            Score = Score + 1
                        }
                        checkStates = checkStates + 1
                        ScoreLabelNode.text = String(Score)
                        removeSafely(spriteName: forRemoveSafely)
                    }
                }
            }
        }
    }
    
    var tapToStart = SKLabelNode()
    func tapToStartFunc()  {
        tapToStart = SKLabelNode (text: "Tap to start")
        tapToStart.fontSize = 80
        tapToStart.fontColor = UIColor.black
        tapToStart.fontName = "Helvetica"
        tapToStart.name = "Tap to start"
        tapToStart.position = CGPoint(x: 0, y: -300)
        tapToStart.zPosition = 10
        let animate = SKAction.sequence([SKAction.fadeIn(withDuration: 0.7), SKAction.fadeOut(withDuration: 0.7)])
        tapToStart.run(SKAction.repeatForever(animate))
        addChild(tapToStart)
    }
    
    var timerForWord : Timer!
    let app = UIApplication.shared
    
    override func didMove(to view: SKView) {
        StatsNode()
        howToPlayNode()
        afterClickOnStats()
        tapToStartFunc()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.1)
        backgroundColor = UIColor.white
        addGameName()
        string = linesFromResourceForced(fileName: "myWords")
        stringArray.sort()
        stringArray = uniqueElementsFrom(array: stringArray)
        activateSpeech()
        addHighScoreLabel()
        //Register for the applicationWillResignActive anywhere in your app.
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationWillResignActive(notification:)), name: NSNotification.Name.UIApplicationWillResignActive, object: app)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: app)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationDidBecomeActive(notification:)), name : Notification.Name.UIApplicationDidBecomeActive, object: app)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector (GameScene.removeFromGame), userInfo: nil, repeats: true)
        
        if (HighScoreDefault.value(forKey: "HighScore") != nil ){
            HighScore = HighScoreDefault.value(forKey: "HighScore") as! Int
            highScoreLabel.text = "HighScore:\(String(HighScore))"
        }
        if (afterStatsDefault.value(forKey: "statsInt") != nil) {
            statsInt = afterStatsDefault.value(forKey: "statsInt") as! Int
            afterStats.text = "Mastered Words \(statsInt) of \(stringArray.count)"
        }
        if (afterStatsDefault.value(forKey: "statsInt") == nil) {
            //statsInt = afterStatsDefault.value(forKey: "statsInt") as! Int
            //afterStats.text = "Mastered Words \(statsInt) of \(stringArray.count)"
        }
        afterStats.isHidden = true
        interstital = GADInterstitial(adUnitID: "ca-app-pub-1254075662388987/3960539668")
        let request = GADRequest()
        interstital.load(request)
    }
    
    var tm : Double = 1.4
    var gForce : CGFloat = -1
    func SpeedUp () {
        timerForWord = Timer.scheduledTimer(timeInterval: tm, target: self, selector: #selector(GameScene.SpriteNodes), userInfo: nil, repeats: true)
        tm = tm - 0.1
        physicsWorld.gravity = CGVector(dx: 0, dy : gForce)
        gForce = gForce - 0.1
    }
    
    func TimerFunc () {
        timerForWord = Timer.scheduledTimer(timeInterval: 1.7, target: self, selector: #selector(GameScene.SpriteNodes), userInfo: nil, repeats: true)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        if tapToStart.isHidden == true {
            if tapToStart.isHidden == true && statsData.isHidden == true && howToPlayIcon.isHidden == true {
                if (afterStats.isHidden == false && back.isHidden == false) {
                    print ("DeActive - This IS 1")
                }
                else if (howToPlayData.isHidden == false && back.isHidden == false) {
                    print ("DeActive - This IS 2")
                }
                else {
                    print ("Diactivating timer")
                    timerForWord.invalidate()
                    physicsWorld.gravity = CGVector (dx: 0, dy: 0)
                }
            }
            else if tapToStart.isHidden == true && howToPlayData.isHidden == false {
                print ("ResignActive - howtoPlay is hidden false")
            }
                
            else if tapToStart.isHidden == true && afterStats.isHidden == false {
                print ("ResignActive - afterStats is hidden false")
            }
        }
        else {
            print ("Game not started so nothing deActivated.")
        }
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        if tapToStart.isHidden == true {
            if tapToStart.isHidden == true && statsData.isHidden == true && howToPlayIcon.isHidden == true {
                
                if (afterStats.isHidden == false && back.isHidden == false) {
                    print ("Active - This IS 1")
                }
                else if (howToPlayData.isHidden == false && back.isHidden == false) {
                    print ("Active - This IS 2")
                }
                else {
                    print ("Active - Activating Timer and Physic gravity")
                    TimerFunc()
                    physicsWorld.gravity = CGVector(dx: 0, dy : -1.1)
                }
            }
            if tapToStart.isHidden == true && afterStats.isHidden == false {
                print ("Active - afterStats is hidden false")
            }
            else if tapToStart.isHidden == true && howToPlayData.isHidden == false {
                print ("Active - howToPlay is hidden false")
            }
        }
        else {
            print ("Active - Not started")
        }
    }
    
    var CorrectWordNode = SKLabelNode()
    func TheCorrectWordWas (correctWord : String) {
        for i in 0 ..< correctWord.characters.count {
            var check = correctWord
            let ind = check.index(check.startIndex, offsetBy: String.IndexDistance(i))
            check.remove(at: ind)
            let finalAnswer = binarySearch(inputArr: stringArray, searchItem: check)
            if (finalAnswer == "Not Found") {
                
            }
            else {
                CorrectWordNode = SKLabelNode(fontNamed: "Helvetica")
                CorrectWordNode.fontSize = 90
                CorrectWordNode.fontColor = UIColor.black
                CorrectWordNode.text = check
                CorrectWordNode.name = "CorrectWordNode"
                CorrectWordNode.horizontalAlignmentMode = .center
                CorrectWordNode.verticalAlignmentMode = .center
                CorrectWordNode.position = CGPoint(x: 0 , y: 400)
                addChild(CorrectWordNode)
                break
            }
        }
    }
    var spriteColors = [UIColor]()
    func spriteColorsFunc () {
        let randomColorNum = arc4random_uniform(10)
        switch (randomColorNum) {
        case 0:
            spriteColors = [
                UIColor(red: 172/255, green: 249/255, blue: 217/255, alpha: 1),
                UIColor(red: 116/255, green: 247/255, blue: 140/255, alpha: 1),
                UIColor(red: 171/255, green: 223/255, blue: 117/255, alpha: 1),
                UIColor(red: 96/255 , green: 105/255, blue: 92/255, alpha: 1),
                UIColor(red: 197/255, green: 214/255, blue: 216/255, alpha: 1),
            ]
            break
        case 1:
            spriteColors = [
                UIColor(red: 198/255, green: 226/255, blue: 233/255, alpha: 1),
                UIColor(red: 241/255, green: 255/255, blue: 196/255, alpha: 1),
                UIColor(red: 255/255, green: 202/255, blue: 175/255, alpha: 1),
                UIColor(red: 142/255 , green: 227/255, blue: 239/255, alpha: 1),
                UIColor(red: 218/255, green: 184/255, blue: 148/255, alpha: 1),
            ]
            break
        case 2:
            spriteColors = [
                UIColor(red: 83/255, green: 87/255, blue: 158/255, alpha: 1),
                UIColor(red: 72/255, green: 169/255, blue: 166/255, alpha: 1),
                UIColor(red: 228/255, green: 223/255, blue: 218/255, alpha: 1),
                UIColor(red: 201/255 , green: 109/255, blue: 106/255, alpha: 1),
                UIColor(red: 212/255, green: 180/255, blue: 131/255, alpha: 1),
            ]
            break
        case 3:
            spriteColors = [
                UIColor(red: 107/255, green: 151/255, blue: 255/255, alpha: 1),
                UIColor(red: 221/255, green: 70/255, blue: 81/255, alpha: 1),
                UIColor(red: 253/255, green: 202/255, blue: 64/255, alpha: 1),
                UIColor(red: 187/255 , green: 88/255, blue: 230/255, alpha: 1),
                UIColor(red: 130/255, green: 113/255, blue: 130/255, alpha: 1),
            ]
            break
        case 4:
            spriteColors = [
                UIColor(red: 236/255, green: 203/255, blue: 217/255, alpha: 1),
                UIColor(red: 225/255, green: 239/255, blue: 246/255, alpha: 1),
                UIColor(red: 151/255, green: 210/255, blue: 251/255, alpha: 1),
                UIColor(red: 131/255 , green: 188/255, blue: 255/255, alpha: 1),
                UIColor(red: 128/255, green: 255/255, blue: 232/255, alpha: 1),
            ]
            break
        case 5:
            spriteColors = [
                UIColor(red: 94/255, green: 252/255, blue: 141/255, alpha: 1),
                UIColor(red: 131/255, green: 119/255, blue: 209/255, alpha: 1),
                UIColor(red: 151/255, green: 210/255, blue: 251/255, alpha: 1),
                UIColor(red: 109/255 , green: 90/255, blue: 114/255, alpha: 1),
                UIColor(red: 128/255, green: 255/255, blue: 232/255, alpha: 1),
            ]
            break
        case 6:
            spriteColors = [
                UIColor(red: 252/255, green: 236/255, blue: 201/255, alpha: 1),
                UIColor(red: 252/255, green: 176/255, blue: 179/255, alpha: 1),
                UIColor(red: 249/255, green: 57/255, blue: 67/255, alpha: 1),
                UIColor(red: 126/255 , green: 178/255, blue: 221/255, alpha: 1),
                UIColor(red: 68/255, green: 94/255, blue: 147/255, alpha: 1),
            ]
            break
        case 7:
            spriteColors = [
                UIColor(red: 68/255, green: 118/255, blue: 4/255, alpha: 1),
                UIColor(red: 108/255, green: 197/255, blue: 81/255, alpha: 1),
                UIColor(red: 159/255, green: 252/255, blue: 223/255, alpha: 1),
                UIColor(red: 82/255 , green: 173/255, blue: 156/255, alpha: 1),
                UIColor(red: 71/255, green: 98/255, blue: 79/255, alpha: 1),
            ]
            break
        case 8:
            spriteColors = [
                UIColor(red: 117/255, green: 244/255, blue: 244/255, alpha: 1),
                UIColor(red: 144/255, green: 224/255, blue: 243/255, alpha: 1),
                UIColor(red: 184/255, green: 179/255, blue: 233/255, alpha: 1),
                UIColor(red: 217/255 , green: 153/255, blue: 185/255, alpha: 1),
                UIColor(red: 209/255, green: 123/255, blue: 136/255, alpha: 1),
            ]
            break
        case 9:
            spriteColors = [
                UIColor(red: 255/255, green: 253/255, blue: 130/255, alpha: 1),
                UIColor(red: 255/255, green: 155/255, blue: 113/255, alpha: 1),
                UIColor(red: 232/255, green: 72/255, blue: 85/255, alpha: 1),
                UIColor(red: 181/255 , green: 107/255, blue: 69/255, alpha: 1),
                UIColor(red: 43/255, green: 58/255, blue: 103/255, alpha: 1),
            ]
            break
        default:
            spriteColors = [
                UIColor(red: 172/255, green: 249/255, blue: 217/255, alpha: 1),
                UIColor(red: 116/255, green: 247/255, blue: 140/255, alpha: 1),
                UIColor(red: 171/255, green: 223/255, blue: 117/255, alpha: 1),
                UIColor(red: 96/255 , green: 105/255, blue: 92/255, alpha: 1),
                UIColor(red: 197/255, green: 214/255, blue: 216/255, alpha: 1),
            ]
            break
        }
    }
    func removeSafely (spriteName : String) {
        for child in children {
            if child.name == spriteName {
                child.removeFromParent()
            }
        }
    }
    func removeFromGame () {
        for child in children {
            if child.position.y < -1000 {
                child.removeFromParent()
            }
        }
    }
    var finalScore = SKLabelNode()
    var HighScoreDefault = UserDefaults.standard
    var afterStatsDefault = UserDefaults.standard
    func gameOverFunc () {
        if gameOver == true {
            gameStarted = false
            backFromHowToPlay()
            physicsWorld.gravity = CGVector (dx: 0, dy: 0)
            timerForWord.invalidate()
            tapToStart.isHidden = false
            tapToStart.text = "Tap to restart"
            finalScore = SKLabelNode(fontNamed : "Courier")
            finalScore.fontSize = 450
            finalScore.fontColor = UIColor.blue
            finalScore.name = "Final Score"
            finalScore.position = CGPoint(x: 0, y: 0)
            finalScore.text = ScoreLabelNode.text
            addChild(finalScore)
            print (Score)
            highScoreLabel.isHidden = false
            //highScoreLabel.text = ScoreLabelNode.text
            ScoreLabelNode.text = " "
            gameOverSprite.removeFromParent()
            missedSignal1.removeFromParent()
            missedSignal2.removeFromParent()
            if Score > HighScore {
                HighScore = Score
                highScoreLabel.text = "HighScore: \(String (HighScore))"
                HighScoreDefault.set(HighScore, forKey: "HighScore")
                HighScoreDefault.synchronize()
            }
            if checkStates > statsInt {
                statsInt = checkStates
                afterStats.text = String(statsInt)
                afterStatsDefault.set(statsInt, forKey: "statsInt")
                afterStatsDefault.synchronize()
            }
        }
        else if gameOver == false {
        }
    }
    
    var gameOverSprite = SKShapeNode()
    
    func GameOverNode () {
        gameOverSprite = SKShapeNode (rectOf: CGSize (width : 100, height: 100))
        gameOverSprite.fillColor = UIColor.blue
        gameOverSprite.strokeColor = UIColor.blue
        gameOverSprite.name = "GameOverNode"
        gameOverSprite.position = CGPoint (x: 0, y: -720)
        gameOverSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: 100, height : 100))
        gameOverSprite.physicsBody?.categoryBitMask = PLAYER_CATEGORY
        gameOverSprite.physicsBody?.contactTestBitMask = WORDS_CATEGORY
        gameOverSprite.physicsBody?.collisionBitMask = 0
        gameOverSprite.physicsBody?.isDynamic = false
        gameOverSprite.physicsBody?.affectedByGravity = false
        addChild(gameOverSprite)
    }
    
    var missedSignal1 = SKShapeNode ()
    var missedSignal2 = SKShapeNode ()
    func MissedFunc () {
        missedSignal1 = SKShapeNode (circleOfRadius: 20)
        missedSignal1.fillColor = UIColor.gray
        missedSignal1.strokeColor = UIColor.gray
        missedSignal1.position = CGPoint (x: -300, y: 600)
        missedSignal1.zPosition = -5
        missedSignal1.name = "Missed1"
        addChild(missedSignal1)
        
        missedSignal2 = SKShapeNode(circleOfRadius: 20)
        missedSignal2.fillColor = UIColor.gray
        missedSignal2.strokeColor = UIColor.gray
        missedSignal2.position = CGPoint(x: -250, y: 600)
        missedSignal2.zPosition = -5
        missedSignal2.name = "Missed2"
        addChild(missedSignal2)
    }
    override func update(_ currentTime: TimeInterval) {
        /*if gameStarted == true {
            for child in children {
            if child.position.y < -720{
                //child.removeFromParent()
                gameOver = true
                gameOverFunc()
            }
            }
        }
    }*/
    }
}
