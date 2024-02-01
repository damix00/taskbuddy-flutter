class LoginResponse {
  int id;
  String ipAddress;
  String userAgent;
  DateTime createdAt;

  LoginResponse({
    required this.id,
    required this.ipAddress,
    required this.userAgent,
    required this.createdAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json["id"],
      ipAddress: json["ip_address"],
      userAgent: json["user_agent"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}