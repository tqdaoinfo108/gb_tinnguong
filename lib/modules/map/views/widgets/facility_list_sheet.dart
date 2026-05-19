// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../core/values/app_colors.dart';
// import '../../../../data/models/office_model.dart';
// import '../../controllers/map_controller.dart';

// /// Bottom sheet — danh sách cơ sở (không có search; search ở top bar).
// class FacilityListSheet extends GetView<GisMapController> {
//   final ScrollController? scrollController;
//   const FacilityListSheet({super.key, this.scrollController});

//   @override
//   Widget build(BuildContext context) {
//     final bottom = MediaQuery.of(context).padding.bottom;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.10),
//             blurRadius: 24,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Column(children: [
//         // ── Handle ────────────────────────────────────────────────
//         const SizedBox(height: 10),
//         Container(
//           width: 40, height: 4,
//           decoration: BoxDecoration(
//             color: AppColors.hairlineStrong,
//             borderRadius: BorderRadius.circular(999),
//           ),
//         ),

//         // ── Header ────────────────────────────────────────────────
//         const _SheetHeader(),

//         // ── Divider ───────────────────────────────────────────────
//         Divider(height: 1, thickness: 1, color: AppColors.hairline),

//         // ── List ──────────────────────────────────────────────────
//         Expanded(
//           child: Obx(() {
//             final list = controller.filteredOffices;

//             if (list.isEmpty) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(32),
//                   child: Column(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.location_off_rounded,
//                         size: 40, color: AppColors.inkFaint),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Không có cơ sở nào',
//                       style: GoogleFonts.inter(
//                           fontSize: 15, color: AppColors.inkSoft),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Thử thay đổi bộ lọc lớp bản đồ',
//                       style: GoogleFonts.inter(
//                           fontSize: 13, color: AppColors.inkFaint),
//                     ),
//                   ]),
//                 ),
//               );
//             }

//             return ListView.separated(
//               controller: scrollController,
//               padding: EdgeInsets.only(
//                 top: 4,
//                 bottom: bottom + 20,
//               ),
//               itemCount: list.length,
//               separatorBuilder: (_, __) => Divider(
//                 height: 1,
//                 color: AppColors.hairline,
//                 indent: 72,
//               ),
//               itemBuilder: (_, i) => _FacilityRow(office: list[i]),
//             );
//           }),
//         ),
//       ]),
//     );
//   }
// }

// // ── Header ────────────────────────────────────────────────────────────────────

// class _SheetHeader extends GetView<GisMapController> {
//   const _SheetHeader();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final count = controller.filteredOffices.length;
//       final city  = controller.cityName.value.isNotEmpty
//           ? controller.cityName.value
//           : 'Khu vực';

//       // Active filter count
//       final hiddenReligions = controller.religions.length -
//           controller.visibleReligionIDs.length;
//       final hasFilter = hiddenReligions > 0;

//       return Padding(
//         padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
//         child: Row(children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(children: [
//                   Text(
//                     '$count cơ sở',
//                     style: GoogleFonts.inter(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.ink,
//                       letterSpacing: -0.015,
//                     ),
//                   ),
//                   if (hasFilter) ...[
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 7, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: AppColors.amberBg,
//                         borderRadius: BorderRadius.circular(999),
//                       ),
//                       child: Text(
//                         '$hiddenReligions ẩn',
//                         style: GoogleFonts.inter(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.amberDot,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ]),
//                 Text(
//                   '$city · trong ranh giới',
//                   style: GoogleFonts.inter(
//                       fontSize: 12, color: AppColors.inkSoft),
//                 ),
//               ],
//             ),
//           ),

//           // Filter button
//           GestureDetector(
//             onTap: controller.toggleFilterPanel,
//             child: Obx(() {
//               final active = controller.showFilterPanel.value;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 150),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: active ? AppColors.primary : AppColors.parchment,
//                   borderRadius: BorderRadius.circular(999),
//                   border: Border.all(
//                     color: active ? AppColors.primary : AppColors.hairline,
//                   ),
//                 ),
//                 child: Row(children: [
//                   Icon(Icons.tune_rounded,
//                       size: 14,
//                       color: active ? Colors.white : AppColors.inkMuted),
//                   const SizedBox(width: 5),
//                   Text(
//                     'Bộ lọc',
//                     style: GoogleFonts.inter(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: active ? Colors.white : AppColors.inkMuted,
//                     ),
//                   ),
//                   if (hasFilter) ...[
//                     const SizedBox(width: 5),
//                     Container(
//                       width: 16, height: 16,
//                       decoration: BoxDecoration(
//                         color: active
//                             ? Colors.white.withValues(alpha: 0.3)
//                             : AppColors.amberDot,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '$hiddenReligions',
//                           style: GoogleFonts.inter(
//                             fontSize: 9,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ]),
//               );
//             }),
//           ),
//         ]),
//       );
//     });
//   }
// }

// // ── Facility row ──────────────────────────────────────────────────────────────

// class _FacilityRow extends StatelessWidget {
//   final OfficeModel office;
//   const _FacilityRow({required this.office});

//   @override
//   Widget build(BuildContext context) {
//     final ctrl     = Get.find<GisMapController>();
//     final colorVal = GisMapController.religionColors[office.religionID] ?? 0xFF8A6E4A;
//     final color    = Color(colorVal);
//     final abbrev   = GisMapController.religionAbbrev[office.religionID] ?? '?';

//     return InkWell(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         ctrl.onSearchResultTap(office);
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Row(children: [
//           // Marker avatar
//           Container(
//             width: 44, height: 44,
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.10),
//               borderRadius: BorderRadius.circular(13),
//             ),
//             child: Center(
//               child: Container(
//                 width: 28, height: 28,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: color.withValues(alpha: 0.30),
//                       blurRadius: 6,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     abbrev,
//                     style: GoogleFonts.inter(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   office.officeName,
//                   style: GoogleFonts.inter(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.ink,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 if (office.officeAddress != null)
//                   Text(
//                     office.officeAddress!,
//                     style: GoogleFonts.inter(
//                         fontSize: 12, color: AppColors.inkSoft),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),

//           if (office.religionName != null)
//             Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//               decoration: BoxDecoration(
//                 color: color.withValues(alpha: 0.10),
//                 borderRadius: BorderRadius.circular(999),
//               ),
//               child: Text(
//                 office.religionName!,
//                 style: GoogleFonts.inter(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: color,
//                 ),
//               ),
//             ),
//         ]),
//       ),
//     );
//   }
// }
