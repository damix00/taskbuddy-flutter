import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/state/remote_config.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/screens/create_post/add_media_button.dart';
import 'package:taskbuddy/widgets/screens/create_post/pageview_image.dart';

class MediaPageView extends StatefulWidget {
  final List<XFile> items;
  final Function(List<XFile>, bool) onItemsChanged;
  final double size;

  const MediaPageView({
    Key? key,
    required this.items,
    required this.onItemsChanged,
    required this.size,
  }) : super(key: key);

  @override
  State<MediaPageView> createState() => _MediaPageViewState();
}

class _MediaPageViewState extends State<MediaPageView> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentItem = 0;

  void chooseImages(bool reset) async {
    final List<XFile> image = await ImagePicker().pickMultiImage(); // TODO: Add video support

    setState(() {
      widget.onItemsChanged(image, reset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.size + 1, // +1 to avoid overflow
          child: PageView.builder(
            itemCount: widget.items.length + 1,
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentItem = index;
              });
            },
            itemBuilder: (context, index) {
              return ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  double factor = 1;

                  if (_controller.position.hasContentDimensions) {
                    factor = 1 - (_controller.page! - index).abs();
                  }

                  // If it is not the current item, set the size to 80% of the original size
                  // When swiping, the current item will be 100% and the others will be 80%
                  double _size = widget.size * (0.8 + 0.2 * factor);

                  if (index == widget.items.length && widget.items.length < 20) {
                    return AddMediaButton(
                      width: widget.size,
                      height: _size,
                      onPressed: () {
                        chooseImages(false);
                      }
                    );
                  }

                  return PageViewImage(
                    width: widget.size,
                    height: _size,
                    item: widget.items[index],
                    video: Utils.isVideo(widget.items[index]),
                    onPressed: () {
                      chooseImages(false);
                    },
                  );
                }
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width - widget.size) / 2),
          child: Row(
            children: [
              Text('min ${RemoteConfigData.minMedia}, max ${RemoteConfigData.maxMedia}', style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Text('${widget.items.length}/${RemoteConfigData.maxMedia}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (widget.items.isNotEmpty)
          PageViewDotIndicator(
            currentItem: _currentItem,
            count: widget.items.length + 1,
            unselectedColor: Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }
}
