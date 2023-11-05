class Contact {
  String? documentID;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;
  int? imageType;
  // 0 = file, 1 = camera, 2 = url

  Contact({
    this.documentID,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
    this.imageType,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    documentID = json['documentID'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
    imageType = json['imageType'];
  }

  Map<String, dynamic> toJson() {
    return {
      'documentID': documentID,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'imageType': imageType,
    };
  }
}
