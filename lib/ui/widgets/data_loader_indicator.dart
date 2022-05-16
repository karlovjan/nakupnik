import 'package:flutter/material.dart';

abstract class DataLoaderIndicator extends StatelessWidget {
  const DataLoaderIndicator(
    this._title, {
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".

  final Widget _title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          _title,
        ],
      ),
    );
  }
}

class DataLoaderTitle extends StatelessWidget {
  const DataLoaderTitle(
    this._title, {
    Key? key,
  }) : super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: Theme.of(context).primaryTextTheme.headline6,
    );
  }
}

class CommonDataLoadingIndicator extends DataLoaderIndicator {
  static const loaderText = 'Data loading ...';

  const CommonDataLoadingIndicator({
    Key? key,
  }) : super(const DataLoaderTitle(loaderText), key: key);
}

class GoodsLoaderIndicator extends DataLoaderIndicator {
  static const loaderText = 'Goods loading ...';

  const GoodsLoaderIndicator({
    Key? key,
  }) : super(const DataLoaderTitle(loaderText), key: key);
}

class HouseholdListLoaderIndicator extends DataLoaderIndicator {
  static const loaderText = 'Households loading ...';

  const HouseholdListLoaderIndicator({
    Key? key,
  }) : super(const DataLoaderTitle(loaderText), key: key);
}
