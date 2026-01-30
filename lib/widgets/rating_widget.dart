import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final Function(double) onRatingSelected;

  const RatingWidget({Key? key, required this.onRatingSelected}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1.0;
            });
            widget.onRatingSelected(_currentRating);
          },
        );
      }),
    );
  }
}
