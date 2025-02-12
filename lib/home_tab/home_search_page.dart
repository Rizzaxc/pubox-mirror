import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:multi_dropdown/multi_dropdown.dart';

class HomeSearchPage extends StatelessWidget {
  const HomeSearchPage({super.key});

  static var borderRadius = BorderRadius.circular(8);
  static const borderRadiusVal = Radius.circular(8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 512),
        child: Column(
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
                Card.filled(
                  color: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: 128,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownMenu(
                            requestFocusOnTap: true,
                            // width: double.infinity,
                            // alignmentOffset: Offset(-8, 0),
                            expandedInsets: EdgeInsets.zero, // needed to align the menu with the input field
                            keyboardType: TextInputType.text,
                            leadingIcon:
                                Icon(PlatformIcons(context).locationSolid),
                            label: const Text(
                              'Khu Vực',
                            ),
                            enableSearch: true,
                            enableFilter: true,
                            inputDecorationTheme: InputDecorationTheme(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIconColor: Colors.white,
                                suffixIconColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                filled: true,
                                fillColor: Colors.blue.shade400,
                                focusColor: Colors.blue.shade500,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: borderRadiusVal,
                                        topRight: borderRadiusVal),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none))),
                            menuStyle: MenuStyle(
                              maximumSize: WidgetStatePropertyAll<Size>(Size.fromHeight(256)),
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.zero),
                              // side: WidgetStatePropertyAll<BorderSide>(
                              //     BorderSide.none),
                              // shape: WidgetStatePropertyAll<OutlinedBorder>(
                              //     RoundedRectangleBorder(
                              //         side: BorderSide(
                              //             width: 0, style: BorderStyle.none)
                              //     )
                              // ),
                            ),
                            dropdownMenuEntries: <DropdownMenuEntry>[
                              DropdownMenuEntry(value: 1, label: 'Item 1'),
                              DropdownMenuEntry(value: 2, label: 'Item 2'),
                              DropdownMenuEntry(value: 3, label: 'Item 3'),
                              DropdownMenuEntry(value: 4, label: 'Item 4'),
                              DropdownMenuEntry(value: 5, label: 'Item 5'),
                              DropdownMenuEntry(value: 6, label: 'Item 6'),
                              DropdownMenuEntry(value: 7, label: 'Item 7'),
                              DropdownMenuEntry(value: 8, label: 'Item 8'),
                            ])
                      ],
                    ),
                  ),
                ),
                Card.filled(
                  color: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: 144,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MultiDropdown(
                            searchEnabled: false,
                            maxSelections: 3,
                            searchDecoration: SearchFieldDecoration(),
                            dropdownDecoration: DropdownDecoration(),
                            fieldDecoration: FieldDecoration(
                                suffixIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                borderRadius: 8,
                                prefixIcon: Icon(
                                  PlatformIcons(context).timeSolid,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))),
                                focusedBorder: null,
                                backgroundColor: Colors.red.shade400,
                                hintText: 'Thời Gian',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            items: [
                              DropdownItem(label: 'Item 1', value: 'Item 1'),
                              DropdownItem(label: 'Item 2', value: 'Item 2'),
                              DropdownItem(label: 'Item 3', value: 'Item 3'),
                              DropdownItem(label: 'Item 4', value: 'Item 4'),
                              DropdownItem(label: 'Item 5', value: 'Item 5'),
                            ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            PlatformElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
