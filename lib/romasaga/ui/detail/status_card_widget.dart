import 'package:flutter/material.dart';

import '../../common/rs_colors.dart';
import '../widget/total_status_indicator.dart';

class StatusCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _contentCard();
  }

  Widget _contentCard() {
    return Container(
      decoration: BoxDecoration(
        color: RSColors.detailBackground,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0), topRight: Radius.circular(68.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: RSColors.detailCardShadow.withOpacity(0.2), offset: Offset(1.1, 1.1), blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          _totalStatusCircle(),
        ],
      ),
    );
  }

  ///
  /// 合計ステータス
  ///
  Widget _totalStatusCircle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TotalStatusIndicator.create(60, 100),
    );
  }
}
