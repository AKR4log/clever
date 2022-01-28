import 'package:cached_network_image/cached_network_image.dart';
import 'package:clever/utils/mdls/app/app.dart';
import 'package:clever/utils/mdls/user/user.dart';
import 'package:clever/utils/state/feed_state.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: widget.application.url['absolute'],
              cacheManager: DefaultCacheManager(),
              imageBuilder: (context, imageProvider) => Container(
                width: 320,
                height: 240,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              placeholderFadeInDuration: const Duration(milliseconds: 500),
              placeholder: (context, url) => const SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          StreamBuilder<UserData>(
              stream: FeedState(uidUser: widget.application.author).getUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;

                  return SizedBox(
                    height: 40,
                    child: TextButton(
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
                      onPressed: () {},
                    ),
                  );
                } else {
                  return Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white38.withOpacity(0.05)),
                  );
                }
              }),
        ],
      ),
    );
  }
}
