class UriBuilder {
  String _uri;
  Map<String, String> _mQueries = {};
  List<String> _mPaths = [];

  UriBuilder(this._uri);
  UriBuilder addPath(String path) {
    _mPaths.add(path);
    return this;
  }

  UriBuilder addQuery(String key, String value) {
    _mQueries[key] = value;
    return this;
  }

  String build() {
    for (final path in _mPaths) {
      _uri += '/';
      _uri += path;
    }
    if (_mQueries.length != 0) {
      _uri += '?';
    }
    for (final query in _mQueries.entries) {
      if (_uri[_uri.length - 1] != '&' && _uri[_uri.length - 1] != '?') {
        _uri += '&';
      }
      _uri += query.key;
      _uri += '=';
      _uri += query.value;
    }
    return Uri.encodeFull(_uri);
  }
}
