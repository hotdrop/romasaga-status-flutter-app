import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/note/note_view_model.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';

class NotePage extends ConsumerWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(noteViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.notePageTitle),
      ),
      body: uiState.when(
        loading: (errMsg) => _onLoading(context, errMsg),
        success: () => _onSuccess(context, ref),
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

  Widget _onSuccess(context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(child: _viewEditMemo(ref)),
        ],
      ),
    );
  }

  Widget _viewEditMemo(WidgetRef ref) {
    final note = ref.read(noteViewModelProvider).note;
    return RSMultiLineTextField(
      initValue: note,
      onChanged: (String v) => ref.read(noteViewModelProvider).input(v),
    );
  }
}
