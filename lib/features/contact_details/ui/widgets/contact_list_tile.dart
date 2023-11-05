import 'dart:convert';
import 'dart:typed_data';
import 'package:azodha_task/features/contact_details/bloc/contact_details_bloc.dart';
import 'package:azodha_task/features/contact_form/bloc/form_bloc.dart';
import 'package:azodha_task/features/contact_form/ui/contact_form.dart';
import 'package:azodha_task/models/contact_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ContactDetailsListTile extends StatelessWidget {
  final ContactDetailsBloc contactDetailsBloc;
  final List<Contact> contacts;

  ContactDetailsListTile({
    required this.contacts,
    required this.contactDetailsBloc,
    super.key,
  });

  final cacheManager = CacheManager(Config(
    'my_custom_cache_key',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ));

  Image getImageWidget(int index) {
    if (contacts[index].image == null || contacts[index].image!.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png',
        errorBuilder: (context, _, __) {
          return Image.asset('assets/images/invalid_placeholder.png');
        },
      );
    }
    try {
      switch (contacts[index].imageType) {
        case 0:
          {
            // file image
            Uint8List bytes = base64.decode(contacts[index].image ?? '');
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
              contacts[index].image ?? '',
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        case 2:
          // network image
          {
            return Image.network(
              contacts[index].image ?? '',
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return InkWell(
          splashColor: Colors.cyan.shade100.withOpacity(0.5),
          onTap: () {
            contactDetailsBloc.add(
              NavigateToContactDetails(contacts[index]),
            );
          },
          child: Card(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.cyan.shade900,
                width: 2,
              ),
            ),
            shadowColor: Colors.grey[400],
            elevation: 10,
            margin:
                EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.05),
            child: Padding(
              padding: EdgeInsets.all(h * 0.019),
              child: Column(
                children: [
                  ListTile(
                    onTap: null,
                    leading: Container(
                      height: h * 0.1,
                      width: h * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white60,
                          width: 0.75,
                        ),
                        image: contacts[index].imageType == 0
                            ? DecorationImage(
                                image: getImageWidget(index).image)
                            : null,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.shade100.withOpacity(0.5),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: contacts[index].imageType != 0
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: contacts[index].image ?? '',
                                placeholder: (context, url) {
                                  return Image.asset(
                                      'assets/images/placeholder.png');
                                },
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                      'assets/images/placeholder.png');
                                },
                                cacheManager: cacheManager,
                                fadeInDuration: const Duration(
                                  milliseconds: 100,
                                ),
                                fit: BoxFit.fitWidth,
                                key: UniqueKey(),
                              ),
                            )
                          : null,
                    ),
                    title: SizedBox(
                      width: w * 0.7,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          (contacts[index].name ?? 'No Name').padRight(25),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.all(h * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contacts[index].phone ?? 'No Phone',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: w * 0.4,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                (contacts[index].email ?? 'No Email')
                                    .padRight(25),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push<bool>(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => FormBloc(),
                                child: ContactForm(
                                  isEditing: true,
                                  contact: contacts[index],
                                ),
                              ),
                            ),
                          )
                              .then((value) {
                            if (value != null && value) {
                              contactDetailsBloc.add(ContactDetailsLoadEvent());
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        onPressed: () {
                          // Confirm deletion dialog or directly delete
                          if (contacts[index].name != null &&
                              contacts[index].name!.isNotEmpty) {
                            contactDetailsBloc.add(
                              ContactDetailsDelete(
                                  contacts[index].documentID ?? 'No Name'),
                            );
                          } else {
                            // Invalid Document ID - do error handling
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
