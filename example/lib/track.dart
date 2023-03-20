import 'dart:typed_data';
import 'dart:io';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class ARKitFaceTrackingWithObjModel extends StatefulWidget {
  @override
  _ARKitFaceTrackingWithObjModelState createState() =>
      _ARKitFaceTrackingWithObjModelState();
}

class _ARKitFaceTrackingWithObjModelState
    extends State<ARKitFaceTrackingWithObjModel> {
  late ARKitController arkitController;
  ARKitReferenceNode? faceNode;
  final light = ARKitLight(
    type: ARKitLightType.directional,
  );
  ARKitAnchor? arAnchor;

/*  ARKitNode? node;
  ARKitFace? geo;*/

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
/*      appBar: AppBar(
        title: Text('ARKit Face Tracking with OBJ Model'),
      ),*/

        body: Stack(
          alignment: Alignment.bottomCenter,
          children:[
            ARKitSceneView(
              configuration: ARKitConfiguration.faceTracking,
              onARKitViewCreated: onARKitViewCreated,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
              onPressed: () {
                updateFaceFilter('flowerss3.usdz');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 2.0,
                  textStyle: const TextStyle(color: Colors.white)),
              child: const Text("Change Filter"),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  updateFaceFilter('newGlass.usdz');
                },
                style: ElevatedButton.styleFrom(
                    elevation: 2.0,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const Text("Change Filter"),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async{
                  await takePicture();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 2.0,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const Text("Take Picture"),
              ),
            ),
          ]),
      ));
  }

  void onARKitViewCreated(ARKitController controller) {

    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
    //arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitFaceAnchor)) {
      return;
    }
    arAnchor = anchor;
    faceNode = ARKitReferenceNode(
      url: 'models.scnassets/pharohh.usdz',
      //renderingOrder: -1,
      light: light,
/*      physicsBody: ARKitPhysicsBody(
        ARKitPhysicsBodyType.staticType,
        categoryBitMask:  1,
      ),*/
    );

    arkitController.add(faceNode!, parentNodeName: anchor.nodeName);

    //final material = ARKitMaterial(transparency: 0);
    //anchor.geometry.materials.value = [material];
    final material = ARKitMaterial(
        //fillMode: ARKitFillMode.fill,
        transparencyMode: ARKitTransparencyMode.dualLayer,
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty.image('assets/wireframeTexture.jpg'),
    );
    //anchor.geometry.materials.value = [material];
    //anchor.geometry.materials.

    final geo = ARKitFace(materials: [material]);
    final node = ARKitNode(
        geometry: geo,
    );

    //anchor.geometry.materials.value;
    //node?.renderingOrder = -1;
    //anchor.
    //print('anchor nodename ${anchor.nodeName}');

    //print('geo::::: ${node?.renderingOrder}');
    arkitController.add(node!, parentNodeName: anchor.nodeName);
    //arkitController.

/*    final light = ARKitLight(
      type: ARKitLightType.directional,
    );*/
    
    //ARKitLightEstimate(ambientIntensity: ambientIntensity, ambientColorTemperature: ambientColorTemperature)



    /*faceNode = ARKitReferenceNode(
      url: 'models.scnassets/pharohh.usdz',
      //renderingOrder: -1,
      light: light,
*//*      physicsBody: ARKitPhysicsBody(
        ARKitPhysicsBodyType.staticType,
        categoryBitMask:  1,
      ),*//*
    );

    arkitController.add(faceNode!, parentNodeName: anchor.nodeName);*/
  }
  void updateFaceFilter(String filter){
    arkitController.remove(faceNode!.name);
    faceNode = ARKitReferenceNode(
      url: 'models.scnassets/$filter',
      light: light,
    );
    arkitController.add(faceNode!, parentNodeName: arAnchor?.nodeName);

  }

  Future<void> takePicture() async{
    final image = await arkitController.snapshot();
    var img = Image(image: image);
    final dir = await getTemporaryDirectory();
    final dirr = await getApplicationDocumentsDirectory();
    var dirpath = dir.path;
    var dirrpath = dirr.path;
    var imgpath = '$dirrpath/image.jpg';

    var file = File(imgpath);
    var imgg = Image.file(file);
    imgg = img;
    setState(() {

    });
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalpath = await FlutterFileDialog.saveFile(params: params);


    //await file.writeAsBytes(img.b)


    print(imgpath);
    print(finalpath);
    print(imgg.runtimeType);
    print(img.runtimeType);
    //print(test.runtimeType);
  }

/*  void _handleUpdateAnchor(ARKitAnchor anchor){
    if(anchor is ARKitFaceAnchor && mounted){
      //final faceAnchor = anchor;
      arkitController.updateFaceGeometry(node, anchor.identifier);
    }
  }*/


}