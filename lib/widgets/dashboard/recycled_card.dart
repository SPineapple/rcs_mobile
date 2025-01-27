import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rcs_mobile/model/recycled_item_model.dart';
import 'package:rcs_mobile/screens/recycle_item_detail_screen.dart';

class RecycledCard extends StatelessWidget {
  final RecycledItem recycledItem;

  const RecycledCard({
    Key key,
    this.recycledItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 25,
              child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width - 55,
                height: 120,
                child: Padding(
                  padding: EdgeInsets.only(left: 85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DateFormat('yyyy-MM-dd kk:mm')
                                .format(recycledItem.dateTime),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              recycledItem.name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          Container(
                            height: 3,
                            width: 100,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3),
                                bottomLeft: Radius.circular(3),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              recycledItem.description,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          tooltip: 'Item details',
                          onPressed: () {
                            print('recycledItem.id = ' +
                                recycledItem.id.toString());
                            Navigator.of(context).pushNamed(
                                RecycleItemDetailScreen.routeName,
                                arguments: recycledItem.id);
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryVariant
                          .withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 25,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: recycledItem.imagePath != null
                    ? Image.file(
                        File(recycledItem.imagePath),
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.fill,
                      )
                    : Image.network(
                        'https://via.placeholder.com/80',
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
