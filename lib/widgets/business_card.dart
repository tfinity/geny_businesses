import 'package:flutter/material.dart';

class BusinessCard<T> extends StatelessWidget {
  final T model;
  final Widget Function(BuildContext, T) builder;
  final VoidCallback? onTap;

  const BusinessCard({
    required this.model,
    required this.builder,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: builder(context, model),
        ),
      ),
    );
  }
}
