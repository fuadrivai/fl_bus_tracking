import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DriverShimmer extends StatelessWidget {
  final double height;
  const DriverShimmer({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 253, 249, 249),
              // gradient: Common.shimmerGradient,
            ),
            width: width * 30 / 100,
            height: height,
          ),
        ),
        SizedBox(
          width: width * 65 / 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 253, 249, 249),
                    // gradient: Common.shimmerGradient,
                  ),
                  height: 30,
                  width: width * 35 / 100,
                ),
              ),
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 253, 249, 249),
                    // gradient: Common.shimmerGradient,
                  ),
                  height: 20,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
