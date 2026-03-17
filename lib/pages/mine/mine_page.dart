import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_service.dart';
import '../../utils/app_theme.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();
    final isLoggedIn = userService.isLoggedIn;
    final user = userService.user;

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 头部用户信息卡
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, Color(0xFF5C6BC0)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: isLoggedIn && user != null
                  ? _LoggedInHeader(user: user, onLogout: () => userService.logout())
                  : _GuestHeader(onLogin: () => userService.mockLogin()),
            ),
            // 功能菜单
            _buildMenuSection(
              title: '我的活动',
              items: [
                _MenuItem(
                  icon: Icons.event_available,
                  label: '已报名活动',
                  badge: '2',
                  onTap: () => _showComingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.history,
                  label: '历史活动',
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),
            _buildMenuSection(
              title: '我的内容',
              items: [
                _MenuItem(
                  icon: Icons.article_outlined,
                  label: '我发布的知识',
                  onTap: () => _showComingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.bookmark_outline,
                  label: '我的收藏',
                  onTap: () => _showComingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.thumb_up_outlined,
                  label: '我点赞的内容',
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),
            _buildMenuSection(
              title: '设置',
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  label: '个人资料',
                  onTap: () => _showComingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: '消息通知',
                  onTap: () => _showComingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: '关于我们',
                  onTap: () => _showAbout(context),
                ),
              ],
            ),
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _confirmLogout(context, userService),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: const BorderSide(color: AppTheme.errorColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('退出登录'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Card(
            child: Column(
              children: items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Icon(item.icon, size: 18, color: AppTheme.primaryColor),
                      ),
                      title: Text(item.label,
                          style: const TextStyle(fontSize: 15)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.badge!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right,
                              color: AppTheme.textSecondary),
                        ],
                      ),
                      onTap: item.onTap,
                    ),
                    if (i < items.length - 1)
                      const Divider(
                          height: 1, indent: 56, endIndent: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('功能开发中，敬请期待 🚀')),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '活动 & 知识库',
      applicationVersion: 'v1.0.0',
      applicationLegalese: '© 2026 活动知识社区',
    );
  }

  void _confirmLogout(BuildContext context, UserService service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              service.logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}

class _LoggedInHeader extends StatelessWidget {
  final dynamic user;
  final VoidCallback onLogout;
  const _LoggedInHeader({required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white24,
          child: Text(
            user.nickname.isNotEmpty ? user.nickname[0] : 'U',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.nickname,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.phone.isNotEmpty ? user.phone : '活动社区成员',
                style:
                    const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white70),
      ],
    );
  }
}

class _GuestHeader extends StatelessWidget {
  final VoidCallback onLogin;
  const _GuestHeader({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person_outline, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('未登录',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('登录后查看完整功能',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('登录', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });
}
