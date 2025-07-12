import 'package:flutter/material.dart';
import 'package:kidys_distributor/models/bannerModel.dart';

class BannerOverlay extends StatefulWidget {
  final List<BannerModel> bannerList;
  final VoidCallback onComplete;

  const BannerOverlay({
    Key? key,
    required this.bannerList,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<BannerOverlay> createState() => _BannerOverlayState();
}

class _BannerOverlayState extends State<BannerOverlay> {
  int currentIndex = 0;

  void _handleClose() {
    if (currentIndex < widget.bannerList.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      widget.onComplete(); // Notify Categories widget
      Navigator.of(context).pop(); // Close overlay
    }
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.bannerList[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: _handleClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
