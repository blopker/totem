import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totem/components/widgets/index.dart';
import 'package:totem/services/index.dart';
import 'package:totem/theme/index.dart';
import 'package:totem/models/index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late Future<UserProfile?> _userProfileFetch;
  UserProfile? _userProfile;
  bool _busy = false;

  bool get hasChanged {
    return (_userProfile!.name != _nameController.text ||
        _userProfile!.email != _emailController.text);
  }

  @override
  void initState() {
    _userProfileFetch = ref.read(repositoryProvider).userProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final textStyles = themeData.textStyles;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: () async {
            if (hasChanged) {
              return await _savePrompt();
            }
            return true;
          },
          child: GestureDetector(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            const BackButton(),
                            Expanded(child: Container()),
                            TextButton(
                                onPressed: !_busy
                                    ? () {
                                        _saveForm();
                                      }
                                    : null,
                                child: Text(t.done)),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  left: themeData.pageHorizontalPadding,
                                  right: themeData.pageHorizontalPadding,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: constraint.maxHeight),
                                  child: IntrinsicHeight(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          t.editProfile,
                                          style: textStyles.headline2,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          t.profilePicture,
                                          style: textStyles.headline3,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // edit
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const ProfileImage(),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                t.editProfilePicture,
                                                style: textStyles.headline3,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _profileEditForm(context),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        const SizedBox(height: 20),
                                        ThemedRaisedButton(
                                          label: t.signOut,
                                          onPressed: () async {
                                            await ref
                                                .read(authServiceProvider)
                                                .signOut();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
              )),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_userProfile!.name != _nameController.text ||
        _userProfile!.email != _emailController.text) {
      setState(() => _busy = true);
      _formKey.currentState!.save();
      _userProfile!.name = _nameController.text;
      _userProfile!.email = _emailController.text;
      await ref.read(repositoryProvider).updateUserProfile(_userProfile!);
      setState(() => _busy = false);
    }
    Navigator.of(context).pop();
  }

  Widget _profileEditForm(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final textStyles = themeData.textStyles;
    return FutureBuilder<UserProfile?>(
      future: _userProfileFetch,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: BusyIndicator(),
          );
        }
        if (!asyncSnapshot.hasData) {
          return Center(
            child: Column(
              children: [
                Text(
                  t.errorNoProfile,
                  style: textStyles.headline3,
                )
              ],
            ),
          );
        }
        if (_userProfile == null) {
          _userProfile = asyncSnapshot.data!;
          _nameController.text = _userProfile!.name;
          _emailController.text = _userProfile!.email ?? "";
        }
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ThemedTextFormField(
                      labelText: t.name,
                      controller: _nameController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.errorEnterName;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 5, top: 5, left: 4),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset('assets/more_info.svg'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ThemedTextFormField(
                      labelText: t.email,
                      controller: _emailController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.errorEnterName;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 5, top: 5, left: 4),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset('assets/more_info.svg'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _savePrompt() async {
    FocusScope.of(context).unfocus();
    final t = AppLocalizations.of(context)!;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(t.cancel),
      onPressed: () {
        Navigator.of(context).pop(0);
      },
    );
    Widget saveButton = TextButton(
      child: Text(t.save),
      onPressed: () {
        Navigator.of(context).pop(2);
      },
    );
    Widget continueButton = TextButton(
      child: Text(t.leaveWithoutSaving),
      onPressed: () {
        Navigator.of(context).pop(1);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(t.changesTitle),
      content: Text(t.changesProfilePrompt),
      actions: [
        saveButton,
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
    if (result == 2) {
      _saveForm();
      return false;
    }
    return result == 1;
  }
}