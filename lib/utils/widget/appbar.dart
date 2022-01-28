// ignore_for_file: missing_return, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clever/page/connect/connect.dart';
import 'package:clever/page/connect/login/login.dart';
import 'package:clever/page/home.dart';
import 'package:clever/utils/mdls/user/user.dart';
import 'package:clever/utils/state/feed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Widget mainAppBar(BuildContext context, TextEditingController controller) {
  return SizedBox(
    height: 80,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'CleverCase',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Color.fromRGBO(16, 164, 120, 1)),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 33),
                      color: const Color.fromRGBO(53, 57, 69, 1),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'Discover',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    ),
                    const SizedBox(
                      width: 33,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'How it works',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 256,
                      height: 40,
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color.fromRGBO(119, 126, 144, 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(53, 57, 69, 0.7),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(53, 57, 69, 1),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(53, 57, 69, 0.7),
                            ),
                          ),
                          isCollapsed: true,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(119, 126, 144, 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          color: Color.fromRGBO(119, 126, 144, 1),
                        ),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      height: 40,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(69, 178, 107, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                        ),
                        child: const Text('Upload',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        child: const Text('Connect',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(Login.routeName),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 1,
            color: const Color.fromRGBO(53, 57, 69, 1),
          ),
        )
      ],
    ),
  );
}

Widget mainAppBarAU(BuildContext context, TextEditingController controller,
    {Function() function}) {
  return SizedBox(
    height: 80,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'CleverCase',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Color.fromRGBO(16, 164, 120, 1)),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 33),
                      color: const Color.fromRGBO(53, 57, 69, 1),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'Discover',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    ),
                    const SizedBox(
                      width: 33,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'How it works',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 256,
                      height: 40,
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color.fromRGBO(119, 126, 144, 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(53, 57, 69, 0.7),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(53, 57, 69, 1),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(53, 57, 69, 0.7),
                            ),
                          ),
                          isCollapsed: true,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(119, 126, 144, 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          color: Color.fromRGBO(119, 126, 144, 1),
                        ),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      height: 40,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(69, 178, 107, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                        ),
                        child: const Text('Upload',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          function();
                        },
                      ),
                    ),
                    StreamBuilder<UserData>(
                        stream: FeedState().authUser,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserData userData = snapshot.data;

                            return SizedBox(
                              height: 40,
                              child: TextButton(
                                child: Row(
                                  children: [
                                    userData.photo != null &&
                                            userData.photo != ''
                                        ? CachedNetworkImage(
                                            imageUrl: userData.photo,
                                            cacheManager: DefaultCacheManager(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                            ),
                                            placeholderFadeInDuration:
                                                const Duration(
                                                    milliseconds: 500),
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white38
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
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
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Center(
                                                child: Text(
                                                    userData.name[0]
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              color: Colors.white,
                                              fontSize: 15)),
                                    ),
                                  ],
                                ),
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed(Login.routeName),
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
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 1,
            color: const Color.fromRGBO(53, 57, 69, 1),
          ),
        )
      ],
    ),
  );
}

Widget loginAppBar(BuildContext context) {
  return SizedBox(
    height: 80,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'CleverCase',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Color.fromRGBO(16, 164, 120, 1)),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 33),
                      color: const Color.fromRGBO(53, 57, 69, 1),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'Discover',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    ),
                    const SizedBox(
                      width: 33,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(Home.routeName),
                      child: const Text(
                        'How it works',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 1,
            color: const Color.fromRGBO(53, 57, 69, 1),
          ),
        )
      ],
    ),
  );
}
