class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String username;
  final String birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final Hair hair;
  final String ip;
  final Address address;
  final String macAddress;
  final String university;
  final Bank bank;
  final Company company;
  final String ein;
  final String ssn;
  final String userAgent;
  final Crypto crypto;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
    required this.crypto,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      username: json['username'] ?? '',
      birthDate: json['birthDate'] ?? '',
      image: json['image'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      eyeColor: json['eyeColor'] ?? '',
      hair: Hair.fromJson(json['hair'] ?? {}),
      ip: json['ip'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      macAddress: json['macAddress'] ?? '',
      university: json['university'] ?? '',
      bank: Bank.fromJson(json['bank'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
      ein: json['ein'] ?? '',
      ssn: json['ssn'] ?? '',
      userAgent: json['userAgent'] ?? '',
      crypto: Crypto.fromJson(json['crypto'] ?? {}),
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'username': username,
      'birthDate': birthDate,
      'image': image,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'eyeColor': eyeColor,
      'hair': hair.toJson(),
      'ip': ip,
      'address': address.toJson(),
      'macAddress': macAddress,
      'university': university,
      'bank': bank.toJson(),
      'company': company.toJson(),
      'ein': ein,
      'ssn': ssn,
      'userAgent': userAgent,
      'crypto': crypto.toJson(),
      'role': role,
    };
  }

  // Getter for full name
  String get fullName => '$firstName $lastName';

  // Getter for initials for avatar fallback
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $fullName, email: $email)';
}

class Hair {
  final String color;
  final String type;

  Hair({
    required this.color,
    required this.type,
  });

  factory Hair.fromJson(Map<String, dynamic> json) {
    return Hair(
      color: json['color'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'type': type,
    };
  }
}

class Address {
  final String address;
  final String city;
  final String state;
  final String stateCode;
  final String postalCode;
  final Coordinates coordinates;
  final String country;

  Address({
    required this.address,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.coordinates,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      stateCode: json['stateCode'] ?? '',
      postalCode: json['postalCode'] ?? '',
      coordinates: Coordinates.fromJson(json['coordinates'] ?? {}),
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'stateCode': stateCode,
      'postalCode': postalCode,
      'coordinates': coordinates.toJson(),
      'country': country,
    };
  }

  // Getter for formatted address
  String get formattedAddress => '$address, $city, $state $postalCode, $country';
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Bank {
  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      cardExpire: json['cardExpire'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      cardType: json['cardType'] ?? '',
      currency: json['currency'] ?? '',
      iban: json['iban'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardExpire': cardExpire,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'currency': currency,
      'iban': iban,
    };
  }
}

class Company {
  final String department;
  final String name;
  final String title;
  final Address address;

  Company({
    required this.department,
    required this.name,
    required this.title,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      department: json['department'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'name': name,
      'title': title,
      'address': address.toJson(),
    };
  }
}

class Crypto {
  final String coin;
  final String wallet;
  final String network;

  Crypto({
    required this.coin,
    required this.wallet,
    required this.network,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      coin: json['coin'] ?? '',
      wallet: json['wallet'] ?? '',
      network: json['network'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coin': coin,
      'wallet': wallet,
      'network': network,
    };
  }
}

// Response wrapper for paginated users
class UsersResponse {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;

  UsersResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      users: (json['users'] as List<dynamic>?)
              ?.map((userJson) => User.fromJson(userJson))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  // Helper methods
  bool get hasMore => skip + limit < total;
  int get nextSkip => skip + limit;
}