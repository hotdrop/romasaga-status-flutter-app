import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/note/note_providers.dart';
import 'package:rsapp/ui/widget/app_button.dart';
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
      body: ref.watch(noteControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, _) => ViewLoadingError(errorMessage: '$err'),
            loading: () => const ViewNowLoading(),
          ),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: ref.watch(noteTextEditControllerProvider),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const _ViewButtonArea(),
        ],
      ),
    );
  }
}

class _ViewButtonArea extends ConsumerWidget {
  const _ViewButtonArea();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSave = ref.watch(noteIsUpdateCurrentNoteProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppIconButton(
            label: '保存する',
            icon: Icons.save,
            onTap: isSave ? ref.read(noteControllerProvider.notifier).save : null,
          ),
          const SizedBox(width: 8),
          AppIconButton(
            label: '戻す',
            icon: Icons.restore,
            onTap: ref.read(noteControllerProvider.notifier).clear,
          ),
        ],
      ),
    );
  }
}
