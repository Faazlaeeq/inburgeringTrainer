import 'package:flutter/material.dart';

class MusicVisualizer extends StatefulWidget {
  final List<Color>? colors;
  final List<int>? duration;
  final int? barCount;
  final Curve? curve;

  MusicVisualizer({
    Key? key,
    @required this.colors,
    @required this.duration,
    @required this.barCount,
    this.curve = Curves.easeInQuad,
  }) : super(key: key);

  @override
  MusicVisualizerState createState() => MusicVisualizerState();
}

class MusicVisualizerState extends State<MusicVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<VisualComponent> _visualComponents;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: widget.duration!.reduce((a, b) => a + b)),
    );
    _visualComponents = List<VisualComponent>.generate(
      widget.barCount!,
      (index) => VisualComponent(
        curve: widget.curve!,
        duration: widget.duration![index % 5],
        color: widget.colors![index % 4],
        animationController: _animationController,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void stopAnimation() {
    _animationController.stop();
  }

  void startAnimation() {
    _animationController.repeat(reverse: true);
  }

  void resetAnimation() {
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _visualComponents,
    );
  }
}

class VisualComponent extends StatefulWidget {
  final int? duration;
  final Color? color;
  final Curve? curve;
  final AnimationController? animationController;

  VisualComponent({
    Key? key,
    @required this.duration,
    @required this.color,
    @required this.curve,
    @required this.animationController,
  }) : super(key: key);

  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: widget.curve!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 3,
          height: _animation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
    );
  }
}
