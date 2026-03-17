import '../models/models.dart';

/// Mock 数据服务 - 本地演示使用
/// 真实项目中替换为腾讯云 CloudBase HTTP API 调用
class ApiService {
  static const String _cloudEnvId = 'YOUR_CLOUD_ENV_ID'; // 替换为你的云环境 ID
  static const String _baseUrl =
      'https://api.bspapp.com/client'; // 或云函数 HTTP 触发 URL

  // ==================== 活动相关 ====================

  static Future<List<ActivityModel>> getActivities({
    String? status,
    String? keyword,
  }) async {
    // TODO: 替换为真实 API 调用
    // final resp = await dio.get('$_baseUrl/activity/list');
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockActivities.where((a) {
      if (status != null && status != 'all' && a.status != status) return false;
      if (keyword != null && keyword.isNotEmpty) {
        return a.title.contains(keyword) || a.description.contains(keyword);
      }
      return true;
    }).toList();
  }

  static Future<ActivityModel?> getActivityDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _mockActivities.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> registerActivity({
    required String activityId,
    required String name,
    required String phone,
    required String email,
    String? remark,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // 模拟成功
    return true;
  }

  // ==================== 知识库相关 ====================

  static Future<List<KnowledgeModel>> getKnowledgeList({
    String? category,
    String? keyword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockKnowledge.where((k) {
      if (category != null && category != '全部' && k.category != category) {
        return false;
      }
      if (keyword != null && keyword.isNotEmpty) {
        return k.title.contains(keyword) || k.summary.contains(keyword);
      }
      return true;
    }).toList();
  }

  static Future<KnowledgeModel?> getKnowledgeDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _mockKnowledge.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> publishKnowledge({
    required String title,
    required String summary,
    required String content,
    required String category,
    required List<String> tags,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  // ==================== Mock 数据 ====================

  static final List<ActivityModel> _mockActivities = [
    ActivityModel(
      id: '1',
      title: 'Flutter 技术沙龙 2026',
      description:
          '本次沙龙将邀请多位 Flutter 专家分享最新技术实践，涵盖性能优化、状态管理、跨平台开发等热门话题。欢迎所有移动开发者参与！',
      location: '北京市朝阳区望京 SOHO T1 栋 10F',
      startTime: '2026-03-20 14:00',
      endTime: '2026-03-20 18:00',
      maxParticipants: 100,
      currentParticipants: 67,
      organizer: '技术社区',
      status: 'upcoming',
      coverImage: '',
      tags: ['Flutter', '移动开发', '技术分享'],
    ),
    ActivityModel(
      id: '2',
      title: 'AI 产品设计工作坊',
      description: '探索 AI 时代的产品设计思维，学习如何将大模型能力融入产品体验。限额 30 人小班教学。',
      location: '上海市浦东新区张江科技园',
      startTime: '2026-03-25 09:00',
      endTime: '2026-03-25 17:00',
      maxParticipants: 30,
      currentParticipants: 28,
      organizer: '设计师协会',
      status: 'upcoming',
      coverImage: '',
      tags: ['AI', '产品设计', '工作坊'],
    ),
    ActivityModel(
      id: '3',
      title: '开源贡献者大会',
      description: '汇聚国内外知名开源项目维护者，分享开源之路的经验与挑战，共同探讨开源生态建设。',
      location: '深圳市南山区腾讯滨海大厦',
      startTime: '2026-03-18 13:00',
      endTime: '2026-03-18 17:30',
      maxParticipants: 200,
      currentParticipants: 156,
      organizer: '开源基金会',
      status: 'ongoing',
      coverImage: '',
      tags: ['开源', '社区', '开发者'],
    ),
    ActivityModel(
      id: '4',
      title: 'Web3 创业者见面会',
      description: '连接 Web3 创业者、投资人和技术专家，分享前沿项目，探讨 Web3 的未来发展机遇。',
      location: '杭州市余杭区梦想小镇',
      startTime: '2026-03-10 15:00',
      endTime: '2026-03-10 19:00',
      maxParticipants: 80,
      currentParticipants: 80,
      organizer: 'Web3 联盟',
      status: 'ended',
      coverImage: '',
      tags: ['Web3', '创业', '区块链'],
    ),
  ];

  static final List<KnowledgeModel> _mockKnowledge = [
    KnowledgeModel(
      id: '1',
      title: 'Flutter 3.x 性能优化实战指南',
      summary: '深入讲解 Flutter 渲染流程，从 Widget 重建、内存管理到 Skia 渲染优化，全方位提升 App 性能。',
      content: '''
## Flutter 性能优化核心要点

### 1. 减少不必要的 Widget 重建

使用 `const` 构造函数是最简单有效的优化手段：

```dart
// 好的做法
const Text('Hello World')

// 避免这样
Text('Hello World') // 每次 build 都会创建新对象
```

### 2. 使用 RepaintBoundary 隔离重绘区域

对于频繁更新的动画组件，使用 `RepaintBoundary` 包裹：

```dart
RepaintBoundary(
  child: AnimatedWidget(),
)
```

### 3. ListView 性能优化

大列表务必使用 `ListView.builder` 而非 `ListView`：

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 4. 图片缓存策略

使用 `cached_network_image` 包管理网络图片缓存，避免重复下载。

### 5. 使用 Isolate 处理 CPU 密集任务

```dart
final result = await compute(heavyComputation, data);
```
      ''',
      author: '张三',
      authorAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=John',
      publishTime: '2026-03-15',
      viewCount: 1289,
      likeCount: 234,
      tags: ['Flutter', '性能优化', '移动开发'],
      category: '技术',
      coverImage: '',
    ),
    KnowledgeModel(
      id: '2',
      title: '产品经理如何写一份好的 PRD',
      summary: '从需求收集、竞品分析到功能定义，手把手教你写出让开发看懂、让测试好用的产品需求文档。',
      content: '''
## 优质 PRD 的六要素

### 1. 背景与目标
清晰描述为什么做这个功能，解决什么用户问题，预期达成什么业务目标。

### 2. 用户故事
用「作为XX用户，我希望YY，以便ZZ」的格式描述需求，聚焦用户价值。

### 3. 功能流程图
使用流程图清晰展示主流程、异常流程和边界情况。

### 4. 原型设计
附上 Figma 或 Axure 原型链接，标注交互细节。

### 5. 验收标准
每个功能点都要有明确的验收标准（AC），让测试有据可依。

### 6. 非功能需求
性能要求、安全要求、兼容性要求等不要遗漏。
      ''',
      author: '李四',
      authorAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Lisa',
      publishTime: '2026-03-14',
      viewCount: 876,
      likeCount: 156,
      tags: ['产品', 'PRD', '需求分析'],
      category: '产品',
      coverImage: '',
    ),
    KnowledgeModel(
      id: '3',
      title: '微信云开发数据库设计最佳实践',
      summary: '结合实际案例讲解云开发文档型数据库的集合设计、索引优化和权限控制，避免常见陷阱。',
      content: '''
## 云开发数据库核心设计原则

### 1. 集合命名规范
使用小写字母和下划线，如 `user_activities`、`knowledge_articles`。

### 2. 文档结构设计
每个文档都应包含：
- `_id`: 唯一标识（云开发自动生成）
- `createTime`: 创建时间（使用 `db.serverDate()`）
- `updateTime`: 更新时间
- `openid`: 用户标识（用于权限控制）

### 3. 索引优化
为高频查询字段添加索引，如 `status`、`createTime` 的复合索引。

### 4. 权限控制
合理使用「仅创建者可读写」规则，敏感数据不要暴露给前端。
      ''',
      author: '王五',
      authorAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Wang',
      publishTime: '2026-03-12',
      viewCount: 654,
      likeCount: 98,
      tags: ['云开发', '数据库', '微信小程序'],
      category: '技术',
      coverImage: '',
    ),
    KnowledgeModel(
      id: '4',
      title: 'UI 设计中的色彩搭配原则',
      summary: '从色彩心理学到实际设计应用，帮助开发者和设计师构建专业、美观的界面配色方案。',
      content: '''
## 配色五大原则

### 1. 60-30-10 法则
- 60% 主色调（背景、大面积）
- 30% 辅助色（卡片、次要区域）
- 10% 强调色（按钮、重要信息）

### 2. 对比度原则
文字与背景的对比度至少达到 4.5:1（WCAG AA 标准），确保可读性。

### 3. 色彩语义
- 蓝色：信任、专业、科技
- 绿色：成功、健康、环保
- 红色：错误、警告、热情
- 橙色：活力、创意、温暖

### 4. 渐变使用
克制使用渐变，优先选择单色扁平化设计，渐变仅用于视觉焦点区域。
      ''',
      author: '赵六',
      authorAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Zhao',
      publishTime: '2026-03-10',
      viewCount: 432,
      likeCount: 87,
      tags: ['UI设计', '配色', '用户体验'],
      category: '设计',
      coverImage: '',
    ),
  ];
}
