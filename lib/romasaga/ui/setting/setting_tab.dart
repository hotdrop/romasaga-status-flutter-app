import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'setting_view_model.dart';

import '../../common/strings.dart';

class SettingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingViewModel>(
      builder: (_) => SettingViewModel()..load(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(Strings.SettingsTabTitle),
        ),
        body: _widgetContents(context),
      ),
    );
  }

  Widget _widgetContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _cardCharacterReload(),
        _cardStageReload(),
      ],
    );
  }

  Widget _cardCharacterReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _settingCard(
            icon: const Icon(Icons.person),
            title: Strings.SettingsCharacterUpdateLabel,
            registerCount: viewModel.characterCount,
            loadingStatus: viewModel.loadingCharacter,
            onTapListener: () {
              viewModel.refreshCharacters();
            });
      },
    );
  }

  Widget _cardStageReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _settingCard(
            icon: const Icon(Icons.map),
            title: Strings.SettingsStageUpdateLabel,
            registerCount: viewModel.stageCount,
            loadingStatus: viewModel.loadingStage,
            onTapListener: () {
              viewModel.refreshStage();
            });
      },
    );
  }

  Widget _settingCard({
    @required Icon icon,
    @required String title,
    @required int registerCount,
    @required LoadingStatus loadingStatus,
    @required Function onTapListener,
  }) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: BeveledRectangleBorder(),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(child: _cardPartsIcon(icon), flex: 1),
              Expanded(child: _cardPartsContents(title, registerCount), flex: 8),
              Expanded(child: _cardPartsStatus(loadingStatus), flex: 2),
            ],
          ),
        ),
        onTap: () {
          onTapListener();
        },
      ),
    );
  }

  Widget _cardPartsIcon(Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: icon,
    );
  }

  Widget _cardPartsContents(String title, int registerCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text('${Strings.SettingsRegisterCountLabel} ${registerCount ?? 0}', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _cardPartsStatus(LoadingStatus loadingStatus) {
    var statusColor;
    var statusTitle;
    switch (loadingStatus) {
      case LoadingStatus.none:
        statusColor = Colors.grey;
        statusTitle = Strings.SettingsUpdateStatusNone;
        break;
      case LoadingStatus.loading:
        statusColor = Colors.green;
        statusTitle = Strings.SettingsUpdateStatusUpdate;
        break;
      case LoadingStatus.complete:
        statusColor = Colors.blueAccent;
        statusTitle = Strings.SettingsUpdateStatusComplete;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        statusTitle,
        textAlign: TextAlign.center,
        style: TextStyle(color: statusColor),
      ),
    );
  }
}
