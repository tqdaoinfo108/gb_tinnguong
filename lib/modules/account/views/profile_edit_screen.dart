import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/account_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _ctrl = Get.find<AccountController>();

  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _relationship;

  int?      _genderID;
  DateTime? _birthday;

  @override
  void initState() {
    super.initState();
    final u = _ctrl.user.value;
    _fullName     = TextEditingController(text: u?.fullName     ?? '');
    _phone        = TextEditingController(text: u?.phone        ?? '');
    _email        = TextEditingController(text: u?.email        ?? '');
    _address      = TextEditingController(text: u?.address      ?? '');
    _relationship = TextEditingController(text: u?.relationship ?? '');
    _genderID     = u?.genderID;
    _birthday     = u?.birthday;
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _relationship.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(1990),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.canvas,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _save() async {
    final current = _ctrl.user.value;
    if (current == null) return;

    final updated = current.copyWith(
      fullName:     _fullName.text.trim(),
      phone:        _phone.text.trim(),
      email:        _email.text.trim(),
      address:      _address.text.trim(),
      relationship: _relationship.text.trim(),
      genderID:     _genderID,
      birthday:     _birthday,
    );

    final ok = await _ctrl.saveProfile(updated);
    if (!mounted) return;

    if (ok) {
      // Pop screen trước, sau đó mới show snack —
      // snackbar sẽ render trên AccountScreen thay vì overlay bị pop
      Get.back();
      _ctrl.showSaveSuccess();
    }
    // error: snack đã được show bên trong saveProfile(), không cần làm thêm
  }

  String get _birthdayText {
    if (_birthday == null) return '';
    return '${_birthday!.day.toString().padLeft(2, '0')}/'
        '${_birthday!.month.toString().padLeft(2, '0')}/'
        '${_birthday!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Column(
        children: [

          // ── Top bar ─────────────────────────────────────────────
          _TopBar(top: top),

          // ── Scrollable body ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 24, 20, bottom + 32),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Avatar
                  _AvatarSection(ctrl: _ctrl),

                  const SizedBox(height: 28),

                  // Read-only system info
                  _ReadOnlyCard(ctrl: _ctrl),

                  const SizedBox(height: 24),

                  // ── Thông tin cá nhân ──────────────────────────
                  _GroupLabel('Thông tin cá nhân'),
                  const SizedBox(height: 8),
                  _FieldGroup(children: [
                    _EditRow(
                      label: 'Họ và tên',
                      child: _TextField(
                        controller: _fullName,
                        hint: 'Chưa cập nhật',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    _GroupDivider(),
                    _EditRow(
                      label: 'Điện thoại',
                      child: _TextField(
                        controller: _phone,
                        hint: 'Chưa cập nhật',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    _GroupDivider(),
                    _EditRow(
                      label: 'Email',
                      child: _TextField(
                        controller: _email,
                        hint: 'Chưa cập nhật',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    _GroupDivider(),
                    _EditRow(
                      label: 'Địa chỉ',
                      child: _TextField(
                        controller: _address,
                        hint: 'Chưa cập nhật',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Thông tin khác ─────────────────────────────
                  _GroupLabel('Thông tin khác'),
                  const SizedBox(height: 8),
                  _FieldGroup(children: [
                    // Giới tính
                    _EditRow(
                      label: 'Giới tính',
                      child: _GenderPicker(
                        value: _genderID,
                        onChanged: (v) => setState(() => _genderID = v),
                      ),
                    ),
                    _GroupDivider(),
                    // Ngày sinh — tap toàn row
                    InkWell(
                      onTap: _pickBirthday,
                      borderRadius: BorderRadius.circular(14),
                      child: _EditRow(
                        label: 'Ngày sinh',
                        interactive: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _birthdayText.isNotEmpty
                                    ? _birthdayText
                                    : 'Chưa cập nhật',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _birthdayText.isNotEmpty
                                      ? AppColors.ink
                                      : AppColors.inkFaint,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.calendar_today_outlined,
                                size: 15, color: AppColors.inkFaint),
                          ],
                        ),
                      ),
                    ),
                    _GroupDivider(),
                    _EditRow(
                      label: 'Hôn nhân',
                      child: _TextField(
                        controller: _relationship,
                        hint: 'Chưa cập nhật',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Save
                  Obx(() => _SaveButton(
                    loading: _ctrl.isSaving.value,
                    onTap: _ctrl.isSaving.value ? null : _save,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final double top;
  const _TopBar({required this.top});

  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.canvas,
    padding: EdgeInsets.fromLTRB(4, top + 6, 16, 6),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          onPressed: Get.back,
        ),
        Expanded(
          child: Text('Thông tin cá nhân', style: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink,
          )),
        ),
      ],
    ),
  );
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final AccountController ctrl;
  const _AvatarSection({required this.ctrl});

  @override
  Widget build(BuildContext context) => Center(
    child: Obx(() => GestureDetector(
      onTap: ctrl.isSaving.value ? null : ctrl.pickAndUploadAvatar,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B6FA0), Color(0xFF2F5B85)],
              ),
              border: Border.all(color: AppColors.gold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.25),
                  blurRadius: 14,
                ),
              ],
            ),
            child: ctrl.isSaving.value
                ? const Center(
                    child: SizedBox(
                      width: 28, height: 28,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    ))
                : Center(
                    child: Text(ctrl.initials, style: GoogleFonts.inter(
                      fontSize: 30, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
                  ),
          ),
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt_rounded, size: 13, color: Colors.white),
          ),
        ],
      ),
    )),
  );
}

// ── Read-only card ────────────────────────────────────────────────────────────

class _ReadOnlyCard extends StatelessWidget {
  final AccountController ctrl;
  const _ReadOnlyCard({required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() {
    final rows = <MapEntry<String, String>>[];
    if (ctrl.staffCode.isNotEmpty) {
      rows.add(MapEntry('Mã cán bộ', ctrl.staffCode));
    }
    if (ctrl.displayRole.isNotEmpty) {
      rows.add(MapEntry('Chức vụ', ctrl.displayRole));
    }
    if (ctrl.displayUnit.isNotEmpty) {
      rows.add(MapEntry('Đơn vị', ctrl.displayUnit));
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupLabel('Thông tin hệ thống'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.slateBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: rows.asMap().entries.map((e) {
              final isLast = e.key == rows.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    child: Row(
                      children: [
                        Text(e.value.key, style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.inkSoft,
                        )),
                        const Spacer(),
                        Text(e.value.value, style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: AppColors.inkMuted,
                        )),
                        const SizedBox(width: 4),
                        const Icon(Icons.lock_outline_rounded,
                            size: 13, color: AppColors.inkFaint),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Divider(height: 1, color: AppColors.hairline),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  });
}

// ── Group label ───────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AppColors.inkMuted,
  ));
}

// ── Field group card ──────────────────────────────────────────────────────────

class _FieldGroup extends StatelessWidget {
  final List<Widget> children;
  const _FieldGroup({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [AppColors.lightShadow],
    ),
    child: Column(children: children),
  );
}

// ── Divider inside group ──────────────────────────────────────────────────────

class _GroupDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(left: 16),
    child: Divider(height: 1, color: AppColors.hairline),
  );
}

// ── Edit row: label (left) | content (right) ─────────────────────────────────

class _EditRow extends StatelessWidget {
  final String label;
  final Widget child;
  final bool interactive;
  const _EditRow({required this.label, required this.child, this.interactive = true});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: GoogleFonts.inter(
            fontSize: 14, color: AppColors.inkSoft,
          )),
        ),
        Expanded(child: child),
      ],
    ),
  );
}

// ── Text field (right-aligned, no border) ─────────────────────────────────────

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;

  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.end,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    textAlign: textAlign,
    style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.inkFaint),
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 13),
    ),
  );
}

// ── Gender picker ─────────────────────────────────────────────────────────────

class _GenderPicker extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  const _GenderPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _GChip(label: 'Nam',  active: value == 1, onTap: () => onChanged(1)),
        const SizedBox(width: 6),
        _GChip(label: 'Nữ',   active: value == 2, onTap: () => onChanged(2)),
        const SizedBox(width: 6),
        _GChip(label: 'Khác', active: value != 1 && value != 2, onTap: () => onChanged(0)),
      ],
    ),
  );
}

class _GChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _GChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.hairlineStrong,
        ),
      ),
      child: Text(label, style: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w500,
        color: active ? Colors.white : AppColors.inkMuted,
      )),
    ),
  );
}

// ── Save button ───────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;
  const _SaveButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: onTap != null ? AppColors.tileDark : AppColors.hairlineStrong,
        borderRadius: BorderRadius.circular(27),
      ),
      child: loading
          ? const Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ))
          : Text(
              'Lưu thay đổi',
              style: GoogleFonts.inter(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
    ),
  );
}
