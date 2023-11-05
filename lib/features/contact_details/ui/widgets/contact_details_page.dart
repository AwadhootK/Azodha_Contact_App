import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../models/contact_model.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailsPage({
    super.key,
    required this.contact,
  });

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
            CircleAvatar(
              radius: screenSize.width * 0.3,
              backgroundImage: getImageWidget().image,
              backgroundColor: themeData.colorScheme.surface,
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
                    _buildDetailRow(
                      context,
                      icon: Icons.email,
                      detail: contact.email ?? 'No Email',
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.background,
                      indent: screenSize.width * 0.04,
                    ),
                    _buildDetailRow(
                      context,
                      icon: Icons.phone,
                      detail: contact.phone ?? 'No Phone',
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.background,
                      indent: screenSize.width * 0.04,
                    ),
                    _buildDetailRow(
                      context,
                      icon: Icons.location_on,
                      detail: contact.address ?? 'No Address',
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
