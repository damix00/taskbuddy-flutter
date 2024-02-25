import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This is a simple OTP input field
// It's a text field that only accepts numbers and has a maximum length
class OTPInput extends StatefulWidget {
  final int length;
  final double space;
  final double width;
  final double height;
  final Function(String) onCompleted;
  final String? title;

  const OTPInput(
      {required this.onCompleted,
      this.length = 6,
      this.space = 12,
      this.width = 40,
      this.height = 40,
      this.title,
      Key? key})
      : super(key: key);

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  List<String> _value = [];

  @override
  void initState() {
    super.initState();
    _value = List.generate(widget.length, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: widget.width * widget.length + widget.space * (widget.length - 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Wrap(
              direction: Axis.horizontal,
              spacing: widget.space,
              children: List.generate(
                widget.length,
                (index) => SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    textInputAction: index == widget.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        )
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                    ],
                    onSubmitted: (value) {
                      if (value.length == 1) {
                        if (index == widget.length - 1) {
                          widget.onCompleted(_value.join());
                          FocusScope.of(context).unfocus();
                          return;
                        }
                        FocusScope.of(context).nextFocus();
                      } else {
                        if (index == 0) {
                          return;
                        }
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    onChanged: (value) {
                      _value[index] = value;
                      if (value.length == 1) {
                        if (index == widget.length - 1) {
                          widget.onCompleted(_value.join());
                          FocusScope.of(context).unfocus();
                          return;
                        }
                        FocusScope.of(context).nextFocus();
                      } else {
                        if (index == 0) {
                          return;
                        }
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
