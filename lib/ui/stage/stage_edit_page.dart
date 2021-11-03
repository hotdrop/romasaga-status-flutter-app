import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/stage/stage_edit_view_model.dart';
import 'package:rsapp/ui/widget/rs_dialog.dart';
import 'package:rsapp/ui/widget/rs_progress_dialog.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';

class StageEditPage extends StatelessWidget {
  const StageEditPage._();

  static Future<bool> start(BuildContext context) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const StageEditPage._()),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.stageEditPageTitle),
        ),
        body: Consumer(
          builder: (context, watch, child) {
            final uiState = watch(stageEditViewModelProvider).uiState;
            return uiState.when(
              loading: (errMsg) => _onLoading(context, errMsg),
              success: () => _onSuccess(context),
            );
          },
        ),
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errMsg != null) {
        await AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _viewNameTextField(context),
          const SizedBox(height: 16),
          _viewStatusLimits(context),
          const SizedBox(height: 8),
          const Text(RSStrings.stageEditPageOverview),
          const SizedBox(height: 16),
          _viewSaveButton(context),
        ],
      ),
    );
  }

  Widget _viewNameTextField(BuildContext context) {
    final currentStage = context.read(stageEditViewModelProvider).currentStage;
    return RSTextFormField.stageName(
      initValue: currentStage.name,
      onChanged: (String? input) {
        context.read(stageEditViewModelProvider).inputName(input);
      },
    );
  }

  Widget _viewStatusLimits(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 150, child: _viewHpLimitNumberField(context)),
        const SizedBox(width: 48),
        SizedBox(width: 100, child: _viewStatusLimitNumberField(context)),
      ],
    );
  }

  Widget _viewHpLimitNumberField(BuildContext context) {
    final currentStage = context.read(stageEditViewModelProvider).currentStage;
    return RSNumberFormField.stageHpLimit(
      initValue: currentStage.hpLimit,
      onChanged: (int? input) {
        context.read(stageEditViewModelProvider).inputHpLimit(input);
      },
    );
  }

  Widget _viewStatusLimitNumberField(BuildContext context) {
    final currentStage = context.read(stageEditViewModelProvider).currentStage;
    return RSNumberFormField.stageStatusLimit(
      initValue: currentStage.statusLimit,
      onChanged: (int? input) {
        context.read(stageEditViewModelProvider).inputLimit(input);
      },
    );
  }

  Widget _viewSaveButton(BuildContext context) {
    final isSaved = context.read(stageEditViewModelProvider).isExecuteSave;
    return ElevatedButton(
      onPressed: isSaved
          ? () {
              const progressDialog = AppProgressDialog<void>();
              progressDialog.show(
                context,
                execute: context.read(stageEditViewModelProvider).save,
                onSuccess: (_) async {
                  Navigator.pop(context, true);
                },
                onError: (err) => AppDialog.onlyOk(message: err).show(context),
              );
            }
          : null,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(RSStrings.stageEditPageSaveLabel),
      ),
    );
  }
}