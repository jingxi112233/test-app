import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class UserService extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  String get nickname => _user?.nickname ?? '游客';
  String get avatar => _user?.avatar ?? '';

  UserService() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final openid = prefs.getString('openid');
    if (openid != null && openid.isNotEmpty) {
      _user = UserModel(
        openid: openid,
        nickname: prefs.getString('nickname') ?? '用户',
        avatar: prefs.getString('avatar') ?? '',
        phone: prefs.getString('phone') ?? '',
      );
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> mockLogin() async {
    // 模拟登录（实际项目替换为真实微信/手机号登录）
    final prefs = await SharedPreferences.getInstance();
    const mockUser = UserModel(
      openid: 'mock_openid_001',
      nickname: '测试用户',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
    );
    await prefs.setString('openid', mockUser.openid);
    await prefs.setString('nickname', mockUser.nickname);
    await prefs.setString('avatar', mockUser.avatar);
    _user = mockUser;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateProfile({String? nickname, String? avatar}) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (nickname != null) await prefs.setString('nickname', nickname);
    if (avatar != null) await prefs.setString('avatar', avatar);
    _user = UserModel(
      openid: _user!.openid,
      nickname: nickname ?? _user!.nickname,
      avatar: avatar ?? _user!.avatar,
      phone: _user!.phone,
    );
    notifyListeners();
  }
}
