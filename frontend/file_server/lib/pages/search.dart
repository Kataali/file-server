import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/file.provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<FileData>(context, listen: false);
    return const Scaffold();
  }
}
