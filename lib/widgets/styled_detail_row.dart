import 'package:flutter/material.dart';

class StyledDetailRow extends StatelessWidget {
  const StyledDetailRow(this.rowTitle, this.rowValue, {super.key});

  final String rowTitle;
  final String rowValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              rowTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(rowValue, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
