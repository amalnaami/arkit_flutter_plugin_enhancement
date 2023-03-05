import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';

class ARKitFaceTrackingWithObjModel extends StatefulWidget {
  @override
  _ARKitFaceTrackingWithObjModelState createState() =>
      _ARKitFaceTrackingWithObjModelState();
}

class _ARKitFaceTrackingWithObjModelState
    extends State<ARKitFaceTrackingWithObjModel> {
  late ARKitController arkitController;
  ARKitReferenceNode? faceNode;
  ARKitNode? node;
  ARKitFace? geo;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ARKit Face Tracking with OBJ Model'),
      ),
      body: ARKitSceneView(
        configuration: ARKitConfiguration.faceTracking,
        onARKitViewCreated: onARKitViewCreated,
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitFaceAnchor)) {
      return;
    }
    final material = ARKitMaterial(fillMode: ARKitFillMode.lines);
    anchor.geometry.materials.value = [material];
    final materiall = [ARKitMaterial(transparency: 0)];
    geo = ARKitFace(materials: materiall);
    node = ARKitNode(geometry: geo);
    node?.renderingOrder = -1;

    print('geo::::: ${node?.renderingOrder}');
    arkitController.add(node!, parentNodeName: anchor.nodeName);

    faceNode = ARKitReferenceNode(
      url: 'models.scnassets/newGlass.usdz',
    );

    arkitController.add(faceNode!, parentNodeName: anchor.nodeName);
  }
}
