import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/create_post/page_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/date_picker.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostDatePrice extends StatefulWidget {
  const CreatePostDatePrice({Key? key}) : super(key: key);

  @override
  State<CreatePostDatePrice> createState() => _CreatePostDatePriceState();
}

class _CreatePostDatePriceState extends State<CreatePostDatePrice> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostPageLayout(
      title: l10n.newPost,
      page: _PageContent(formKey: _formKey,),
      bottom: CreatePostBottomLayout(
        children: [
          Button(
            child: ButtonText(l10n.continueText),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pushNamed('/create-post/tags');
              }
            },
          ),
        ]
      )
    );
  }
}

class _PageContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _PageContent({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  late DateTime _startDate;
  late DateTime _endDate;
  double _price = CreatePostState.price;

  @override
  void initState() {
    super.initState();

    var now = DateTime.now().toUtc();

    _startDate = CreatePostState.startDate ?? now;
    _endDate = CreatePostState.endDate ?? now.add(const Duration(days: 1));

    CreatePostState.startDate = _startDate;
    CreatePostState.endDate = _endDate;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: CreatePostContentLayout(
        children: [
          CreatePostTitleDesc(
            title: l10n.selectStartEnd,
            desc: l10n.selectStartEndDesc,
          ),
          const SizedBox(height: Sizing.formSpacing),
          Wrap(
            spacing: Sizing.inputSpacing,
            runSpacing: Sizing.inputSpacing,
            children: [
              Expanded(
                child: DatePicker(
                  label: l10n.startDate,
                  value: _startDate,
                  maxDate: _endDate,
                  onChanged: (value) {
                    setState(() {
                      _startDate = value;
                      CreatePostState.startDate = value;
                    });
                  }
                ),
              ),
              Expanded(
                child: DatePicker(
                  label: l10n.endDate,
                  value: _endDate,
                  minDate: _startDate,
                  // 7 days if urgent, 1 year if not
                  maxDate: _startDate.add(Duration(days: CreatePostState.isUrgent ? 7 : 365)),
                  onChanged: (value) {
                    setState(() {
                      _endDate = value;
                      CreatePostState.endDate = value;
                    });
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizing.formSpacing),
          // Price
          CreatePostTitleDesc(
            title: l10n.choosePrice,
            desc: l10n.choosePriceDesc,
          ),
          const SizedBox(height: Sizing.inputSpacing),
          TextInput(
            hint: l10n.pricePlaceholder,
            keyboardType: TextInputType.number,
            initialValue: _price.toString(),
            prefixText: '€ ',
            onChanged: (v) {
              if (Validators.isNumber(v)) {
                CreatePostState.price = double.parse(v);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return l10n.emptyField(l10n.price);
              }
              if (!Validators.isNumber(value)) {
                return l10n.invalidNumber;
              }

              var price = double.parse(value);
              var minPrice = 1;
              var maxPrice = 10000;

              if (price < minPrice) {
                return l10n.numRange(minPrice, maxPrice);
              }

              if (price > maxPrice) {
                return l10n.numRange(minPrice, maxPrice);
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
