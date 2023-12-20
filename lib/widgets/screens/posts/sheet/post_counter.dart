import 'package:flutter/material.dart';

class PostCounter extends StatefulWidget {
  final int count;
  final String text;

  const PostCounter({Key? key, required this.count, required this.text}) : super(key: key);

  @override
  _PostCounterState createState() => _PostCounterState();
}

class _PostCounterState extends State<PostCounter> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // You can adjust the duration as needed
    );

    _countAnimation = IntTween(
      begin: 0,
      end: widget.count,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _countAnimation,
          builder: (context, child) {
            return Text(
              _countAnimation.value.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          widget.text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
      ],
    );
  }
}
