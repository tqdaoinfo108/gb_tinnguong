import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/values/app_colors.dart';

class SecureNetworkImage extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SecureNetworkImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<SecureNetworkImage> createState() => _SecureNetworkImageState();
}

class _SecureNetworkImageState extends State<SecureNetworkImage> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    // Nếu là URL http/https trực tiếp
    if (widget.imagePath.startsWith('http')) {
      setState(() {
        _isLoading = false;
        // Tạm thời fallback nếu bị lỗi cho URL ngoài
        // (Trong thực tế cần bọc bằng plugin CachedNetworkImage cho url ngoài)
      });
      return; // Không xử lý manual cho url ngoài
    }

    try {
      final dio = DioClient().dio;
      // Dùng responseType: bytes để lấy dữ liệu ảnh thô
      final response = await dio.get<List<int>>(
        '/api/file/get-image',
        queryParameters: {'fileName': widget.imagePath},
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (mounted) {
          setState(() {
            _imageBytes = Uint8List.fromList(response.data!);
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePath.startsWith('http')) {
      return Image.network(
        widget.imagePath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    }

    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      );
    }

    if (_hasError || _imageBytes == null) {
      return _errorWidget();
    }

    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) => _errorWidget(),
    );
  }

  Widget _errorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }
}
