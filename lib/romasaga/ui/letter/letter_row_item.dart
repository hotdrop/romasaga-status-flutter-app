// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:rsapp/res/rs_strings.dart';
// import 'package:rsapp/models/letter.dart';
// import 'package:rsapp/romasaga/ui/letter/letter_detail_page.dart';
// import 'package:rsapp/romasaga/ui/widget/custom_page_route.dart';

// class LetterRowItem extends StatelessWidget {
//   const LetterRowItem(this._selectedIndex, this._allLetters);

//   final int _selectedIndex;
//   final List<Letter> _allLetters;

//   @override
//   Widget build(BuildContext context) {
//     final currentLetter = _allLetters[_selectedIndex];
//     return Card(
//       child: InkWell(
//         child: Column(
//           children: <Widget>[
//             CachedNetworkImage(
//               imageUrl: currentLetter.staticImagePath,
//               fit: BoxFit.fill,
//               placeholder: (context, url) => _loadingIcon(currentLetter.loadingIcon),
//               errorWidget: (context, url, dynamic error) => _errorIcon(currentLetter.loadingIcon),
//             ),
//             Text(
//               '${currentLetter.month}${RSStrings.letterMonthLabel} ${currentLetter.shortTitle}',
//               style: TextStyle(color: currentLetter.themeColor),
//             ),
//           ],
//         ),
//         onTap: () {
//           Navigator.push<void>(
//             context,
//             ScalePageRoute(page: LetterMainPage(selectedIndex: _selectedIndex, letters: _allLetters)),
//           );
//         },
//       ),
//     );
//   }

//   Widget _loadingIcon(String res) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Image.asset(res),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(RSStrings.letterNowLoading),
//         ),
//       ],
//     );
//   }

//   Widget _errorIcon(String res) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Image.asset(res),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(
//             RSStrings.letterLoadingFailure,
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//       ],
//     );
//   }
// }
