import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mezgebestore/stores/size_config.dart';

class Processing extends StatefulWidget {
  @override
  _ProcessingState createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing> {
  Stream<QuerySnapshot> getData() async* {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    yield* Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('shipping')
        .snapshots();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          StreamBuilder(
              stream: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.9 * SizeConfig.widthMultiplier),
                            child: Container(
                              height: 23 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 4.0,
                                  )
                                ],
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    1.5 * SizeConfig.heightMultiplier),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '12/3/2009',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .merge(TextStyle(
                                              fontSize: 2.3 *
                                                  SizeConfig.textMultiplier)),
                                    ),
                                    SizedBox(
                                      height: 1.5 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Tracking Number:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .merge(TextStyle(
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .textMultiplier)),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          '1213242424',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .textMultiplier)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.5 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Quantity:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(TextStyle(
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier)),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              '3',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Total Amount:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(TextStyle(
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier)),
                                            ),
                                            SizedBox(
                                              width: 0.8 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '250 ETB',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .merge(TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 2.3 *
                                                              SizeConfig
                                                                  .textMultiplier)),
                                                ),
                                                SizedBox(
                                                  width: 0.8 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.1 * SizeConfig.heightMultiplier,
                                    ),
                                    Text(
                                      'Processing',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            1.8 * SizeConfig.textMultiplier,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    });
              })
        ],
      ),
    );
  }
}
