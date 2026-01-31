/// User Model
/// Represents a user in the system (Student, Organizer, HOD, Principal, Admin)
class User {
  final int userId;
  final String fullName;
  final String email;
  final int roleId;
  final String roleName;
  final int? deptId;
  final String? deptName;
  final DateTime? createdAt;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.roleId,
    required this.roleName,
    this.deptId,
    this.deptName,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      roleId: json['role_id'] ?? 0,
      roleName: json['role_name'] ?? '',
      deptId: json['dept_id'],
      deptName: json['dept_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'role_id': roleId,
      'role_name': roleName,
      'dept_id': deptId,
      'dept_name': deptName,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Role Model
class Role {
  final int roleId;
  final String roleName;

  Role({
    required this.roleId,
    required this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['role_id'] ?? 0,
      roleName: json['role_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'role_name': roleName,
    };
  }
}

/// Department Model
class Department {
  final int deptId;
  final String deptName;

  Department({
    required this.deptId,
    required this.deptName,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      deptId: json['dept_id'] ?? 0,
      deptName: json['dept_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dept_id': deptId,
      'dept_name': deptName,
    };
  }
}
