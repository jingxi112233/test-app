import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';

class ActivityDetailPage extends StatefulWidget {
  final String id;
  const ActivityDetailPage({super.key, required this.id});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  ActivityModel? _activity;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ApiService.getActivityDetail(widget.id);
    if (mounted) setState(() { _activity = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('活动详情')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activity == null
              ? const Center(child: Text('活动不存在'))
              : _buildContent(),
      bottomNavigationBar: _activity != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildContent() {
    final a = _activity!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面区域
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.event, size: 80, color: Colors.white24),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatusBadge(status: a.status, label: a.statusLabel),
                      const SizedBox(height: 8),
                      Text(
                        a.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 信息卡片
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoCard(activity: a),
                const SizedBox(height: 16),
                // 描述
                const Text(
                  '活动介绍',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  a.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 16),
                // 标签
                if (a.tags.isNotEmpty) ...[
                  const Text(
                    '活动标签',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: a.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor:
                                  AppTheme.primaryColor.withOpacity(0.08),
                              labelStyle: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 13,
                              ),
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final a = _activity!;
    final bool canRegister = a.status == 'upcoming' && !a.isFull;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canRegister
              ? () => context.push('/activity/register/${a.id}')
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                canRegister ? AppTheme.primaryColor : Colors.grey.shade300,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            a.status == 'ended'
                ? '活动已结束'
                : a.isFull
                    ? '名额已满'
                    : '立即报名',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final String label;
  const _StatusBadge({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'ongoing':
        color = AppTheme.successColor;
        break;
      case 'ended':
        color = Colors.grey;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ActivityModel activity;
  const _InfoCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row(
              icon: Icons.access_time,
              label: '开始时间',
              value: activity.startTime,
            ),
            const Divider(height: 20),
            _Row(
              icon: Icons.timer_off_outlined,
              label: '结束时间',
              value: activity.endTime,
            ),
            const Divider(height: 20),
            _Row(
              icon: Icons.location_on_outlined,
              label: '活动地点',
              value: activity.location,
            ),
            const Divider(height: 20),
            _Row(
              icon: Icons.person_outline,
              label: '主办方',
              value: activity.organizer,
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.group_outlined,
                    size: 18, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text('报名情况',
                    style: TextStyle(color: AppTheme.textSecondary)),
                const Spacer(),
                Text(
                  '${activity.currentParticipants}/${activity.maxParticipants} 人',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: activity.fillRate,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(color: AppTheme.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
