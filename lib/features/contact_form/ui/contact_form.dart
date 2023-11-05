import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:azodha_task/constants/customDecoration.dart';
import 'package:azodha_task/features/contact_form/bloc/form_bloc.dart' as fb;
import 'package:azodha_task/features/contact_form/ui/widgets/customTextButton.dart';
import 'package:azodha_task/features/contact_form/ui/widgets/customTextField.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:azodha_task/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ContactForm extends StatefulWidget {
  bool isEditing;
  final Contact? contact;

  ContactForm({
    this.isEditing = false,
    this.contact,
    super.key,
  });

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageController = TextEditingController();
  int _imageType = -1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null && widget.isEditing) {
      _nameController.text = widget.contact!.name ?? '';
      _emailController.text = widget.contact!.email ?? '';
      _phoneController.text = widget.contact!.phone ?? '';
      _addressController.text = widget.contact!.address ?? '';
      _imageController.text = widget.contact!.image ?? '';
      _imageType = widget.contact!.imageType ?? 0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<String?> pickImageAndConvertToBase64(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source, imageQuality: 50);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64String = base64UrlEncode(imageBytes);
      log('base64String = ${base64String.length}');
      return base64String;
    }
    return null;
  }

  Future<void> uploadPng() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File file = File(image.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('uploads/${DateTime.now().millisecondsSinceEpoch}.png');
      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      try {
        await uploadTask;
        final downloadUrl = await ref.getDownloadURL();
        _imageController.text = downloadUrl;
        log('Firebase URL: $downloadUrl');
      } on firebase_storage.FirebaseException catch (e) {
        print(e.message);
      }
    } else {
      _imageController.text = '';
      log('No image selected.');
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (_imageType != 0) {
      return;
    }
    String? base64Url = await pickImageAndConvertToBase64(ImageSource.gallery);

    if (base64Url != null) {
      _imageController.text = base64Url;
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('No image selected.'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Image getImageWidget() {
    if (_imageController.text.isEmpty || isLoading) {
      return Image.asset('assets/images/placeholder.png');
    }
    try {
      switch (_imageType) {
        case -1:
          {
            return Image.asset(
              'assets/images/placeholder.png',
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        case 0:
          {
            // file image
            Uint8List bytes = base64.decode(_imageController.text);
            return Image.memory(
              bytes,
              errorBuilder: (context, _, __) {
                return Image.asset(
                  'assets/images/placeholder.png',
                  errorBuilder: (context, _, __) {
                    return Image.asset('assets/images/invalid_placeholder.png');
                  },
                );
              },
            );
          }
        case 1:
          // camera image
          {
            return Image.network(
              _imageController.text,
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/invalid_placeholder.png');
              },
            );
          }
        case 2:
          // network image
          {
            return Image.network(
              _imageController.text,
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
        'assets/images/placeholder.png',
        errorBuilder: (context, _, __) {
          return Image.asset('assets/images/invalid_placeholder.png');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.isEditing ? 'Edit' : 'New'} Contact Form'),
      ),
      body: BlocConsumer<fb.FormBloc, fb.FormState>(
        listener: (context, state) {
          if (state is fb.FormSubmitSuccess) {
            SnackBar snackBar = SnackBar(
              content:
                  Text('Contact ${state.documentID} Uploaded Successfully'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            if (widget.isEditing) {
              Navigator.of(context).pop(true);
              return;
            }
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          log('form state = $state');
          if (state is fb.FormErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is fb.FormLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CustomTextField(
                    controller: _nameController,
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    labelText: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _emailController,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    labelText: 'Phone',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _addressController,
                    maxLines: 3,
                    prefixIcon: Icons.location_on,
                    textInputAction: TextInputAction.next,
                    labelText: 'Address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  InkWell(
                    onTap: () {
                      context.read<fb.FormBloc>().add(fb.ResetImage());
                    },
                    child: Text(
                      'Choose Image Source',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.cyan.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: h * 0.02,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextButton(
                        imageController: _imageController,
                        imageType: _imageType,
                        imageNumber: 0,
                        prefixIcon: Icons.file_copy,
                        onPressed: () async {
                          setState(() {
                            _imageType = 0;
                            _imageController.clear();
                          });
                          await uploadImage(context);
                          context.read<fb.FormBloc>().add(fb.ImageFromFile());
                        },
                        text: 'Gallery',
                      ),
                      CustomTextButton(
                        imageController: _imageController,
                        imageType: _imageType,
                        imageNumber: 1,
                        prefixIcon: Icons.camera,
                        onPressed: () async {
                          setState(() {
                            _imageType = 1;
                            _imageController.text =
                                'assets/images/placeholder.png';
                            isLoading = true;
                          });
                          await uploadPng();
                          setState(() {
                            isLoading = false;
                          });
                          context.read<fb.FormBloc>().add(fb.ImageFromCamera());
                        },
                        text: 'Camera',
                      ),
                      CustomTextButton(
                        imageController: _imageController,
                        prefixIcon: Icons.image,
                        imageType: _imageType,
                        imageNumber: 2,
                        onPressed: () {
                          setState(() {
                            _imageType = 2;
                            _imageController.clear();
                          });
                          context.read<fb.FormBloc>().add(fb.ImageFromURL());
                        },
                        text: 'URL',
                      ),
                    ],
                  ),
                  if (state is! fb.GetImageFromCameraState &&
                      state is! fb.GetImageFromFileState &&
                      (state is fb.GetImageFromURLState ||
                          _imageType == 2 && state is fb.FormInitial))
                    SizedBox(height: h * 0.02),
                  if (state is! fb.GetImageFromCameraState &&
                      state is! fb.GetImageFromFileState &&
                      (state is fb.GetImageFromURLState ||
                          _imageType == 2 && state is fb.FormInitial))
                    CustomTextField(
                      controller: _imageController,
                      prefixIcon: Icons.image,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      labelText: 'Image URL',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your image URL';
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: h * 0.03),
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                    padding: EdgeInsets.all(h * 0.02),
                    height: _imageController.text.isEmpty || _imageType == -1
                        ? 0
                        : h * 0.4,
                    width: _imageController.text.isEmpty || _imageType == -1
                        ? 0
                        : w * 0.4,
                    duration: const Duration(milliseconds: 250),
                    child: getImageWidget(),
                  ),
                  SizedBox(height: h * 0.03),
                  InkWell(
                    splashColor: Colors.cyan.shade900,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (!widget.isEditing) {
                          context.read<fb.FormBloc>().add(fb.SubmitForm(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                address: _addressController.text,
                                image: _imageController.text,
                                imageType: _imageType,
                              ));
                        } else {
                          context.read<fb.FormBloc>().add(
                                fb.FormUpdate(
                                  documentID: widget.contact!.documentID ?? '',
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  address: _addressController.text,
                                  image: _imageController.text,
                                  imageType: _imageType,
                                ),
                              );
                        }
                      }
                    },
                    child: Container(
                      height: h * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade900,
                        border: Border.all(
                          color: Colors.cyan.shade200,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.cyan.shade50,
                            fontWeight: FontWeight.bold,
                            fontSize: h * 0.023,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
