import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:azodha_task/features/contact_form/bloc/form_bloc.dart' as fb;
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

  Future<String?> pickImageAndConvertToBase64(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64String = base64UrlEncode(imageBytes);
      return base64String;
    }
    return null;
  }

  Future<void> uploadImage(BuildContext context) async {
    String? base64Url = await pickImageAndConvertToBase64(
        _imageType == 0 ? ImageSource.gallery : ImageSource.camera);

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

  void initializeControllers() {
    if (widget.contact != null && widget.isEditing) {
      _nameController.text = widget.contact!.name ?? '';
      _emailController.text = widget.contact!.email ?? '';
      _phoneController.text = widget.contact!.phone ?? '';
      _addressController.text = widget.contact!.address ?? '';
      _imageController.text = widget.contact!.image ?? '';
      _imageType =
          _imageType == -1 ? widget.contact!.imageType ?? 0 : _imageType;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('_imageType = $_imageType');
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.isEditing ? 'Edit' : ''} Contact Form'),
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

          initializeControllers();
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100,
                      side: const BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      context.read<fb.FormBloc>().add(fb.ResetImage());
                    },
                    child: const Text('Choose Image Source'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: _imageType == 0
                              ? Colors.lightGreen.shade100
                              : Colors.lightBlue.shade100,
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _imageType = 0;
                            _imageController.text = '';
                          });
                          context.read<fb.FormBloc>().add(fb.ImageFromFile());
                        },
                        child: const Text('Gallery'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: _imageType == 1
                              ? Colors.lightGreen.shade100
                              : Colors.lightBlue.shade100,
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _imageController.clear();
                            _imageType = 1;
                          });
                          context.read<fb.FormBloc>().add(fb.ImageFromCamera());
                        },
                        child: const Text('Camera'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: _imageType == 2
                              ? Colors.lightGreen.shade100
                              : Colors.lightBlue.shade100,
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _imageType = 2;
                            _imageController.clear();
                          });
                          context.read<fb.FormBloc>().add(fb.ImageFromURL());
                        },
                        child: const Text('URL'),
                      ),
                    ],
                  ),
                  if (state is! fb.GetImageFromCameraState &&
                      state is! fb.GetImageFromFileState &&
                      _imageType != -1)
                    TextFormField(
                      controller: _imageController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your image URL';
                        }
                        return null;
                      },
                    ),
                  ElevatedButton(
                    onPressed: () {
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
                          context.read<fb.FormBloc>().add(fb.FormUpdate(
                                documentID: widget.contact!.documentID ?? '',
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                address: _addressController.text,
                                image: _imageController.text,
                                imageType: _imageType,
                              ));
                        }
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
}
