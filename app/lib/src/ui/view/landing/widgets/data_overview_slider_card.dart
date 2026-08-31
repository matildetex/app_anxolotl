import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/animations/page_slide_left_transition.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';

class DataOverviewSliderCard extends StatefulWidget {
  const DataOverviewSliderCard(
      {super.key,
      required this.title,
      required this.nextPage,
      required this.sliderInterval,
      required this.currentData});

  final String title;
  final Widget nextPage;
  final ValueInterval<double> sliderInterval;
  final OverviewDataType currentData;

  @override
  State<DataOverviewSliderCard> createState() => _DataOverviewSliderCardState();
}

class _DataOverviewSliderCardState extends State<DataOverviewSliderCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    TextStyle? subHeaderStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? headlineMediumStyle = Theme.of(context).textTheme.headlineMedium;

    double amplitudeInterval =
        widget.sliderInterval.max - widget.sliderInterval.min;

    return Card(
      child: InkWell(
//onTap: () => Navigator.of(context).push(SlideRightRoute(page: )),
          onTap: () => Navigator.of(context)
              .push(SlideRightRoute(page: widget.nextPage)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: DesignTheme.doublePadding,
                      right: DesignTheme.doublePadding,
                      top: DesignTheme.doublePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.title,
                            style: subHeaderStyle,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          const SizedBox(
                            width: DesignTheme.singlePadding,
                          ),
                          Text(
                            LocalizationsUtil.dateTimeDayString(
                                widget.currentData.date, context),
                            textAlign: TextAlign.start,
                            style: bodySmallStyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: DesignTheme.singlePadding,
                      ),
                      Text(
                        textAlign: TextAlign.start,
                        widget.currentData.value.toString(),
                        style: headlineMediumStyle,
                      ),
                    ],
                  )),
              SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8, elevation: 0, pressedElevation: 0),
                  trackHeight: 20,
                  trackShape: GradientRectSliderTrackShape(
                      gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary
                  ])),
                ),
                child: Container(
                    child: Slider(
                  min: widget.sliderInterval.min - amplitudeInterval * 0.04,
                  max: widget.sliderInterval.max + amplitudeInterval * 0.04,
                  value: widget.currentData.value,
                  onChanged: (double) => Navigator.of(context).push(
                      SlideRightRoute(
                          page: widget.nextPage)), //Not intended to be used
                )),
              )
            ],
          )),
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const GradientRectSliderTrackShape({
    this.gradient = const LinearGradient(
      colors: [Colors.grey],
    ),
  });

  final LinearGradient gradient;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(sliderTheme.trackHeight != null && sliderTheme.trackHeight! > 0);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final activeGradientRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeGradientRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint fullTrackPaint = activePaint;

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
          trackRect.left, trackRect.top, trackRect.right, trackRect.bottom,
          topLeft: const Radius.circular(DesignTheme.roundedCornersRadius),
          topRight: const Radius.circular(DesignTheme.roundedCornersRadius),
          bottomLeft: const Radius.circular(DesignTheme.roundedCornersRadius),
          bottomRight: const Radius.circular(DesignTheme.roundedCornersRadius)),
      fullTrackPaint,
    );
  }
}
