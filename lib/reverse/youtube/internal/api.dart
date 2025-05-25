const _iosClientVersion = '20.10.4';
const _androidVRClientVersion = '1.56.21';
const _androidClientVersion = '19.09.37';

class YoutubeApi {
  final String _clientName;
  final String _clientVersion;
  final String? _deviceMake;
  final String? _deviceModel;
  final String? _hl;
  final String? _gl;
  final String? _platform;
  final String? _osName;
  final String? _osVersion;
  final String? _timeZone;
  final String? _userAgent;
  final String? _androidSdkVersion;
  final int? _utcOffsetMinutes;

  const YoutubeApi({
    required String clientName,
    required String clientVersion,
    String? deviceMake,
    String? deviceModel,
    String? hl,
    String? platform,
    String? osName,
    String? osVersion,
    String? timeZone,
    String? userAgent,
    String? androidSdkVersion,
    String? gl,
    int? utcOffsetMinutes,
  }) : _clientName = clientName,
       _clientVersion = clientVersion,
       _deviceMake = deviceMake,
       _deviceModel = deviceModel,
       _hl = hl,
       _gl = gl,
       _platform = platform,
       _osName = osName,
       _osVersion = osVersion,
       _timeZone = timeZone,
       _userAgent = userAgent,
       _utcOffsetMinutes = utcOffsetMinutes,
       _androidSdkVersion = androidSdkVersion;

  //Creates Header File
  Map<String, String> generateHeader() {
    return {
      if (userAgent != null) 'User-Agent': userAgent!,
      'X-Youtube-Client-Name': clientName,
      'X-Youtube-Client-Version': clientVersion,
      'Origin': 'https://www.youtube.com',
      'Sec-Fetch-Mode': 'navigate',
      'Content-Type': 'application/json',
    };
  }


  //All the Getters
  String get clientName => _clientName;
  String get clientVersion => _clientVersion;
  String? get deviceMake  => _deviceMake;
  String? get deviceModel => _deviceModel;
  String? get hl => _hl;
  String? get platform => _platform;
  String? get osName => _osName;
  String? get osVersion => _osVersion;
  String? get timeZone => _timeZone;
  String? get userAgent => _userAgent;
  String? get gl => _gl;
  String? get androidSdkVersion => _androidSdkVersion;
  int? get utcOffsetMinutes => _utcOffsetMinutes;
}

class IosApi extends YoutubeApi {
  IosApi({String? hl, String? gl})
    : super(
        clientName: 'IOS',
        clientVersion: _iosClientVersion,
        deviceMake: 'Apple',
        deviceModel: 'iPhone16,2',
        platform: 'MOBILE',
        osName: 'IOS',
        osVersion: '18.1.0.22B83',
        timeZone: 'UTC',
        hl: hl ?? 'en',
        gl: gl ?? 'US',
        userAgent:
            'com.google.ios.youtube/$_iosClientVersion (iPhone16,2; U; CPU iOS 18_1_0 like Mac OS X; US)',
        utcOffsetMinutes: 0,
      );
}


//Made after Android app
class AndroidApi extends YoutubeApi {
    AndroidApi({String? hl, String? gl})
    : super(
        clientName: 'ANDROID',
        clientVersion: _androidClientVersion,
        androidSdkVersion: '31',
        timeZone: 'UTC',
        hl: hl ?? 'en',
        gl: gl ?? 'US',
        userAgent:
            'com.google.android.youtube/$_androidClientVersion (Linux; U; Android 11) gzip',
        utcOffsetMinutes: 0,
      );
}

// Thanks youtube explode dart for explaining about AndroidVR
class AndroidVRApi extends YoutubeApi {
  AndroidVRApi({String? hl, String? gl})
    : super(
        clientName: 'ANDROID_VR',
        clientVersion: _androidVRClientVersion,
        deviceModel: 'Quest 3',
        osName: 'Android',
        osVersion: '12',
        androidSdkVersion: '32',
        timeZone: 'UTC',
        hl: hl ?? 'en',
        userAgent:
            'com.google.android.youtube.tv.vr/$_androidVRClientVersion (Linux; U; Android 12; Quest 3 Build/VRQ1.230928.001) gzip',
        utcOffsetMinutes: 0,
      );
}

class CustomApi extends YoutubeApi {
  CustomApi({
    required super.clientName,
    required super.clientVersion,
    super.deviceMake,
    super.deviceModel,
    super.osName,
    super.osVersion,
    super.hl,
    super.platform,
    super.timeZone,
    super.userAgent,
    super.utcOffsetMinutes,
  });
}
