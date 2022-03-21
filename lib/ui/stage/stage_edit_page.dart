import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/stage/stage_edit_view_model.dart';
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
    final uiState = ref.watch(stageEditViewModelProvider).uiState;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.stageEditPageTitle),
        ),
        body: uiState.when(
          loading: (errMsg) => OnViewLoading(errorMessage: errMsg),
          success: () => _onSuccess(context, ref),
        ),
      ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          _ViewNameTextField(),
          SizedBox(height: 16),
          _ViewStatusLimits(),
          SizedBox(height: 8),
          Text(RSStrings.stageEditPageOverview),
          SizedBox(height: 16),
          _ViewSaveButton(),
        ],
      ),
    );
  }
}

class _ViewNameTextField extends ConsumerWidget {
  const _ViewNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(stageEditViewModelProvider).currentStage;
    return RSTextFormField.stageName(
      initValue: currentStage.name,
      onChanged: (String? input) => ref.read(stageEditViewModelProvider).inputName(input),
    );
  }
}

class _ViewStatusLimits extends ConsumerWidget {
  const _ViewStatusLimits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(stageEditViewModelProvider).currentStage;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: RSNumberFormField.stageHpLimit(
            initValue: currentStage.hpLimit,
            onChanged: (int? input) => ref.read(stageEditViewModelProvider).inputHpLimit(input),
          ),
        ),
        const SizedBox(width: 48),
        SizedBox(
          width: 100,
          child: RSNumberFormField.stageStatusLimit(
            initValue: currentStage.statusLimit,
            onChanged: (int? input) => ref.read(stageEditViewModelProvider).inputLimit(input),
          ),
        ),
      ],
    );
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(stageEditViewModelProvider).isExecuteSave;
    return AppButton(
      label: RSStrings.stageEditPageSaveLabel,
      onTap: isSaved
          ? () async {
              const progressDialog = AppProgressDialog<void>();
              await progressDialog.show(
                context,
                execute: ref.read(stageEditViewModelProvider).save,
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
