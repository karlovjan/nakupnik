enum StaticPages { home, settings }

extension StaticPageRoute on StaticPages {
  String get routeName {
    const defaultRoute = '/';

    switch (this) {
      case StaticPages.home:
        return defaultRoute;
      case StaticPages.settings:
        return '/settings';
      default:
        return defaultRoute;
    }
  }
}
