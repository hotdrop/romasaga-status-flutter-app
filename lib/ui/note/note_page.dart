import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/note/note_view_model.dart';
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
        loading: (errMsg) => OnViewLoading(errorMessage: errMsg),
        success: () {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: RSMultiLineTextField(
                    initValue: ref.watch(noteViewModelProvider).note,
                    onChanged: (String v) => ref.read(noteViewModelProvider).input(v),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
