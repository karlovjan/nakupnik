enum StaticPages { home, settings, household }

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
      default:
        return defaultRoute;
    }
  }
}
