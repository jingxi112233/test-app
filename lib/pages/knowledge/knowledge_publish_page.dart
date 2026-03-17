import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';

class KnowledgePublishPage extends StatefulWidget {
  const KnowledgePublishPage({super.key});

  @override
  State<KnowledgePublishPage> createState() => _KnowledgePublishPageState();
}

class _KnowledgePublishPageState extends State<KnowledgePublishPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  String _selectedCategory = '技术';
  List<String> _tags = [];
  bool _submitting = false;

  static const _categories = ['技术', '产品', '设计', '运营', '其他'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _summaryCtrl.dispose();
    _contentCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagCtrl.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag) && _tags.length < 5) {
      setState(() => _tags.add(tag));
      _tagCtrl.clear();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final success = await ApiService.publishKnowledge(
      title: _titleCtrl.text.trim(),
      summary: _summaryCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      category: _selectedCategory,
      tags: _tags,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    color: AppTheme.successColor, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('发布成功！',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('你的知识已分享给社区',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/knowledge');
              },
              child: const Text('查看知识库'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('发布失败，请稍后重试'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布知识'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child:
                        CircularProgressIndicator(strokeWidth: 2))
                : const Text(
                    '发布',
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分类选择
              const Text('分类',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((cat) {
                  final selected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = cat),
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.textSecondary,
                    ),
                    side: BorderSide(
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.dividerColor,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // 标题
              TextFormField(
                controller: _titleCtrl,
                maxLength: 50,
                validator: (v) => v!.isEmpty ? '请输入标题' : null,
                decoration: const InputDecoration(
                  labelText: '标题 *',
                  hintText: '一个好标题能吸引更多人阅读',
                ),
              ),
              const SizedBox(height: 12),
              // 摘要
              TextFormField(
                controller: _summaryCtrl,
                maxLines: 2,
                maxLength: 100,
                validator: (v) => v!.isEmpty ? '请输入摘要' : null,
                decoration: const InputDecoration(
                  labelText: '摘要 *',
                  hintText: '用一两句话概括文章核心内容',
                ),
              ),
              const SizedBox(height: 12),
              // 正文
              TextFormField(
                controller: _contentCtrl,
                maxLines: 12,
                validator: (v) =>
                    v!.length < 50 ? '正文至少 50 字' : null,
                decoration: const InputDecoration(
                  labelText: '正文 *',
                  hintText: '支持 Markdown 语法，用 ## 标题、**加粗**、- 列表等格式化内容',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              // 标签
              const Text('标签（最多 5 个）',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            onDeleted: () =>
                                setState(() => _tags.remove(tag)),
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.08),
                            labelStyle: const TextStyle(
                                color: AppTheme.primaryColor, fontSize: 13),
                            side: BorderSide.none,
                            deleteIconColor: AppTheme.primaryColor,
                          ))
                      .toList(),
                ),
              if (_tags.length < 5) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagCtrl,
                        onSubmitted: (_) => _addTag(),
                        decoration: const InputDecoration(
                          hintText: '输入标签回车添加',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addTag,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: const Text('添加'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white))
                      : const Text('发布到知识库'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
