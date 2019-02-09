import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'dart:math';

class HangmanController extends FlareController {

  FlutterActorArtboard _artboard;
  final List<FlareAnimationLayer> _roomAnimations = [];
  FlareAnimationLayer _idleAnimation;
  bool hasWon = false;
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
   
   
    /// Iterate from the top b/c elements might be removed.
    int len = _roomAnimations.length - 1;
    for (int i = len; i >= 0; i--) {
      FlareAnimationLayer layer = _roomAnimations[i];
      if(layer.animation.name == "won" || layer.animation.name == "meteorshower"){
        hasWon = true;
      }else{
        hasWon = false;
      }
      // layer.animation.duration
      layer.time += elapsed;
      /// The mix quickly ramps up to 1, but interpolates for the first few frames.
      layer.mix = min(1.0, layer.time / 0.07);
      layer.apply(artboard);
      /// When done, remove it.
      if (layer.isDone) {
        _roomAnimations.removeAt(i);
        // if(layer.animation.name == "won"){
        //   enqueueAnimation("meteorShower");
        // }
        hasWon = false;
      }
    }
    if(!hasWon){
    /// Advance the background animation every frame.
    _idleAnimation.time =
        (_idleAnimation.time + elapsed) % _idleAnimation.duration;      
    _idleAnimation.apply(artboard);
    }
    // else{      
    //   // artboard.dispose();
    // }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
    _idleAnimation = FlareAnimationLayer()
      ..animation = _artboard.getAnimation("idle")
      ..mix = 1.0;
    // ActorAnimation endAnimation = artboard.getAnimation("idle");
    // if (endAnimation != null) {
    //   endAnimation.apply(endAnimation.duration, artboard, 1.0);
    // }
  }


  enqueueAnimation(String name) {
    ActorAnimation animation = _artboard.getAnimation(name);
    if (animation != null) {
      _roomAnimations.add(FlareAnimationLayer()..animation = animation);
    }
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // TODO: implement setViewTransform
  }
}

class FlareAnimationLayer {
  String name;
  ActorAnimation animation;
  double time = 0.0, mix = 0.0;
  apply(FlutterActorArtboard artboard) {
    animation.apply(time, artboard, mix);
  }

  get duration => animation.duration;
  get isDone => time >= animation.duration;
}
