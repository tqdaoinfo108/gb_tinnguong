import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/status_pill.dart';
import '../../clergy/views/clergy_detail_screen.dart';

class FacilityDetailScreen extends StatelessWidget {
  const FacilityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero image
          SliverToBoxAdapter(child: _HeroSection(top: top)),

          // Title block (overlapping hero by 20px)
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: _TitleBlock(),
            ),
          ),

          // Spec table
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _SpecTable(),
            ),
          ),

          // Clergy section
          SliverToBoxAdapter(child: _ClergySection(context: context)),

          // Album section
          SliverToBoxAdapter(child: _AlbumSection()),

          // Documents section
          SliverToBoxAdapter(child: _DocsSection()),

          // Repair history
          SliverToBoxAdapter(child: _RepairSection()),

          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }
}

// ─── Hero ──────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final double top;
  const _HeroSection({required this.top});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImgPlaceholder(variant: ImgVariant.warm, tag: 'chùa · cổng tam quan'),
          // Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.35, 0.60, 1.0],
                colors: [
                  Color(0x721E2D3D),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0x8C1E2D3D),
                ],
              ),
            ),
          ),
          // Nav buttons
          Positioned(
            left: 16, right: 16,
            top: top + 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavBtn(icon: Icons.chevron_left_rounded, size: 24,
                    onTap: () => Navigator.of(context).pop()),
                Row(children: [
                  _NavBtn(icon: Icons.ios_share_rounded, size: 20),
                  const SizedBox(width: 8),
                  _NavBtn(icon: Icons.bookmark_border_rounded, size: 20),
                ]),
              ],
            ),
          ),
          // Image dots
          Positioned(
            bottom: 36,
            left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: i == 0 ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == 0 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  const _NavBtn({required this.icon, this.size = 20, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: size, color: AppColors.ink),
      ),
    );
  }
}

// ─── Title Block ───────────────────────────────────────────────

class _TitleBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pills
          Row(children: [
            const StatusPill(kind: PillKind.emerald, label: 'Đã công nhận'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 6, height: 6,
                    decoration: const BoxDecoration(color: AppColors.buddhism, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text('Phật giáo', style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkMuted,
                )),
              ]),
            ),
          ]),
          const SizedBox(height: 8),
          Text('Chùa Pháp Hoa', style: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w700,
            color: AppColors.ink, letterSpacing: -0.02,
          )),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 15, color: AppColors.inkSoft),
            const SizedBox(width: 5),
            Text('870/53 Lê Quang Định, Khu phố 4', style: GoogleFonts.inter(
              fontSize: 15, color: AppColors.inkMuted,
            )),
          ]),
          const SizedBox(height: 16),
          // Action row
          Row(children: [
            Expanded(child: _PrimaryBtn(
              icon: Icons.directions_rounded,
              label: 'Chỉ đường',
            )),
            const SizedBox(width: 8),
            _GhostIconBtn(icon: Icons.phone_outlined),
            const SizedBox(width: 8),
            _GhostIconBtn(icon: Icons.ios_share_rounded),
          ]),
        ],
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PrimaryBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
          )),
        ],
      ),
    );
  }
}

class _GhostIconBtn extends StatelessWidget {
  final IconData icon;
  const _GhostIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Icon(icon, size: 18, color: AppColors.inkMuted),
    );
  }
}

// ─── Spec Table ────────────────────────────────────────────────

class _SpecTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: const [
        _InfoRow(label: 'Loại hình', value: 'Chùa Bắc Tông'),
        _InfoRow(label: 'Tên viết tắt', value: 'Pháp Hoa'),
        _InfoRow(label: 'Năm xây dựng', value: '1928'),
        _InfoRow(label: 'Diện tích', value: '2.450 m²'),
        _InfoRow(label: 'Khu phố', value: 'Khu phố 4, Phường 5'),
        _InfoRow(label: 'Toạ độ', value: '10.804°, 106.700°', mono: true),
        _InfoRow(label: 'Mã hoạt động', value: 'HD-PH-2024-018', mono: true, last: true),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool mono, last;
  const _InfoRow({required this.label, required this.value, this.mono = false, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkSoft)),
          const SizedBox(width: 16),
          Flexible(child: Text(value,
            textAlign: TextAlign.right,
            style: mono
                ? GoogleFonts.jetBrainsMono(fontSize: 13, color: AppColors.ink)
                : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
          )),
        ],
      ),
    );
  }
}

// ─── Clergy Section ────────────────────────────────────────────

class _ClergySection extends StatelessWidget {
  final BuildContext context;
  const _ClergySection({required this.context});

  @override
  Widget build(BuildContext _) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Chức sắc – Chức việc', more: '6 người'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              _PersonRow(
                name: 'Thượng toạ Thích Trí Quảng',
                role: 'Trụ trì',
                since: 'Từ 1996',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ClergyDetailScreen())),
              ),
              const SizedBox(height: 8),
              _PersonRow(name: 'Đại đức Thích Nhật Từ', role: 'Phó trụ trì', since: 'Từ 2008',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ClergyDetailScreen()))),
              const SizedBox(height: 8),
              _PersonRow(name: 'Sư cô Diệu Hạnh', role: 'Quản chúng', since: 'Từ 2015',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ClergyDetailScreen()))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  final String name, role, since;
  final VoidCallback? onTap;
  const _PersonRow({required this.name, required this.role, required this.since, this.onTap});

  String get _initials {
    final words = name.split(' ');
    return words.length >= 2
        ? '${words[words.length - 2][0]}${words.last[0]}'
        : name[0];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(color: AppColors.parchment2, shape: BoxShape.circle),
            child: Center(child: Text(_initials, style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkMuted,
            ))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink,
              )),
              Text('$role · $since', style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.inkSoft,
              )),
            ],
          )),
          const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.inkFaint),
        ]),
      ),
    );
  }
}

// ─── Album Section ─────────────────────────────────────────────

class _AlbumSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final albums = [
      ('Lễ Phật Đản 2025', '48 ảnh', ImgVariant.warm),
      ('Tịnh tu mùa hạ', '22 ảnh', ImgVariant.sage),
      ('Trùng tu chính điện', '34 ảnh', ImgVariant.clay),
      ('Vu Lan 2024', '61 ảnh', ImgVariant.light),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Thư viện ảnh', more: '4 album'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 4 / 3 + 0.55,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: albums.map((a) => _AlbumTile(name: a.$1, count: a.$2, variant: a.$3)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  final String name, count;
  final ImgVariant variant;
  const _AlbumTile({required this.name, required this.count, required this.variant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ImgPlaceholder(
            width: double.infinity, height: double.infinity,
            tag: name.toLowerCase(), variant: variant,
          ),
        )),
        const SizedBox(height: 8),
        Text(name, style: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink,
        )),
        Text(count, style: GoogleFonts.inter(fontSize: 12, color: AppColors.inkSoft)),
      ],
    );
  }
}

// ─── Documents Section ─────────────────────────────────────────

class _DocsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Hồ sơ – Tài liệu', more: '12 mục'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.hairline),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(children: [
                _DocRow(icon: 'PDF', name: 'Quyết định công nhận cơ sở', meta: 'QĐ-185/PG · 2.4 MB · 14/03/2024'),
                Divider(color: AppColors.hairline, height: 1, thickness: 1),
                _DocRow(icon: 'DOC', name: 'Lý lịch cơ sở tôn giáo', meta: 'docx · 1.1 MB · 02/01/2025'),
                Divider(color: AppColors.hairline, height: 1, thickness: 1),
                _DocRow(icon: 'XLS', name: 'Danh sách tín đồ năm 2025', meta: 'xlsx · 480 KB · 12/03/2025'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  final String icon, name, meta;
  const _DocRow({required this.icon, required this.name, required this.meta});

  static const _colors = {
    'PDF': (Color(0xFF7A2A22), Color(0xFFF7E3E1)),
    'DOC': (Color(0xFF2A5A85), Color(0xFFE4ECF5)),
    'XLS': (Color(0xFF1B6A43), Color(0xFFE6F4EC)),
  };

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _colors[icon] ?? (const Color(0xFF4B5B6E), const Color(0xFFECE9E0));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(icon, style: GoogleFonts.inter(
            fontSize: 10.5, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.02,
          ))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
            const SizedBox(height: 2),
            Text(meta, style: GoogleFonts.inter(fontSize: 12, color: AppColors.inkSoft)),
          ],
        )),
        const Icon(Icons.download_outlined, size: 18, color: AppColors.inkSoft),
      ]),
    );
  }
}

// ─── Repair History ────────────────────────────────────────────

class _RepairSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Lịch sử sửa chữa', more: '8 lần'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: const [
              _RepairCard(
                date: '03/05/2026',
                desc: 'Trùng tu mái chính điện, thay ngói lưu ly',
                cost: '142.000.000 ₫',
                kind: PillKind.blue,
                statusLabel: 'Đang thực hiện',
              ),
              SizedBox(height: 10),
              _RepairCard(
                date: '14/11/2025',
                desc: 'Sơn lại tường rào và cổng tam quan',
                cost: '38.500.000 ₫',
                kind: PillKind.emerald,
                statusLabel: 'Hoàn thành',
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _RepairCard extends StatelessWidget {
  final String date, desc, cost, statusLabel;
  final PillKind kind;
  const _RepairCard({
    required this.date, required this.desc,
    required this.cost, required this.kind, required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkMuted,
              )),
              StatusPill(kind: kind, label: statusLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.inter(fontSize: 15, color: AppColors.ink)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chi phí', style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkSoft)),
              Text(cost, style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Section Header ─────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? more;
  const _SectionHeader({required this.title, this.more});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(title, style: GoogleFonts.inter(
            fontSize: 19, fontWeight: FontWeight.w600,
            color: AppColors.ink, letterSpacing: -0.015,
          )),
          if (more != null)
            Text(more!, style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary,
            )),
        ],
      ),
    );
  }
}
