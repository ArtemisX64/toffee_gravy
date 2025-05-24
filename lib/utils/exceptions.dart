class BitterToffee implements Exception {
  final String message;
  BitterToffee(this.message);

  @override
  String toString() => '[ToffeeException]: $message';
}

class HttpNotFoundException extends BitterToffee {
  HttpNotFoundException({String? message}): super('Http Not Found(${message ?? ''})');
}

class InvalidUrl extends BitterToffee {
  InvalidUrl({String? message}): super('Invalid Url(${message ?? ''})');
}

class StreamClosed extends BitterToffee {
  StreamClosed({String? message}): super('Stream Closed(${message ?? ''})');
}

class NoValidCodecFound extends BitterToffee {
  NoValidCodecFound({String? message}): super('No Valid Codec Found(${message ?? ''})');
}

class RequestParameterNotFound extends BitterToffee{
  RequestParameterNotFound({String? message}): super('No Request Parameter Found(${message ?? ''})');
}