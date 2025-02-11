import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomeSearchPage extends StatelessWidget {
  const HomeSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 16,
          children: [
            PlatformSearchBar(
              keyboardType: TextInputType.text,
              hintText: 'Search FriendID hoặc InviteCode',
              cupertino: (_, __) => CupertinoSearchBarData(
                itemSize: 24,
                autocorrect: false,
              ),
            ),
            Column(
              spacing: 4,
              children: [
                Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        spacing: 1,
                        children: [
                          Icon(PlatformIcons(context).locationSolid),
                          Text(
                            'Khu Vực',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Card.filled(
                  color: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: 144,
                    width: double.infinity,
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              spacing: 4,
              children: [
                Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        spacing: 1,
                        children: [
                          Icon(PlatformIcons(context).clockSolid),
                          Text(
                            'Thời Gian',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Card.filled(
                  color: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: 144,
                    width: double.infinity,
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
        SafeArea(
          child: PlatformElevatedButton(
            onPressed: () {},
            color: Colors.green.shade600,
            cupertino: (_, __) => CupertinoElevatedButtonData(
                borderRadius: BorderRadius.all(Radius.circular(32))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Refresh'),
                Icon(PlatformIcons(context).refreshBold),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
