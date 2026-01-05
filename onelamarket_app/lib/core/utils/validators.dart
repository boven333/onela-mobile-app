class Validators {
  static String? email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'กรุณากรอกอีเมล';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
    if (!ok) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }
}
