// ignore_for_file: prefer_const_constructors

import 'package:google_maps_flutter/google_maps_flutter.dart';

Map<String, LatLng> turkishCitiesCoordinates = {
  "Adana": LatLng(37.0, 35.3213),
  "Adıyaman": LatLng(37.7648, 38.2765),
  "Afyonkarahisar": LatLng(38.756, 30.543),
  "Ağrı": LatLng(39.7217, 43.0567),
  "Aksaray": LatLng(38.3687, 34.037),
  "Amasya": LatLng(40.65, 35.8333),
  "Ankara": LatLng(39.9334, 32.8597),
  "Antalya": LatLng(36.8969, 30.7133),
  "Ardahan": LatLng(41.1085, 42.7022),
  "Artvin": LatLng(41.1828, 41.8183),
  "Aydın": LatLng(37.845, 27.8416),
  "Balıkesir": LatLng(39.6484, 27.8826),
  "Bartın": LatLng(41.5811, 32.4619),
  "Batman": LatLng(37.8878, 41.129),
  "Bayburt": LatLng(40.2552, 40.2249),
  "Bilecik": LatLng(40.0569, 29.9733),
  "Bingöl": LatLng(38.8847, 40.4981),
  "Bitlis": LatLng(38.4, 42.1),
  "Bolu": LatLng(40.7333, 31.6),
  "Burdur": LatLng(37.7167, 30.2833),
  "Bursa": LatLng(40.1826, 29.0669),
  "Çanakkale": LatLng(40.1553, 26.4142),
  "Çankırı": LatLng(40.6, 33.6167),
  "Çorum": LatLng(40.5506, 34.9556),
  "Denizli": LatLng(37.7765, 29.0864),
  "Diyarbakır": LatLng(37.9144, 40.2306),
  "Düzce": LatLng(40.8438, 31.1565),
  "Edirne": LatLng(41.6759, 26.5587),
  "Elazığ": LatLng(38.6667, 39.25),
  "Erzincan": LatLng(39.75, 39.5),
  "Erzurum": LatLng(39.9208, 41.2746),
  "Eskişehir": LatLng(39.7767, 30.5206),
  "Gaziantep": LatLng(37.0662, 37.3833),
  "Giresun": LatLng(40.913, 38.3895),
  "Gümüşhane": LatLng(40.4386, 39.5086),
  "Hakkari": LatLng(37.5744, 43.7408),
  "Hatay": LatLng(36.2066, 36.1572),
  "Iğdır": LatLng(39.8886, 44.0049),
  "Isparta": LatLng(37.75, 30.55),
  "İstanbul": LatLng(41.0082, 28.9784),
  "İzmir": LatLng(38.4237, 27.1428),
  "Kahramanmaraş": LatLng(37.5833, 36.9333),
  "Karabük": LatLng(41.2, 32.6333),
  "Karaman": LatLng(37.1759, 33.2287),
  "Kars": LatLng(40.5927, 43.0772),
  "Kastamonu": LatLng(41.3887, 33.7827),
  "Kayseri": LatLng(38.737, 35.4977),
  "Kırıkkale": LatLng(39.8578, 33.5109),
  "Kırklareli": LatLng(41.7333, 27.2167),
  "Kırşehir": LatLng(39.1458, 34.1638),
  "Kilis": LatLng(36.716, 37.115),
  "Kocaeli": LatLng(40.8533, 29.8815),
  "Konya": LatLng(37.8664, 32.4922),
  "Kütahya": LatLng(39.4214, 29.9838),
  "Malatya": LatLng(38.3552, 38.3095),
  "Manisa": LatLng(38.6191, 27.4289),
  "Mardin": LatLng(37.3122, 40.735),
  "Mersin": LatLng(36.8, 34.6167),
  "Muğla": LatLng(37.2167, 28.3667),
  "Muş": LatLng(38.7333, 41.4914),
  "Nevşehir": LatLng(38.6246, 34.723),
  "Niğde": LatLng(37.9667, 34.6833),
  "Ordu": LatLng(40.9839, 37.8764),
  "Osmaniye": LatLng(37.0742, 36.2472),
  "Rize": LatLng(41.0214, 40.5214),
  "Sakarya": LatLng(40.7669, 30.3909),
  "Samsun": LatLng(41.2928, 36.3319),
  "Siirt": LatLng(37.9272, 41.9408),
  "Sinop": LatLng(42.0228, 35.1531),
  "Sivas": LatLng(39.7483, 37.0161),
  "Şanlıurfa": LatLng(37.15, 38.8),
  "Şırnak": LatLng(37.5167, 42.4667),
  "Tekirdağ": LatLng(40.9833, 27.5167),
  "Tokat": LatLng(40.3, 36.55),
  "Trabzon": LatLng(41.005, 39.7269),
  "Tunceli": LatLng(39.1086, 39.5475),
  "Uşak": LatLng(38.6743, 29.405),
  "Van": LatLng(38.4891, 43.4089),
  "Yalova": LatLng(40.65, 29.2667),
  "Yozgat": LatLng(39.8208, 34.8147),
  "Zonguldak": LatLng(41.4564, 31.7987),
};
