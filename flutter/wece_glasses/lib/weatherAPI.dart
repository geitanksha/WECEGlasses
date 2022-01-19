import 'package:http/http.dart' as http;
Future<http.Response> fetchWeather() {
  return http.get(Uri.parse('https://api.weather.gov/gridpoints/TOP/40,88/forecast'));
}
//need temperature
//need detailedForecast
class Weather {
  final String temperature;
  final String detailedForecast;

  Weather(this.temperature, this.detailedForecast);

  Weather.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'],
        detailedForecast = json['detailedForecast'];

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'detailedForecast': detailedForecast,
  };
}
Future<Weather> fetchWeather() async {
  final response = await http
      .get(Uri.parse('https://api.weather.gov/gridpoints/TOP/40,88/forecast'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchAWeather();
  }
// ···
}

FutureBuilder<Weather>(
  future: futureWeather,
  builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data!.title);
      }   else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

  // By default, show a loading spinner.
      return const CircularProgressIndicator();
    },
)