import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/note/note_view_model.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';
import 'package:rsapp/ui/widget/view_loading.dart';

class NotePage extends ConsumerWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.notePageTitle),
      ),
      body: ref.watch(noteViewModel).when(
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
            loading: () {
              Future<void>.delayed(Duration.zero).then((_) {
                ref.read(noteViewModel.notifier).init();
              });
              return const OnViewLoading();
            },
          ),
    );
  }
}
