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
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.notePageTitle),
      ),
      body: ref.watch(noteStateProvider).when(
            data: (note) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: RSMultiLineTextField(
                        initValue: ref.watch(noteInputStateProvider),
                        onChanged: (String v) {
                          ref.read(noteInputStateProvider.notifier).state = v;
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (err, _) => OnViewLoading(errorMessage: '$err'),
            loading: () => const OnViewLoading(),
          ),
    );
  }
}
