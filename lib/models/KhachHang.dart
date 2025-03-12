class KhachHang {
  String id;
  String name;
  String email;
  String password;
  String gender;
  String birthdate;
  String phone;
  String address;

  KhachHang({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.birthdate,
    required this.phone,
    required this.address,
  });

  // Convert KhachHang object to a Map (for storing in a database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'birthdate': birthdate,
      'phone': phone,
      'address': address,
    };
  }

  // Convert Map to a KhachHang object (for retrieving from the database)
  factory KhachHang.fromMap(Map<String, dynamic> map) {
    return KhachHang(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      gender: map['gender'],
      birthdate: map['birthdate'],
      phone: map['phone'],
      address: map['address'],
    );
  }
}
