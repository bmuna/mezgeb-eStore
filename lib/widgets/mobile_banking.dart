import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/stores/size_config.dart';

class MobileBanking extends StatefulWidget {
  @override
  _MobileBankingState createState() => _MobileBankingState();
}

class _MobileBankingState extends State<MobileBanking> {
  Firestore firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('project')
          .document("accounts")
          .collection("accounts")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        //final int projectsCount = snapshot.data.documents.length;
        List<DocumentSnapshot> documents = snapshot.data.documents;
        return Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.1 * SizeConfig.heightMultiplier,
              vertical: 1 * SizeConfig.heightMultiplier,
            ),
            child: ExpansionTileList(
              firestore: firestore,
              documents: documents,
            ),
          ),
        );
      },
    );
  }
}

class ExpansionTileList extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  final Firestore firestore;

  ExpansionTileList({this.documents, this.firestore});

  List<Widget> _getChildren() {
    List<Widget> children = [];
    documents.forEach((doc) {
      children.add(
        ProjectsExpansionTile(
          image: doc['image'],
          name: doc['bankName'],
//          projectKey: doc.documentID,
          firestore: firestore,
        ),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: _getChildren(),
    );
  }
}

class ProjectsExpansionTile extends StatelessWidget {
  ProjectsExpansionTile({this.image, this.name, this.firestore});
  final String image;
//  final String projectKey;
  final String name;
  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
//    PageStorageKey _projectKey = PageStorageKey('$projectKey');

    return ExpansionTile(
//      key: _projectKey,
      leading: SizedBox(
        height: 50,
        width: 50,
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
          imageUrl: image,
//        fit: BoxFit.cover,
        ),
      ),
      title: Text(
        name,
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
        StreamBuilder(
            stream: firestore
                .collection('project')
                .document("accounts")
                .collection('accounts')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              //final int surveysCount = snapshot.data.documents.length;
              List<DocumentSnapshot> documents = snapshot.data.documents;

              List<Widget> surveysList = [];
              documents.forEach((doc) {
                PageStorageKey _surveyKey =
                    new PageStorageKey('${doc.documentID}');
                surveysList.add(
                  Column(
                    children: <Widget>[
                      ListTile(
                        key: _surveyKey,
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
                          doc['accountName'],
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                ),
                              ),
                        ),
//                  title: Text(doc['surveyName']),
                      )
                    ],
                  ),
                );
              });
              return Column(children: surveysList);
            }),
        StreamBuilder(
            stream: firestore
                .collection('project')
                .document("accounts")
                .collection('accounts')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              //final int surveysCount = snapshot.data.documents.length;
              List<DocumentSnapshot> documents = snapshot.data.documents;
              List<Widget> surveysList2 = [];
              documents.forEach((doc) {
                String accNumberCopy = doc['accountNumber'];
                PageStorageKey _surveyKey2 =
                    new PageStorageKey('${doc.documentID}');
                surveysList2.add(
                  Column(
                    children: <Widget>[
                      ListTile(
                        key: _surveyKey2,
                        title: Text(
                          'Account Number',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .merge(TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier,
                              )),
                        ),
                        trailing: FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: <Widget>[
                              SelectableText(
                                accNumberCopy,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .merge(
                                      TextStyle(
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),
                                    ),
                              ),
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
                                      duration: Duration(milliseconds: 500),
                                      content: Container(
                                        height: 5 * SizeConfig.heightMultiplier,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  SizeConfig.heightMultiplier,
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
//                  title: Text(doc['surveyName']),
                      )
                    ],
                  ),
                );
              });
              return Column(children: surveysList2);
            }),
      ],
    );
  }
}
