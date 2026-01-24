class RegisterRequest {
  final String username;
  final String password;

  RegisterRequest(this.username, this.password);

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}
