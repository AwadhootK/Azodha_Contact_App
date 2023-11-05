import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:azodha_task/features/contact_details/bloc/contact_details_bloc.dart';
import 'package:azodha_task/features/contact_form/bloc/form_bloc.dart';
import 'package:azodha_task/features/contact_form/ui/contact_form.dart';
import 'package:azodha_task/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactDetailsListTile extends StatelessWidget {
  final ContactDetailsBloc contactDetailsBloc;
  final List<Contact> contacts;

  const ContactDetailsListTile({
    required this.contacts,
    required this.contactDetailsBloc,
    super.key,
  });

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

    return ListView.separated(
      itemCount: contacts.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey[400]),
      itemBuilder: (context, index) {
        return Card(
          color: Colors.cyan[300],
          margin:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.05),
          child: InkWell(
            onTap: () {
              contactDetailsBloc.add(
                NavigateToContactDetails(contacts[index]),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: h * 0.1,
                      width: h * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        image:
                            DecorationImage(image: getImageWidget(index).image),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: SizedBox(
                      width: w * 0.7,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          (contacts[index].name ?? 'No Name').padRight(25),
                          style: TextStyle(
                              fontSize: h * 0.025, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contacts[index].phone ?? 'No Phone'),
                        SizedBox(
                          width: w * 0.4,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text((contacts[index].email ?? 'No Email')
                                .padRight(25)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue[900]!),
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
                        icon: Icon(Icons.delete, color: Colors.red.shade600),
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
