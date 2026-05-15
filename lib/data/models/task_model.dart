import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SubTaskStatus { chuaLam, dangLam, hoanThanh, treLhan }
enum SubTaskPriority { cao, trungBinh, thap }

extension SubTaskStatusExt on SubTaskStatus {
  String get label {
    switch (this) {
      case SubTaskStatus.chuaLam: return 'Chưa làm';
      case SubTaskStatus.dangLam: return 'Đang làm';
      case SubTaskStatus.hoanThanh: return 'Hoàn thành';
      case SubTaskStatus.treLhan: return 'Trễ hạn';
    }
  }
}

extension SubTaskPriorityExt on SubTaskPriority {
  String get label {
    switch (this) {
      case SubTaskPriority.cao: return 'Cao';
      case SubTaskPriority.trungBinh: return 'Trung bình';
      case SubTaskPriority.thap: return 'Thấp';
    }
  }
}

class SubTask {
  final String id;
  final String title;
  final String assignee;
  final DateTime dueDate;
  SubTaskStatus status;
  final SubTaskPriority priority;
  final bool isLate;
  final int commentCount;
  final int attachmentCount;

  SubTask({
    required this.id,
    required this.title,
    required this.assignee,
    required this.dueDate,
    required this.status,
    required this.priority,
    this.isLate = false,
    this.commentCount = 0,
    this.attachmentCount = 0,
  });

  bool get isDone => status == SubTaskStatus.hoanThanh;
  String get formattedDate => DateFormat('dd/MM/yyyy').format(dueDate);
}

class Task {
  final String id;
  final String title;
  final String department;
  final String owner;
  final double progress;
  final DateTime date;
  final String statusLabel;
  final List<String> avatarUrls;
  final List<String> assignees; // Danh sách tên người tham gia
  final List<SubTask> subTasks;
  final String? ownerAvatar;
  final int? kpiCurrent;
  final int? kpiTotal;
  final String? kpiUnit;

  Task({
    required this.id,
    required this.title,
    required this.department,
    required this.owner,
    required this.progress,
    required this.date,
    required this.statusLabel,
    required this.avatarUrls,
    this.assignees = const [],
    this.subTasks = const [],
    this.ownerAvatar,
    this.kpiCurrent,
    this.kpiTotal,
    this.kpiUnit,
  });

  String get formattedDate => DateFormat('dd/MM/yyyy').format(date);

  int get doneSubTasks => subTasks.where((s) => s.isDone).length;
  int get lateSubTasks => subTasks.where((s) => s.isLate || s.status == SubTaskStatus.treLhan).length;
  
  // Logic đồng bộ: Ưu tiên tính theo subtasks, nếu không có thì lấy progress cứng
  double get displayProgress => subTasks.isNotEmpty 
      ? (doneSubTasks / subTasks.length) 
      : progress;

  Color get progressColor {
    final status = statusLabel.toLowerCase();
    if (status.contains('chậm tiến độ')) return const Color(0xFFE74C3C); // Đỏ
    if (status.contains('có rủi ro')) return const Color(0xFFF2994A);   // Cam
    
    double p = displayProgress;
    if (p >= 1.0) return const Color(0xFF20C46A); // Xanh lá
    if (p >= 0.8) return const Color(0xFF2F6CE1); // Xanh dương
    return const Color(0xFFF2C94C); // Vàng
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
