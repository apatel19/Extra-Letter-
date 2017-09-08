//
//  TheMainPage.swift
//  anExtraLetter1
//
//  Created by Apurva Patel on 8/26/17.
//  Copyright © 2017 Apurva Patel. All rights reserved.
//

import Foundation
import SpriteKit

class AN_LABEL_NODE : SKLabelNode {
    override init () {
       super.init()
        let anLabelNode = SKLabelNode(fontNamed: "GillSans-Light")
        anLabelNode.fontSize = 130
        anLabelNode.text = "An"
        anLabelNode.name = "An"
        anLabelNode.position = CGPoint (x: 0 , y: 475)
        anLabelNode.fontColor = UIColor.black//UIColor(red: 42/255, green: 45/255, blue: 52/255, alpha: 1)
        anLabelNode.horizontalAlignmentMode = .center
        anLabelNode.verticalAlignmentMode = .center
        addChild(anLabelNode)
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XTRA_LABEL_NODE : SKLabelNode {
    override init () {
        super.init()
        
        let xtraLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        xtraLabel.fontSize = 160
        xtraLabel.text = "E x t r a"
        xtraLabel.name = "extra"
        xtraLabel.position = CGPoint (x: 0 , y: 300)
        xtraLabel.fontColor = UIColor(red: 184/255, green: 12/255, blue: 9/255, alpha: 1)
        xtraLabel.horizontalAlignmentMode = .center
        xtraLabel.verticalAlignmentMode = .center
        addChild(xtraLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LETTER_LABEL_NODE : SKLabelNode {
    override init () {
        super.init()
        
        let letterLabel = SKLabelNode(fontNamed: "GillSans-Light")
        letterLabel.fontSize = 130
        letterLabel.text = "Letter"
        letterLabel.name = "Letter"
        letterLabel.position = CGPoint (x: 0 , y: 125)
        letterLabel.fontColor = UIColor.black//UIColor(red: 42/255, green: 45/255, blue: 52/255, alpha: 1)
        letterLabel.horizontalAlignmentMode = .center
        letterLabel.verticalAlignmentMode = .center
        addChild(letterLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
