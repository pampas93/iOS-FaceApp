//
//  ViewController.swift
//  FaceApp
//
//  Created by Abhijit Srikanth on 7/23/21.
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
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
        // Set the scene to the view
        sceneView.scene = SCNScene()
      
      
      guard ARFaceTrackingConfiguration.isSupported else { return }
      let configuration = ARFaceTrackingConfiguration()
      if #available(iOS 13.0, *) {
          configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
      }
      configuration.isLightEstimationEnabled = true
      sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        // Run the view's session
//        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
  
  var nodes: [ARFaceAnchor] = []
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    // This class adds AR content only for face anchors.
    guard let faceAnchor = anchor as? ARFaceAnchor else {
      return
    }
    
    nodes.append(faceAnchor)
    
    print(faceAnchor.leftEyeTransform)
    // Load an asset from the app bundle to provide visual content for the anchor.
//    let contentNode = SCNReferenceNode(named: "coordinateOrigin")
    
  }
  
  @IBOutlet var depthUIImage: UIImageView!
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

    DispatchQueue.global().async {

      guard let frame = self.sceneView.session.currentFrame else {
          return
      }


      if let depthImage = frame.capturedDepthData {
        
        let ciImage = CIImage(cvPixelBuffer: depthImage.depthDataMap)
        
        DispatchQueue.main.async {
          self.depthUIImage.image = UIImage(ciImage: ciImage)
        }
        
        
        
        
//        let cvImageBuffer = (depthImage as! CVImageBuffer)
//        let ciImage = CIImage(cvImageBuffer: cvImageBuffer)
//        let tempContext = CIContext(options: nil)
//        let cgiImageRef = tempContext.createCGImage(ciImage, from: ciImage.extent)
//
//        if let cgImage = cgiImageRef {
//
//          let image = UIImage(cgImage: cgImage)
//          print(image)
//
//        }
      }
    }
}
  
  
  
//  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//
//    guard let faceAnchor = anchor as? ARFaceAnchor else {
//      return
//    }
//
//    if let face = nodes.first {
//      print(face.blendShapes.lef)
//    }
//   }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
