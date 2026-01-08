enum AuthMethod { email, social }

enum BusinessType { company, individual }

class SignupFlowState {
  final AuthMethod? method;
  final String? email;
  final String? password;

  final BusinessType businessType;

  // business fields
  final String? restaurantName;
  final String? contactName;
  final String? phone;

  // company
  final String? companyName;
  final String? juristicId;
  final String? companyAddress;

  // individual
  final String? firstName;
  final String? lastName;
  final String? nationalId;
  final String? idCardAddress;

  // delivery address
  final String? province;
  final String? district;
  final String? subdistrict;
  final String? postalCode;

  const SignupFlowState({
    this.method,
    this.email,
    this.password,
    this.businessType = BusinessType.company,
    this.restaurantName,
    this.contactName,
    this.phone,
    this.companyName,
    this.juristicId,
    this.companyAddress,
    this.firstName,
    this.lastName,
    this.nationalId,
    this.idCardAddress,
    this.province,
    this.district,
    this.subdistrict,
    this.postalCode,
  });

  SignupFlowState copyWith({
    AuthMethod? method,
    String? email,
    String? password,
    BusinessType? businessType,
    String? restaurantName,
    String? contactName,
    String? phone,
    String? companyName,
    String? juristicId,
    String? companyAddress,
    String? firstName,
    String? lastName,
    String? nationalId,
    String? idCardAddress,
    String? province,
    String? district,
    String? subdistrict,
    String? postalCode,
  }) {
    return SignupFlowState(
      method: method ?? this.method,
      email: email ?? this.email,
      password: password ?? this.password,
      businessType: businessType ?? this.businessType,
      restaurantName: restaurantName ?? this.restaurantName,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      companyName: companyName ?? this.companyName,
      juristicId: juristicId ?? this.juristicId,
      companyAddress: companyAddress ?? this.companyAddress,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nationalId: nationalId ?? this.nationalId,
      idCardAddress: idCardAddress ?? this.idCardAddress,
      province: province ?? this.province,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  static const empty = SignupFlowState();
}
