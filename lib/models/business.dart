import 'dart:convert';

class Business {
  final String id;
  final String name;
  final String location;
  final String contactNumber;

  Business({
    required this.id,
    required this.name,
    required this.location,
    required this.contactNumber,
  });

  Business copyWith({
    String? id,
    String? name,
    String? location,
    String? contactNumber,
    bool? isContactValid,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }

  /// Normalization from messy JSON keys
  factory Business.fromJson(Map<String, dynamic> json) {
    final rawName = (json['biz_name'] ?? '').toString().trim();
    final rawLocation = (json['bss_location'] ?? '').toString().trim();
    final rawContact = (json['contct_no'] ?? '').toString().trim();

    final id = base64Encode(utf8.encode('$rawName|$rawLocation|$rawContact'));

    return Business(
      id: id,
      name: rawName,
      location: rawLocation,
      contactNumber: rawContact,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'biz_name': name,
    'bss_location': location,
    'contct_no': contactNumber,
  };
}
