import 'package:flutter/material.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/delivered_category.dart';
import 'package:mezgebestore/pages/cancelled_category.dart';
import 'package:mezgebestore/pages/processing_category.dart';
import 'package:mezgebestore/stores/size_config.dart';

class MyOrder extends StatefulWidget {
  static const String id = 'myOrder_screen';

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  TabController tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 2.8 * SizeConfig.heightMultiplier,
            color: Theme.of(context).indicatorColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.6 * SizeConfig.widthMultiplier,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.7 * SizeConfig.widthMultiplier,
                ),
                child: Text(AppLocalizations.of(context).translate("myOrder"),
                    style:
                        Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 4.6 * SizeConfig.textMultiplier,
                            ))),
              ),
            ),
            SizedBox(
              height: 3.1 * SizeConfig.heightMultiplier,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.7 * SizeConfig.widthMultiplier,
              ),
              child: Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.2 * SizeConfig.widthMultiplier,
                          ),
                        ),
                      ),
                    ),
                    TabBar(
                      // TabBar
                      controller: tabController,
                      labelColor: Theme.of(context).accentColor,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.3 * SizeConfig.textMultiplier,
                      ),
                      unselectedLabelColor: Theme.of(context).accentColor,
                      unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 2.3 * SizeConfig.textMultiplier),
                      indicatorWeight: 2,
                      indicatorColor: const Color(0xffEF3651),

                      tabs: <Widget>[
                        Tab(
                          text: AppLocalizations.of(context)
                              .translate("delivered"),
                        ),
                        Tab(
                          text: AppLocalizations.of(context)
                              .translate("processing"),
                        ),
                        Tab(
                          text: AppLocalizations.of(context)
                              .translate("cancelled"),
                        )
                      ],
                    ),
                  ]),
            ),
            Expanded(
              flex: 3,
              child: TabBarView(
                // Tab Bar View
                physics: BouncingScrollPhysics(),
                controller: tabController,
                children: <Widget>[Delivered(), Processing(), Cancelled()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
