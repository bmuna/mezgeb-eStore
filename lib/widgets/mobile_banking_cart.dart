import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/stores/size_config.dart';

class MobileBankingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.1 * SizeConfig.heightMultiplier,
              vertical: 1 * SizeConfig.heightMultiplier,
            ),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('project')
                    .document("accounts")
                    .collection("accounts")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        String accNumberCopy =
                            snapshot.data.documents[index]['accountNumber'];

                        return ExpansionTile(
                          leading: SizedBox(
                            height: 7.8 * SizeConfig.heightMultiplier,
                            width: 7.8 * SizeConfig.heightMultiplier,
                            child: CachedNetworkImage(
                              height: 7.5 * SizeConfig.imageSizeMultiplier,
                              placeholder: (context, url) => Container(
                                height: 7.5 * SizeConfig.imageSizeMultiplier,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 7.5 * SizeConfig.imageSizeMultiplier,
                                child: Icon(Icons.error),
                              ),
                              imageUrl: snapshot.data.documents[index]['image'],
                            ),
                          ),
                          title: Text(
                            snapshot.data.documents[index]['bankName'],
                            style: Theme.of(context).textTheme.bodyText1.merge(
                                  TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                  ),
                                ),
                          ),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).indicatorColor,
                            size: 3.7 * SizeConfig.heightMultiplier,
                          ),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 1 * SizeConfig.heightMultiplier,
                              ),
                              child: ListTile(
                                title: Text(
                                  'Account name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(TextStyle(
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      )),
                                ),
                                trailing: Text(
                                  snapshot.data.documents[index]['accountName'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Account Number',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .merge(
                                      TextStyle(
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),
                                    ),
                              ),
                              trailing: FittedBox(
                                fit: BoxFit.fill,
                                child: Row(
                                  children: <Widget>[
                                    SelectableText(accNumberCopy,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: accNumberCopy,
                                          ),
                                        );
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            duration:
                                                Duration(milliseconds: 500),
                                            content: Container(
                                              height: 5 *
                                                  SizeConfig.heightMultiplier,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate('copied'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .merge(TextStyle(
                                                            fontSize: 2.3 *
                                                                SizeConfig
                                                                    .heightMultiplier)),
                                                  ),
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 3 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image(
                                        image: AssetImage('images/copy.png'),
                                        fit: BoxFit.cover,
                                        height: 3 * SizeConfig.heightMultiplier,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      });
                }),
          ),
//          Padding(
//            padding: EdgeInsets.symmetric(
//              horizontal: 0.1 * SizeConfig.heightMultiplier,
//              vertical: 1 * SizeConfig.heightMultiplier,
//            ),
//            child: ExpansionTile(
//              leading: Image.asset(
//                'images/cbe.jpg',
//                height: 7.5 * SizeConfig.heightMultiplier,
//              ),
//              title: Text(
//                'CBE Bank',
//                style: Theme.of(context).textTheme.bodyText1.merge(
//                      TextStyle(
//                        fontSize: 2.3 * SizeConfig.textMultiplier,
//                      ),
//                    ),
//              ),
//              trailing: Icon(
//                Icons.arrow_drop_down,
//                color: Theme.of(context).indicatorColor,
//                size: 25,
//              ),
//              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.symmetric(
//                    vertical: 1.5 * SizeConfig.heightMultiplier,
//                  ),
//                  child: ListTile(
//                    title: Text(
//                      'Account name',
//                      style: Theme.of(context).textTheme.bodyText1.merge(
//                            TextStyle(
//                              fontSize: 2 * SizeConfig.textMultiplier,
//                            ),
//                          ),
//                    ),
//                    trailing: Text(
//                      'Tefer PLC',
//                      style: Theme.of(context).textTheme.bodyText1.merge(
//                            TextStyle(
//                              fontSize: 2 * SizeConfig.textMultiplier,
//                            ),
//                          ),
//                    ),
//                  ),
//                ),
//                ListTile(
//                  title: Text(
//                    'Account Number',
//                    style: Theme.of(context).textTheme.bodyText1.merge(
//                          TextStyle(
//                            fontSize: 2 * SizeConfig.textMultiplier,
//                          ),
//                        ),
//                  ),
//                  trailing: FittedBox(
//                    fit: BoxFit.fill,
//                    child: Row(
//                      children: <Widget>[
//                        SelectableText(
//                          "2331314",
//                          style: Theme.of(context).textTheme.bodyText1.merge(
//                                TextStyle(
//                                  fontSize: 2 * SizeConfig.textMultiplier,
//                                ),
//                              ),
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        GestureDetector(
//                          onTap: () {
//                            Clipboard.setData(
//                              ClipboardData(
//                                text: "2331314",
//                              ),
//                            );
//                            Scaffold.of(context).showSnackBar(
//                              SnackBar(
//                                backgroundColor: Theme.of(context).accentColor,
//                                duration: Duration(milliseconds: 500),
//                                content: Container(
//                                  height: 5 * SizeConfig.heightMultiplier,
//                                  child: Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Text(
//                                        AppLocalizations.of(context)
//                                            .translate('copied'),
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .subtitle2
//                                            .merge(TextStyle(
//                                                fontSize: 2.3 *
//                                                    SizeConfig
//                                                        .heightMultiplier)),
//                                      ),
//                                      Icon(
//                                        Icons.check,
//                                        color: Colors.green,
//                                        size: 3 * SizeConfig.heightMultiplier,
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            );
//                          },
//                          child: Image(
//                            image: AssetImage('images/copy.png'),
//                            fit: BoxFit.cover,
//                            height: 3 * SizeConfig.heightMultiplier,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.symmetric(
//              horizontal: 0.1 * SizeConfig.heightMultiplier,
//              vertical: 1 * SizeConfig.heightMultiplier,
//            ),
//            child: ExpansionTile(
//              leading: Image.asset(
//                'images/cbir.png',
//                height: 7.5 * SizeConfig.heightMultiplier,
//              ),
//              title: Text(
//                'CBE birr',
//                style: Theme.of(context).textTheme.bodyText1.merge(
//                      TextStyle(
//                        fontSize: 2.2 * SizeConfig.textMultiplier,
//                      ),
//                    ),
//              ),
//              trailing: Icon(
//                Icons.arrow_drop_down,
//                color: Theme.of(context).indicatorColor,
//                size: 25,
//              ),
//              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.symmetric(
//                    vertical: 1.5 * SizeConfig.heightMultiplier,
//                  ),
//                  child: ListTile(
//                    title: Text(
//                      'Account name',
//                      style: Theme.of(context).textTheme.bodyText1.merge(
//                            TextStyle(
//                              fontSize: 2 * SizeConfig.textMultiplier,
//                            ),
//                          ),
//                    ),
//                    trailing: Text(
//                      'Tefer PLC',
//                      style: Theme.of(context).textTheme.bodyText1.merge(
//                            TextStyle(
//                              fontSize: 2 * SizeConfig.textMultiplier,
//                            ),
//                          ),
//                    ),
//                  ),
//                ),
//                ListTile(
//                  title: Text(
//                    'Account Number',
//                    style: Theme.of(context).textTheme.bodyText1.merge(
//                          TextStyle(
//                            fontSize: 2 * SizeConfig.textMultiplier,
//                          ),
//                        ),
//                  ),
//                  trailing: FittedBox(
//                    fit: BoxFit.fill,
//                    child: Row(
//                      children: <Widget>[
//                        SelectableText(
//                          "2331314",
//                          style: Theme.of(context).textTheme.bodyText1.merge(
//                                TextStyle(
//                                  fontSize: 2.3 * SizeConfig.textMultiplier,
//                                ),
//                              ),
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        GestureDetector(
//                          onTap: () {
//                            Clipboard.setData(
//                              ClipboardData(
//                                text: "2331314",
//                              ),
//                            );
//                            Scaffold.of(context).showSnackBar(
//                              SnackBar(
//                                backgroundColor: Theme.of(context).accentColor,
//                                duration: Duration(milliseconds: 500),
//                                content: Container(
//                                  height: 5 * SizeConfig.heightMultiplier,
//                                  child: Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Text(
//                                        AppLocalizations.of(context)
//                                            .translate('copied'),
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .subtitle2
//                                            .merge(TextStyle(
//                                                fontSize: 2.3 *
//                                                    SizeConfig
//                                                        .heightMultiplier)),
//                                      ),
//                                      Icon(
//                                        Icons.check,
//                                        color: Colors.green,
//                                        size: 3 * SizeConfig.heightMultiplier,
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            );
//                          },
//                          child: Image(
//                            image: AssetImage('images/copy.png'),
//                            fit: BoxFit.cover,
//                            height: 3 * SizeConfig.heightMultiplier,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.symmetric(
//              horizontal: 0.1 * SizeConfig.heightMultiplier,
//              vertical: 1 * SizeConfig.heightMultiplier,
//            ),
//            child: ExpansionTile(
//              leading: Image.asset(
//                'images/amole.png',
//                height: 7.5 * SizeConfig.heightMultiplier,
//              ),
//              title: Text(
//                'Amole',
//                style: Theme.of(context).textTheme.bodyText1.merge(
//                      TextStyle(
//                        fontSize: 2.2 * SizeConfig.textMultiplier,
//                      ),
//                    ),
//              ),
//              trailing: Icon(
//                Icons.arrow_drop_down,
//                color: Theme.of(context).indicatorColor,
//                size: 25,
//              ),
//              children: <Widget>[
//                ListTile(
//                  title: Text(
//                    'Account name',
//                    style: Theme.of(context).textTheme.bodyText1.merge(
//                          TextStyle(
//                            fontSize: 2 * SizeConfig.textMultiplier,
//                          ),
//                        ),
//                  ),
//                  trailing: Text(
//                    'Tefer PLC',
//                    style: Theme.of(context).textTheme.bodyText1.merge(
//                          TextStyle(
//                            fontSize: 2 * SizeConfig.textMultiplier,
//                          ),
//                        ),
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.symmetric(
//                    vertical: 1.5 * SizeConfig.heightMultiplier,
//                  ),
//                  child: ListTile(
//                    title: Text(
//                      'Account Number',
//                      style: Theme.of(context).textTheme.bodyText1.merge(
//                            TextStyle(
//                              fontSize: 2 * SizeConfig.textMultiplier,
//                            ),
//                          ),
//                    ),
//                    trailing: FittedBox(
//                      fit: BoxFit.fill,
//                      child: Row(
//                        children: <Widget>[
//                          SelectableText(
//                            "2331314",
//                            style: Theme.of(context).textTheme.bodyText1.merge(
//                                  TextStyle(
//                                    fontSize: 2.3 * SizeConfig.textMultiplier,
//                                  ),
//                                ),
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          GestureDetector(
//                            onTap: () {
//                              Clipboard.setData(
//                                ClipboardData(
//                                  text: "2331314",
//                                ),
//                              );
//                              Scaffold.of(context).showSnackBar(
//                                SnackBar(
//                                  backgroundColor:
//                                      Theme.of(context).accentColor,
//                                  duration: Duration(milliseconds: 500),
//                                  content: Container(
//                                    height: 5 * SizeConfig.heightMultiplier,
//                                    child: Row(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.spaceBetween,
//                                      children: <Widget>[
//                                        Text(
//                                          AppLocalizations.of(context)
//                                              .translate('copied'),
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .subtitle2
//                                              .merge(TextStyle(
//                                                  fontSize: 2.3 *
//                                                      SizeConfig
//                                                          .heightMultiplier)),
//                                        ),
//                                        Icon(
//                                          Icons.check,
//                                          color: Colors.green,
//                                          size: 3 * SizeConfig.heightMultiplier,
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              );
//                            },
//                            child: Image(
//                              image: AssetImage('images/copy.png'),
//                              fit: BoxFit.cover,
//                              height: 3 * SizeConfig.heightMultiplier,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
        ],
      ),
    );
  }
}
