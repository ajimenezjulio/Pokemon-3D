//
//  ViewController.swift
//  Pokemon3D
//
//  Created by Aguilar, Julio on 10/28/19.
//  Copyright © 2019 Julio Cesar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            print("Images Successfully Added")
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

   // MARK: - ARSCNViewDelegate
   
      func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
          
          let node = SCNNode()
          
          if let imageAnchor = anchor as? ARImageAnchor {
              
              let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
              
              plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

              let planeNode = SCNNode(geometry: plane)
              
              planeNode.eulerAngles.x = -.pi / 2
              
              node.addChildNode(planeNode)
              
              loadScene(withReference: imageAnchor.referenceImage.name, onPlane: planeNode)
          }
          
          return node
      }
    
    // MARK: - Helpers
    
    func loadScene(withReference imageName: String?, onPlane plane: SCNNode) {
        var scene: String
        switch imageName {
        case "eevee-card":
            scene = "art.scnassets/eevee.scn"
        case "oddish-card":
            scene = "art.scnassets/oddish.scn"
        default:
            return
        }
        guard let pokeNode = createPokeNode(withScene: scene) else { return }
        plane.addChildNode(pokeNode)
    }
    
    func createPokeNode(withScene scene: String) -> SCNNode? {
        guard let pokeScene = SCNScene(named: scene) else { return nil }
        guard let pokeNode = pokeScene.rootNode.childNodes.first else { return nil }
        pokeNode.eulerAngles.x = .pi / 2
        return pokeNode
    }
}
