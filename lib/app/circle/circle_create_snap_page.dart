import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:totem/app_routes.dart';
import 'package:totem/components/widgets/index.dart';
import 'package:totem/models/index.dart';
import 'package:totem/models/snap_circle_option.dart';
import 'package:totem/services/error_report.dart';
import 'package:totem/services/index.dart';
import 'package:totem/theme/index.dart';

class CircleCreateSnapPage extends ConsumerStatefulWidget {
  const CircleCreateSnapPage({Key? key, this.fromCircle}) : super(key: key);
  final Circle? fromCircle;

  @override
  CircleCreateSnapPageState createState() => CircleCreateSnapPageState();
}

class CircleCreateSnapPageState extends ConsumerState<CircleCreateSnapPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _focusNodeDescription = FocusNode();
  late final List<CircleOption> visibilityOptions;

  bool _busy = false;
  late CircleOption _selectedVisibility;
  late final double maxParticipants;
  late final bool isKeeper;
  double numParticipants = 20;
  String? _bannerImageUrl;
  String? _logoImageUrl;

  final GlobalKey<FileUploaderState> _uploader = GlobalKey();

  @override
  void initState() {
    final authUser = ref.read(authServiceProvider).currentUser()!;
    isKeeper = authUser.hasRole(Role.keeper);
    maxParticipants = (isKeeper
            ? Circle.maxKeeperParticipants
            : Circle.maxNonKeeperParticipants)
        .toDouble();
    numParticipants = maxParticipants;
    if (widget.fromCircle != null) {
      _nameController.text = widget.fromCircle!.name;
      _descriptionController.text = widget.fromCircle!.description ?? "";
    }
    visibilityOptions = isKeeper
        ? [
            CircleOption(name: 'public', value: false),
            CircleOption(name: 'private', value: true),
          ]
        : [CircleOption(name: 'private', value: true)];
    _selectedVisibility = visibilityOptions[0];
    ref.read(analyticsProvider).showScreen('createSnapCircleScreen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyles = themeData.textStyles;
    final t = AppLocalizations.of(context)!;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // call this method here to hide soft keyboard
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SafeArea(
                top: true,
                bottom: false,
                child: Column(
                  children: [
                    SubPageHeader(title: t.createNewCircle),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: Theme.of(context).maxRenderWidth),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: themeData.pageHorizontalPadding),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(
                                      height: 46,
                                    ),
                                    Text(t.circleName,
                                        style: textStyles.headline3),
                                    ThemedTextFormField(
                                      controller: _nameController,
                                      autofocus: true,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textInputAction: TextInputAction.next,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return t.errorEnterName;
                                        }
                                        return null;
                                      },
                                      maxLines: 1,
                                      maxLength: 50,
                                    ),
                                    const SizedBox(height: 32),
                                    Text(t.description,
                                        style: textStyles.headline3),
                                    ThemedTextFormField(
                                      focusNode: _focusNodeDescription,
                                      controller: _descriptionController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLines: 0,
                                      textInputAction: TextInputAction.newline,
                                      maxLength: 1500,
                                    ),
                                    const SizedBox(height: 32),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: _participantLimit(),
                                        ),
                                        const SizedBox(width: 32),
                                        Expanded(
                                          child: _circleOptions(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    _imageEntry(
                                        aspectRatio: 1.0, label: t.circleLogo),
                                    const SizedBox(height: 32),
                                    _imageEntry(
                                        aspectRatio: 1000 / 300,
                                        height: 80,
                                        label: t.circleBanner),
                                    const SizedBox(height: 40),
                                    Center(
                                      child: ThemedRaisedButton(
                                        label: t.createCircle,
                                        onPressed: !_busy
                                            ? () {
                                                _saveCircle();
                                              }
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 50)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_busy)
                const Center(
                  child: BusyIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageEntry(
      {String? imageUrl,
      required final String label,
      final double aspectRatio = 1,
      final height = 60}) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textStyles.headline3),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).themeColors.altBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).themeColors.divider,
                  width: 1,
                ),
              ),
              height: height,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: imageUrl != null
                    ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
                    : const Center(
                        child: Icon(
                          Icons.image,
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            ThemedRaisedButton(
              label: t.selectImage,
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }

  void _saveCircle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    _formKey.currentState!.save();
    var repo = ref.read(repositoryProvider);
    try {
      final circle = await repo.createSnapCircle(
        name: _nameController.text,
        description: _descriptionController.text,
        keeper: widget.fromCircle?.keeper,
        previousCircle: widget.fromCircle?.id,
        isPrivate: _selectedVisibility.value,
        maxParticipants: numParticipants.toInt(),
      );
      if (circle != null) {
        await repo.createActiveSession(
          circle: circle,
        );
        if (!mounted) return;
        context.replaceNamed(AppRoutes.circle,
            params: {'id': circle.snapSession.id});
      } /*else {
        // leave session in place or cancel?
        if (!mounted) return;
        Navigator.pop(context);
        return;
      } */
    } on ServiceException catch (ex, stack) {
      debugPrint('Error creating circle: $ex');
      await reportError(ex, stack);
      await _showCreateError(ex);
    }
    setState(() => _busy = false);
  }

  Future<void> _showCreateError(ServiceException exception) async {
    final t = AppLocalizations.of(context)!;
    AlertDialog alert = AlertDialog(
      title: Text(t.errorCreateSnapCircle),
      content: Text(exception.toString()),
      actions: [
        TextButton(
          child: Text(t.ok),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    // show the dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _participantLimit() {
    final themeData = Theme.of(context);
    final textStyles = themeData.textStyles;
    final themeColors = themeData.themeColors;
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.participantLimit, style: textStyles.headline3),
        const SizedBox(height: 6),
        SpinBox(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: themeColors.divider, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          min: Circle.minParticipants.toDouble(),
          max: maxParticipants,
          value: numParticipants,
          onChanged: (value) {
            setState(() {
              numParticipants = value;
            });
          },
        ),
        const SizedBox(height: 4),
        Text(
          t.maximumParticipants(maxParticipants.toInt().toString()),
          style: textStyles.headline4,
        ),
      ],
    );
  }

  Widget _circleOptions() {
    final themeData = Theme.of(context);
    final textStyles = themeData.textStyles;
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.visibility, style: textStyles.headline3),
        const SizedBox(height: 10),
        _optionsDropDown(
          visibilityOptions,
          selected: _selectedVisibility,
          onChanged: (item) {
            setState(() => _selectedVisibility = item);
          },
        ),
      ],
    );
  }

  Widget _optionsDropDown(List<CircleOption> options,
      {required Function(dynamic item) onChanged,
      required CircleOption? selected}) {
    if (options.isEmpty) return Container();
    final dropDownMenus = <DropdownMenuItem<CircleOption>>[];
    for (var v in options) {
      dropDownMenus.add(
        DropdownMenuItem(
          value: v,
          child: Text(v.getName(context), overflow: TextOverflow.ellipsis),
        ),
      );
    }
    return SizedBox(
      height: 40,
      child: DropdownButton<CircleOption>(
        isExpanded: true,
        items: dropDownMenus,
        value: selected,
        onChanged: (v) {
          onChanged(v);
        },
      ),
    );
  }

  Future<void> _handleUploadComplete(String? uploadedUrl, String? error,
      {bool isBannerImage = false}) async {
    if (uploadedUrl != null) {
      isBannerImage
          ? _bannerImageUrl = uploadedUrl
          : _logoImageUrl = uploadedUrl;
      await ref.read(repositoryProvider).updateUserProfile(_userProfile!);
      setState(() => _busy = false);
      if (!mounted) return;
      if (widget.onProfileUpdated == null) {
        Navigator.of(context).pop();
      } else {
        widget.onProfileUpdated!(_userProfile!);
      }
    } else {
      setState(() => _busy = false);
      await _showUploadError(context, error);
    }
  }
}
