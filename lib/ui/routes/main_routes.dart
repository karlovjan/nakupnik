enum StaticPages { home, settings, household, goods, goodsGroups }

extension StaticPageRoute on StaticPages {
  String get routeName {
    const defaultRoute = '/';

    switch (this) {
      case StaticPages.home:
        return defaultRoute;
      case StaticPages.settings:
        return '/settings';
      case StaticPages.household:
        return '/household';
      case StaticPages.goods:
        return '/goods';
      case StaticPages.goodsGroups:
        return '/goodsGroups';
      default:
        return defaultRoute;
    }
  }
}
