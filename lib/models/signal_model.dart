class Signal{
  late final int id;
  late final String image_signal;
  late final String text_description;
  late final String long;
  late final String lat;

Signal({
  required this.id,
  required this.image_signal,
  required this.text_description,
  required this.long,
  required this.lat,
});

factory Signal.fromjson(Map<String, dynamic> json){
    return switch(json){
      {
      "id" : int id,
      "image_signal" : String image_signal,
      "text_description" : String text_description,
      "long" :String long,
      "lat" :String lat,
      } =>
          Signal(
              id: id,
              image_signal: image_signal,
              text_description : text_description,
              long: long,
              lat: lat,
              ),
      _ => throw const FormatException("Failed to load Bd")
  };
  }

}
