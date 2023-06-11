import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/stage/stage_edit_providers.dart';
import 'package:rsapp/ui/widget/app_button.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';

class StageEditPage extends ConsumerWidget {
  const StageEditPage._();

  static Future<bool> start(BuildContext context) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const StageEditPage._()),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.stageEditPageTitle),
        ),
        body: const _ViewBody(),
      ),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _ViewNameTextField(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _ViewHpLimitField(),
                SizedBox(width: 48),
                _ViewStatusLimitFiled(),
              ],
            ),
            SizedBox(height: 8),
            Text(RSStrings.stageEditPageOverview),
            SizedBox(height: 16),
            _ViewSaveButton(),
          ],
        ),
      ),
    );
  }
}

class _ViewNameTextField extends ConsumerWidget {
  const _ViewNameTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RSTextFormField.stageName(
      initValue: ref.read(stageEditCurrentProvider).name,
      onChanged: (String? input) => ref.read(stageEditControllerProvider.notifier).inputName(input),
    );
  }
}

class _ViewHpLimitField extends ConsumerWidget {
  const _ViewHpLimitField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 150,
      child: RSTextFormField.stageHpLimit(
        initValue: ref.read(stageEditCurrentProvider).hpLimit,
        onChanged: (String? input) {
          final num = (input != null) ? int.tryParse(input) : null;
          ref.read(stageEditControllerProvider.notifier).inputHpLimit(num);
        },
      ),
    );
  }
}

class _ViewStatusLimitFiled extends ConsumerWidget {
  const _ViewStatusLimitFiled();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 100,
      child: RSTextFormField.stageStatusLimit(
        initValue: ref.read(stageEditCurrentProvider).statusLimit,
        onChanged: (String? input) {
          final num = (input != null) ? int.tryParse(input) : null;
          ref.read(stageEditControllerProvider.notifier).inputLimit(num);
        },
      ),
    );
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(stageEditIsExecuteSaveProvider);
    return AppButton(
      label: RSStrings.stageEditPageSaveLabel,
      onTap: isSaved
          ? () async {
              const progressDialog = AppProgressDialog<void>();
              await progressDialog.show(
                context,
                execute: ref.read(stageEditControllerProvider.notifier).save,
                onSuccess: (_) async {
                  Navigator.pop(context, true);
                },
                onError: (err) async => await AppDialog.onlyOk(message: err).show(context),
              );
            }
          : null,
    );
  }
}
