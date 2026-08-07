import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import '../../widgets/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CenterTitleHeader(
              title: '关于', onBack: () => Navigator.of(context).maybePop()),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: p.accent,
                borderRadius: BorderRadius.circular(AppRadius.aboutLogo),
              ),
              alignment: Alignment.center,
              child: Text(
                '拾',
                style: GoogleFonts.notoSerif(
                  fontSize: 32,
                  color: p.fabText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '拾光',
              style: GoogleFonts.notoSerif(
                fontSize: 22,
                color: p.text,
                letterSpacing: 0.15 * 22,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'v1.0.0 · for the moments',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: p.text3,
                letterSpacing: 0.15 * 12,
              ),
            ),
          ),
          const SizedBox(height: 48),
          const _Section(
            title: '设计理念',
            body:
                '把文字当作烛火。写下它，让它在时间里安静燃烧。\n在这里，没有点赞、没有算法，只有你和那些还没走远的瞬间。',
          ),
          const _Section(
            title: '致谢',
            body:
                '感谢 Noto Serif / Noto Sans 提供中文字体支持；感谢 Flutter 让这一切成为可能；感谢每一个愿意慢下来写字的你。',
          ),
          const _Section(
            title: '开源',
            body: '本应用以本地优先为原则，数据完全保存在你的设备上。',
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () => launchUrl(Uri.parse('https://flutter.dev')),
              child: Text(
                'Built with Flutter',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: p.accent,
                  letterSpacing: 0.15 * 11,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '© 2026 拾光 · 烛烬笔记',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: p.text3,
                letterSpacing: 0.1 * 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: p.text3,
              letterSpacing: 0.2 * 11,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: p.text2,
              height: 1.85,
              letterSpacing: 0.05 * 13,
            ),
          ),
        ],
      ),
    );
  }
}