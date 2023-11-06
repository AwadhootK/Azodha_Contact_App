import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:azodha_task/features/contact_details/bloc/contact_details_bloc.dart';
import 'package:azodha_task/features/contact_form/bloc/form_bloc.dart';
import 'package:azodha_task/features/contact_form/ui/contact_form.dart';
import 'package:azodha_task/models/contact_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactDetailsListTile extends StatefulWidget {
  final ContactDetailsBloc contactDetailsBloc;
  final List<Contact> contacts;

  ContactDetailsListTile({
    required this.contacts,
    required this.contactDetailsBloc,
    super.key,
  });

  @override
  State<ContactDetailsListTile> createState() => _ContactDetailsListTileState();
}

class _ContactDetailsListTileState extends State<ContactDetailsListTile> {
  final cacheManager = CacheManager(Config(
    'my_custom_cache_key',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ));

  final FixedExtentScrollController _controller = FixedExtentScrollController();
  int prevIndex = 0;

  @override
  void initState() {
    super.initState();
    updateController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Image getImageWidget(int index) {
    if (widget.contacts[index].image == null ||
        widget.contacts[index].image!.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png',
        errorBuilder: (context, _, __) {
          return Image.asset('assets/images/invalid_placeholder.png');
        },
      );
    }
    try {
      switch (widget.contacts[index].imageType) {
        case 0:
          {
            // file image
            Uint8List bytes = base64.decode(widget.contacts[index].image ?? '');
            return Image.memory(
              bytes,
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        // case 1:
        //   // camera image
        //   {
        //     return Image.network(
        //       contacts[index].image ?? '',
        //       errorBuilder: (context, _, __) {
        //         return Image.asset('assets/images/invalid_placeholder.png');
        //       },
        //     );
        //   }
        // case 2:
        //   // network image
        //   {
        //     return Image.network(
        //       contacts[index].image ?? '',
        //       errorBuilder: (context, _, __) {
        //         return Image.asset('assets/images/invalid_placeholder.png');
        //       },
        //     );
        //   }
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

  // update prevIndex value to the value stored in shared preference
  void updateController() async {
    prevIndex = await readIndexFromLocalStorage();
  }

  // read value of previously visited index from shared preference
  Future<int> readIndexFromLocalStorage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int index = sharedPreferences.getInt('index') ?? 0;
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // animate to previously visited index
    Future.delayed(Duration.zero, () {
      _controller.animateToItem(
        prevIndex,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
      );
    });

    return ListWheelScrollView.useDelegate(
      controller: _controller,
      physics: FixedExtentScrollPhysics(),
      itemExtent: h * 0.35,
      perspective: 0.004,
      squeeze: 0.9,
      diameterRatio: 1.7,
      onSelectedItemChanged: (index) {
        widget.contactDetailsBloc.add(SaveIndexToLocalStorage(index));
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.contacts.length,
        builder: (context, index) {
          return Card(
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.cyan.shade300.withOpacity(0.7),
                    Colors.cyan.shade700.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.cyan.shade900,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.shade900.withOpacity(0.5),
                    offset: Offset(6, 6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    offset: Offset(-6, -6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(h * 0.019),
                child: Column(
                  children: [
                    ListTile(
                      onTap: null,
                      leading: Container(
                        height: h * 0.2,
                        width: h * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white60,
                            width: 0.75,
                          ),
                          image: widget.contacts[index].imageType == 0
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
                        child: widget.contacts[index].imageType != 0
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.contacts[index].image ?? '',
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
                      title: Container(
                        width: w * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white60,
                            width: 0.75,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(h * 0.01),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              (widget.contacts[index].name ?? 'No Name')
                                  .padRight(25),
                              style: TextStyle(
                                color: Colors.cyan.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.all(h * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: h * 0.018,
                                  backgroundColor: Colors.cyan.shade50,
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.cyan.shade900,
                                    size: h * 0.023,
                                  ),
                                ),
                                SizedBox(
                                  width: w * 0.02,
                                ),
                                Text(
                                  widget.contacts[index].phone ?? 'No Phone',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h * 0.015,
                            ),
                            SizedBox(
                              width: w * 0.7,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: h * 0.023,
                                      backgroundColor: Colors.cyan.shade50,
                                      child: Icon(
                                        Icons.email,
                                        color: Colors.cyan.shade900,
                                        size: h * 0.023,
                                      ),
                                    ),
                                    SizedBox(
                                      width: w * 0.02,
                                    ),
                                    Text(
                                      (widget.contacts[index].email ??
                                              'No Email')
                                          .padRight(25),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade900,
                          ),
                          label: Text(
                            'View',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.9),
                            ),
                          ),
                          icon: Icon(
                            Icons.view_agenda_outlined,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          onPressed: () {
                            widget.contactDetailsBloc.add(
                              NavigateToContactDetails(widget.contacts[index]),
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade900,
                          ),
                          label: Text(
                            'Edit',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.9),
                            ),
                          ),
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
                                    contact: widget.contacts[index],
                                  ),
                                ),
                              ),
                            )
                                .then((value) {
                              if (value != null && value) {
                                widget.contactDetailsBloc
                                    .add(ContactDetailsLoadEvent());
                              }
                            });
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade900,
                          ),
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.9),
                            ),
                          ),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          onPressed: () {
                            // Confirm deletion dialog or directly delete
                            if (widget.contacts[index].name != null &&
                                widget.contacts[index].name!.isNotEmpty) {
                              widget.contactDetailsBloc.add(
                                ContactDetailsDelete(
                                    widget.contacts[index].documentID ??
                                        'No Name'),
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
      ),
    );
  }
}
