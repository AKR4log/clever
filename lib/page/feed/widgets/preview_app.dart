import 'package:cached_network_image/cached_network_image.dart';
import 'package:clever/page/product/product.dart';
import 'package:clever/utils/mdls/app/app.dart';
import 'package:clever/utils/mdls/app/cat.dart';
import 'package:clever/utils/mdls/user/user.dart';
import 'package:clever/utils/service/state/feed_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PreviewApp extends StatefulWidget {
  final Application application;
  const PreviewApp({Key key, this.application}) : super(key: key);

  @override
  _PreviewAppState createState() => _PreviewAppState();
}

class _PreviewAppState extends State<PreviewApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/product',
              arguments: {'uid': widget.application.uidFile});
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.application.url['absolute'],
              cacheManager: DefaultCacheManager(),
              imageBuilder: (context, imageProvider) => Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 320,
                      height: 240,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: StreamBuilder<Cat>(
                          stream: FeedState(
                                  uidCat: widget.application.categories[0])
                              .getCat,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Cat cat = snapshot.data;
                              return Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 35,
                                    child: TextButton(
                                      child: Text(
                                        cat.name['en'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    69, 178, 107, 0.55)),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 15)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  69, 178, 107, 0.85),
                                              width: 1.25),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                height: 35,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white38.withOpacity(0.05)),
                              );
                            }
                          }),
                    ),
                  )
                ],
              ),
              placeholderFadeInDuration: const Duration(milliseconds: 500),
              placeholder: (context, url) => Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white38.withOpacity(0.025),
                ),
                width: 320,
                child: const Center(
                    child: SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(),
                )),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            StreamBuilder<UserData>(
                stream: FeedState(uidUser: widget.application.author).getUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 40,
                      child: Row(
                        children: [
                          userData.photo != null && userData.photo != ''
                              ? CachedNetworkImage(
                                  imageUrl: userData.photo,
                                  cacheManager: DefaultCacheManager(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  placeholderFadeInDuration:
                                      const Duration(milliseconds: 500),
                                  placeholder: (context, url) => Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white38.withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : ClipRRect(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            16, 184, 120, 0.45),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Center(
                                      child: Text(
                                          userData.name[0].toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 100,
                            child: Text(userData.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 40,
                      width: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white38.withOpacity(0.025)),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
