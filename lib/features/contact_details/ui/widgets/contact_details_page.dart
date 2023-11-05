import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/contact_model.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  ContactDetailsPage({
    super.key,
    required this.contact,
  });

  final cacheManager = CacheManager(Config(
    'my_custom_cache_key',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ));

  Image getImageWidget() {
    if (contact.image == null || contact.image!.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png',
        errorBuilder: (context, _, __) {
          return Image.asset('assets/images/invalid_placeholder.png');
        },
      );
    }
    try {
      switch (contact.imageType) {
        case 0:
          {
            // file image
            Uint8List bytes = base64.decode(contact.image ?? '');
            return Image.memory(
              bytes,
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        case 1:
          // camera image
          {
            return Image.network(
              contact.image ?? '',
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        case 2:
          // network image
          {
            return Image.network(
              contact.image ?? '',
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        default:
          {
            return Image.asset(
              'assets/images/placeholder.png',
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
      }
    } catch (e) {
      return Image.asset(
        'assets/images/invalid_placeholder.png',
      );
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Phone Number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+91$phoneNumber',
    );

    if (!(await launchUrl(launchUri))) {
      throw "Error occured trying to call that number.";
    }
  }

  Future<void> _sendSMS(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Phone Number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: '+91$phoneNumber',
    );

    if (!(await launchUrl(launchUri))) {
      throw "Error occured trying to call that number.";
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Phone Number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (!(await launchUrl(launchUri))) {
      throw "Error occured trying to call that number.";
    }
  }

  Future<void> openMapWithAddress(BuildContext context, String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!(await MapsLauncher.launchQuery(query))) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could Not Launch Address. Please Type Manually'),
          backgroundColor: Colors.red,
        ),
      );
      Future.delayed(const Duration(seconds: 2)).then((value) {
        query = '';
        launchUrl(
          Uri(
            scheme: 'https',
            path: 'www.google.com/maps/search/?api=1&query=$query',
          ),
        );
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theme data for consistent styling
    final ThemeData themeData = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;

    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Contact Details - ',
              style: TextStyle(
                fontSize: screenSize.height * 0.025,
              ),
            ),
            Expanded(
              child: Text(
                contact.name?.split(" ")[0] ?? 'No Name',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenSize.height * 0.025,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: themeData.colorScheme.primary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          children: [
            SizedBox(height: padding),
            Container(
              height: screenSize.height * 0.35,
              width: screenSize.width * 0.65,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white60,
                  width: 0.75,
                ),
                image: contact.imageType == 0
                    ? DecorationImage(image: getImageWidget().image)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.shade100.withOpacity(0.5),
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: contact.imageType != 0
                  ? CachedNetworkImage(
                      imageUrl: contact.image ?? '',
                      placeholder: (context, url) {
                        return Image.asset('assets/images/placeholder.png');
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset('assets/images/placeholder.png');
                      },
                      cacheManager: cacheManager,
                      fadeInDuration: const Duration(
                        milliseconds: 100,
                      ),
                      fit: BoxFit.fitWidth,
                      key: UniqueKey(),
                    )
                  : null,
            ),
            SizedBox(height: padding),
            Card(
              color: themeData.colorScheme.primaryContainer.withOpacity(0.6),
              margin: EdgeInsets.all(padding),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context,
                      icon: Icons.person,
                      detail: contact.name ?? 'No Name',
                      isHeader: true,
                    ),
                    Divider(
                      thickness: 1.7,
                      color: Colors.white,
                    ),
                    Column(
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.email,
                          detail: contact.email ?? 'No Email',
                        ),
                        Row(
                          children: [
                            Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.yellow,
                                  width: 1,
                                ),
                              ),
                              onPressed: () => _sendEmail(
                                  context, contact.email?.trim() ?? ''),
                              child: Text(
                                'Email',
                                style: TextStyle(color: Colors.yellow),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.background,
                      indent: screenSize.width * 0.04,
                    ),
                    Column(
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.phone,
                          detail: contact.phone ?? 'No Phone',
                        ),
                        Row(
                          children: [
                            Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.yellow,
                                  width: 1,
                                ),
                              ),
                              onPressed: () => _makePhoneCall(
                                  context, contact.phone?.trim() ?? ''),
                              child: Text(
                                'Call',
                                style: TextStyle(color: Colors.yellow),
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.03),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.yellow,
                                  width: 1,
                                ),
                              ),
                              onPressed: () => _sendSMS(
                                  context, contact.phone?.trim() ?? ''),
                              child: Text(
                                'Message',
                                style: TextStyle(color: Colors.yellow),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.background,
                      indent: screenSize.width * 0.04,
                    ),
                    Column(
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.location_on,
                          detail: contact.address ?? 'No Address',
                        ),
                        Row(
                          children: [
                            Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.yellow,
                                  width: 1,
                                ),
                              ),
                              onPressed: () => openMapWithAddress(
                                  context, contact.address?.trim() ?? ''),
                              child: Text(
                                'View Map',
                                style: TextStyle(color: Colors.yellow),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon, required String detail, bool isHeader = false}) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 8.0 : 4.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: themeData.colorScheme.primaryContainer,
            radius: MediaQuery.of(context).size.height * 0.022,
            child: Icon(
              icon,
              color: Colors.amberAccent,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              detail,
              style: isHeader
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.028,
                      fontWeight: FontWeight.bold,
                    )
                  : TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
