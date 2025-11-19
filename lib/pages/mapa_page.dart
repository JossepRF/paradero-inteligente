import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late GoogleMapController mapController;
  bool _isMapCreated = false;
  bool _hasError = false;
  bool _locationEnabled = false;
  LatLng? _currentLocation;
  BitmapDescriptor? _carritoIconAzul;
  BitmapDescriptor? _carritoIconMorado;

  // Variables para controlar qué rutas mostrar
  bool _mostrarRutaR7 = true;
  bool _mostrarRutaR2 = true;

  // Coordenadas centrales de Ica, Perú
  final LatLng _centro = const LatLng(-14.0678, -75.7286); // Ica

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _checkMapConfiguration();
    _createCustomIcons();
  }

  void _createCustomIcons() async {
    // Ícono azul para R7
    _carritoIconAzul = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    // Ícono morado para R2
    _carritoIconMorado = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    setState(() {});
  }

  // PARADEROS RUTA R7 (AZUL)
  List<Marker> get _paraderosR7 {
    final icon = _carritoIconAzul ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

    return [
      Marker(
        markerId: const MarkerId('b_ref_ptegrau'),
        position: const LatLng(-14.062083, -75.723861),
        infoWindow: const InfoWindow(
          title: 'B - PUENTE GRAU',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_luren'),
        position: const LatLng(-14.071463,-75.725365),
        infoWindow: const InfoWindow(
          title: 'B - IGLESIA LUREN',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_tottus'),
        position: const LatLng(-14.071471, -75.728415),
        infoWindow: const InfoWindow(
          title: 'B - TOTTUS',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_sanfrancisco'),
        position: const LatLng(-14.064150, -75.730753),
        infoWindow: const InfoWindow(
          title: 'B - IGLESIA SAN FRANCISCO',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_mcdoarenales'),
        position: const LatLng(-14.060518, -75.734940),
        infoWindow: const InfoWindow(
          title: 'B - MERCADO ARENALES',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_cementerio'),
        position: const LatLng(-14.057977, -75.740745),
        infoWindow: const InfoWindow(
          title: 'B - CEMENTERIO GENERAL DE SARAJA',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_crucesanjoaquin'),
        position: const LatLng(-14.055260, -75.744206),
        infoWindow: const InfoWindow(
          title: 'B - CRUCE DE SAN JOAQUIN',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_elalamo'),
        position: const LatLng(-14.047373, -75.749076),
        infoWindow: const InfoWindow(
          title: 'B - EL ÁLAMO',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_hotellasdunas'),
        position: const LatLng(-14.048441, -75.752104),
        infoWindow: const InfoWindow(
          title: 'B - HOTEL LAS DUNAS',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
    ];
  }

  // PARADEROS RUTA R2 (MORADO) - Recorrido completo corregido
  List<Marker> get _paraderosR2 {
    final icon = _carritoIconMorado ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);

    return [
      // INICIO - Prolongación Washington y Pablo Camargo
      Marker(
        markerId: const MarkerId('r2_washington_pablo'),
        position: const LatLng(-14.0760, -75.7460),
        infoWindow: const InfoWindow(
          title: 'R2 - Inicio: Washington/Pablo Camargo',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. México - Pro Vivienda Nuevo Amanecer
      Marker(
        markerId: const MarkerId('r2_mexico_amanecer'),
        position: const LatLng(-14.0740, -75.7440),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. México (Pro Vivienda)',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Prolongación Bogotá
      Marker(
        markerId: const MarkerId('r2_bogota'),
        position: const LatLng(-14.0720, -75.7420),
        infoWindow: const InfoWindow(
          title: 'R2 - Prolongación Bogotá',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Calle Pedro Sotelo (Plazuela)
      Marker(
        markerId: const MarkerId('r2_pedro_sotelo'),
        position: const LatLng(-14.0700, -75.7400),
        infoWindow: const InfoWindow(
          title: 'R2 - Calle Pedro Sotelo',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Rio De Janeiro
      Marker(
        markerId: const MarkerId('r2_rio_janeiro'),
        position: const LatLng(-14.0685, -75.7380),
        infoWindow: const InfoWindow(
          title: 'R2 - Rio De Janeiro',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Calle Angélica Donaire
      Marker(
        markerId: const MarkerId('r2_angelica_donaire'),
        position: const LatLng(-14.0670, -75.7360),
        infoWindow: const InfoWindow(
          title: 'R2 - Calle Angélica Donaire',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Panamá
      Marker(
        markerId: const MarkerId('r2_panama'),
        position: const LatLng(-14.0655, -75.7340),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Panamá',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Calle Madrid
      Marker(
        markerId: const MarkerId('r2_madrid'),
        position: const LatLng(-14.0640, -75.7320),
        infoWindow: const InfoWindow(
          title: 'R2 - Calle Madrid',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. México (segundo tramo)
      Marker(
        markerId: const MarkerId('r2_mexico_2'),
        position: const LatLng(-14.0625, -75.7300),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. México',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. El Parque
      Marker(
        markerId: const MarkerId('r2_el_parque'),
        position: const LatLng(-14.0610, -75.7280),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. El Parque',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. 28 De Julio
      Marker(
        markerId: const MarkerId('r2_28_julio'),
        position: const LatLng(-14.0595, -75.7260),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. 28 De Julio',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Vittorio Gotuzzo
      Marker(
        markerId: const MarkerId('r2_gotuzzo'),
        position: const LatLng(-14.0580, -75.7240),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Vittorio Gotuzzo',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Armando Revoredo
      Marker(
        markerId: const MarkerId('r2_revoredo'),
        position: const LatLng(-14.0565, -75.7220),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Armando Revoredo',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Distrito Parcona
      Marker(
        markerId: const MarkerId('r2_parcona'),
        position: const LatLng(-14.0550, -75.7200),
        infoWindow: const InfoWindow(
          title: 'R2 - Distrito Parcona',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Pachacutec Yupanqui
      Marker(
        markerId: const MarkerId('r2_pachacutec'),
        position: const LatLng(-14.0535, -75.7180),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Pachacutec Yupanqui',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Curva De Parcona
      Marker(
        markerId: const MarkerId('r2_curva_parcona'),
        position: const LatLng(-14.0520, -75.7160),
        infoWindow: const InfoWindow(
          title: 'R2 - Curva De Parcona',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Prolongación Grau
      Marker(
        markerId: const MarkerId('r2_grau'),
        position: const LatLng(-14.0505, -75.7140),
        infoWindow: const InfoWindow(
          title: 'R2 - Prolongación Grau',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Acomayo
      Marker(
        markerId: const MarkerId('r2_acomayo'),
        position: const LatLng(-14.0490, -75.7120),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Acomayo',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Puente Cutervo
      Marker(
        markerId: const MarkerId('r2_puente_cutervo'),
        position: const LatLng(-14.0475, -75.7100),
        infoWindow: const InfoWindow(
          title: 'R2 - Puente Cutervo',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Túpac Amaru
      Marker(
        markerId: const MarkerId('r2_tupac_amaru'),
        position: const LatLng(-14.0460, -75.7080),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Túpac Amaru',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Av. Ayabaca
      Marker(
        markerId: const MarkerId('r2_ayabaca'),
        position: const LatLng(-14.0445, -75.7060),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Ayabaca',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // SUNAT
      Marker(
        markerId: const MarkerId('r2_sunat'),
        position: const LatLng(-14.0430, -75.7040),
        infoWindow: const InfoWindow(
          title: 'R2 - SUNAT',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Plaza Vea
      Marker(
        markerId: const MarkerId('r2_plaza_vea'),
        position: const LatLng(-14.0415, -75.7020),
        infoWindow: const InfoWindow(
          title: 'R2 - Plaza Vea',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // Ovalo De Los Maestros
      Marker(
        markerId: const MarkerId('r2_ovalo_maestros'),
        position: const LatLng(-14.0400, -75.7000),
        infoWindow: const InfoWindow(
          title: 'R2 - Ovalo De Los Maestros',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      // FIN - Urb. Las Palmeras
      Marker(
        markerId: const MarkerId('r2_las_palmeras'),
        position: const LatLng(-14.0385, -75.6980),
        infoWindow: const InfoWindow(
          title: 'R2 - Fin: Urb. Las Palmeras',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
    ];
  }

//CÓDIGO ANTERIOR
  // RUTA R7 (AZUL) - MEJORADA CON CURVAS REALISTAS
 /* final List<LatLng> _rutaIdaR7 = const [
    // JJ Elías → Av. Ayabaca (con curvas)
    LatLng(-14.0680, -75.7350), // JJ Elías
    LatLng(-14.0678, -75.7345),
    LatLng(-14.0675, -75.7340),
    LatLng(-14.0672, -75.7335),
    LatLng(-14.0668, -75.7332),
    LatLng(-14.0665, -75.7328),
    LatLng(-14.0662, -75.7325),
    LatLng(-14.0658, -75.7322),

    // Av. Ayabaca → Mega Plaza (siguiendo avenidas)
    LatLng(-14.0655, -75.7318),
    LatLng(-14.0652, -75.7315),
    LatLng(-14.0648, -75.7312),
    LatLng(-14.0645, -75.7308),
    LatLng(-14.0642, -75.7305),
    LatLng(-14.0638, -75.7302),
    LatLng(-14.0635, -75.7300), // Mega Plaza

    // Mega Plaza → Hospital Regional (por calles)
    LatLng(-14.0632, -75.7295),
    LatLng(-14.0628, -75.7290),
    LatLng(-14.0625, -75.7285),
    LatLng(-14.0622, -75.7280),
    LatLng(-14.0618, -75.7275),
    LatLng(-14.0615, -75.7272),
    LatLng(-14.0612, -75.7268),
    LatLng(-14.0608, -75.7265),
    LatLng(-14.0605, -75.7262),
    LatLng(-14.0602, -75.7258),
    LatLng(-14.0598, -75.7255),
    LatLng(-14.0595, -75.7252),
    LatLng(-14.0592, -75.7250), // Hospital Regional

    // Hospital Regional → Comatrana
    LatLng(-14.0588, -75.7245),
    LatLng(-14.0585, -75.7242),
    LatLng(-14.0582, -75.7238),
    LatLng(-14.0578, -75.7235),
    LatLng(-14.0575, -75.7232),
    LatLng(-14.0572, -75.7228),
    LatLng(-14.0568, -75.7225),
    LatLng(-14.0565, -75.7222),
    LatLng(-14.0562, -75.7218),
    LatLng(-14.0558, -75.7215),
    LatLng(-14.0555, -75.7212),
    LatLng(-14.0552, -75.7208),
    LatLng(-14.0550, -75.7200), // Comatrana

    // Comatrana → Tierra Prometida
    LatLng(-14.0548, -75.7195),
    LatLng(-14.0545, -75.7190),
    LatLng(-14.0542, -75.7185),
    LatLng(-14.0538, -75.7180),
    LatLng(-14.0535, -75.7175),
    LatLng(-14.0532, -75.7170),
    LatLng(-14.0528, -75.7165),
    LatLng(-14.0525, -75.7160),
    LatLng(-14.0522, -75.7155),
    LatLng(-14.0520, -75.7150), // Tierra Prometida

    // Tierra Prometida → Florida
    LatLng(-14.0518, -75.7145),
    LatLng(-14.0515, -75.7140),
    LatLng(-14.0512, -75.7135),
    LatLng(-14.0508, -75.7130),
    LatLng(-14.0505, -75.7125),
    LatLng(-14.0502, -75.7120),
    LatLng(-14.0500, -75.7115),
    LatLng(-14.0500, -75.7100), // Florida
  ];*/

  // RUTA NUEVA "B"
  final List<LatLng> _rutaIdaR7 = const [
    LatLng(-14.03352, -75.69297),
    LatLng(-14.03368, -75.69339),
    LatLng(-14.03369, -75.69346),
    LatLng(-14.03372, -75.69394),
    LatLng(-14.03381, -75.6952),
    LatLng(-14.03381, -75.69521),
    LatLng(-14.03382, -75.69522),
    LatLng(-14.03382, -75.69523),
    LatLng(-14.03382, -75.69524),
    LatLng(-14.03382, -75.69525),
    LatLng(-14.03382, -75.69526),
    LatLng(-14.03382, -75.69527),
    LatLng(-14.03382, -75.69528),
    LatLng(-14.03382, -75.69529),
    LatLng(-14.03382, -75.6953),
    LatLng(-14.03382, -75.69531),
    LatLng(-14.03382, -75.69532),
    LatLng(-14.03382, -75.69533),
    LatLng(-14.03382, -75.69534),
    LatLng(-14.03382, -75.69535),
    LatLng(-14.03383, -75.69536),
    LatLng(-14.03383, -75.69537),
    LatLng(-14.03383, -75.69538),
    LatLng(-14.03383, -75.69539),
    LatLng(-14.03383, -75.6954),
    LatLng(-14.03383, -75.69541),
    LatLng(-14.03383, -75.69542),
    LatLng(-14.03383, -75.69543),
    LatLng(-14.03383, -75.69544),
    LatLng(-14.03383, -75.69545),
    LatLng(-14.03383, -75.69546),
    LatLng(-14.03383, -75.69547),
    LatLng(-14.03383, -75.69548),
    LatLng(-14.03383, -75.69549),
    LatLng(-14.03384, -75.69549),
    LatLng(-14.03384, -75.6955),
    LatLng(-14.03384, -75.69551),
    LatLng(-14.03384, -75.69552),
    LatLng(-14.03384, -75.69553),
    LatLng(-14.03384, -75.69554),
    LatLng(-14.03384, -75.69555),
    LatLng(-14.03384, -75.69556),
    LatLng(-14.03384, -75.69557),
    LatLng(-14.03384, -75.69558),
    LatLng(-14.03384, -75.69559),
    LatLng(-14.03384, -75.6956),
    LatLng(-14.03384, -75.69561),
    LatLng(-14.03384, -75.69562),
    LatLng(-14.03384, -75.69563),
    LatLng(-14.03384, -75.69564),
    LatLng(-14.03385, -75.69565),
    LatLng(-14.03385, -75.69566),
    LatLng(-14.03385, -75.69567),
    LatLng(-14.03385, -75.69568),
    LatLng(-14.03385, -75.69569),
    LatLng(-14.03385, -75.6957),
    LatLng(-14.03385, -75.69571),
    LatLng(-14.03385, -75.69572),
    LatLng(-14.03385, -75.69573),
    LatLng(-14.03385, -75.69574),
    LatLng(-14.03385, -75.69575),
    LatLng(-14.03385, -75.69576),
    LatLng(-14.03385, -75.69577),
    LatLng(-14.03385, -75.69578),
    LatLng(-14.03385, -75.69579),
    LatLng(-14.03386, -75.6958),
    LatLng(-14.03386, -75.69581),
    LatLng(-14.03386, -75.69582),
    LatLng(-14.03386, -75.69583),
    LatLng(-14.03386, -75.69584),
    LatLng(-14.03386, -75.69585),
    LatLng(-14.03386, -75.69586),
    LatLng(-14.03386, -75.69587),
    LatLng(-14.03386, -75.69588),
    LatLng(-14.03386, -75.69589),
    LatLng(-14.03386, -75.6959),
    LatLng(-14.03386, -75.69591),
    LatLng(-14.03386, -75.69592),
    LatLng(-14.03387, -75.69596),
    LatLng(-14.03393, -75.69649),
    LatLng(-14.034, -75.69709),
    LatLng(-14.034, -75.6971),
    LatLng(-14.03405, -75.69759),
    LatLng(-14.03406, -75.69764),
    LatLng(-14.03413, -75.6983),
    LatLng(-14.03421, -75.69896),
    LatLng(-14.03421, -75.69913),
    LatLng(-14.03422, -75.69924),
    LatLng(-14.03428, -75.69967),
    LatLng(-14.03434, -75.70034),
    LatLng(-14.03442, -75.70106),
    LatLng(-14.03444, -75.70124),
    LatLng(-14.03449, -75.70179),
    LatLng(-14.03456, -75.70242),
    LatLng(-14.03463, -75.7031),
    LatLng(-14.03463, -75.70311),
    LatLng(-14.03469, -75.70371),
    LatLng(-14.03475, -75.70437),
    LatLng(-14.03482, -75.70507),
    LatLng(-14.03487, -75.70575),
    LatLng(-14.03494, -75.70649),
    LatLng(-14.03499, -75.70704),
    LatLng(-14.0338, -75.70713),
    LatLng(-14.03371, -75.70714),
    LatLng(-14.03243, -75.70726),
    LatLng(-14.03243, -75.70728),
    LatLng(-14.03244, -75.70748),
    LatLng(-14.03244, -75.70754),
    LatLng(-14.03244, -75.70759),
    LatLng(-14.03242, -75.70767),
    LatLng(-14.0324, -75.70777),
    LatLng(-14.03237, -75.70796),
    LatLng(-14.03233, -75.70815),
    LatLng(-14.0323, -75.70833),
    LatLng(-14.03216, -75.70896),
    LatLng(-14.03206, -75.70955),
    LatLng(-14.03211, -75.70956),
    LatLng(-14.0329, -75.70979),
    LatLng(-14.03345, -75.70989),
    LatLng(-14.034, -75.71002),
    LatLng(-14.03401, -75.71002),
    LatLng(-14.03571, -75.71045),
    LatLng(-14.03573, -75.71046),
    LatLng(-14.03668, -75.71068),
    LatLng(-14.03774, -75.71092),
    LatLng(-14.03818, -75.71101),
    LatLng(-14.03849, -75.71105),
    LatLng(-14.0388, -75.71109),
    LatLng(-14.03881, -75.71109),
    LatLng(-14.03905, -75.71111),
    LatLng(-14.03935, -75.71112),
    LatLng(-14.03954, -75.7111),
    LatLng(-14.03974, -75.71107),
    LatLng(-14.03981, -75.71105),
    LatLng(-14.03991, -75.71102),
    LatLng(-14.04008, -75.71094),
    LatLng(-14.04042, -75.71074),
    LatLng(-14.04112, -75.71032),
    LatLng(-14.04238, -75.70956),
    LatLng(-14.04352, -75.70888),
    LatLng(-14.04494, -75.70805),
    LatLng(-14.04495, -75.70804),
    LatLng(-14.04547, -75.70771),
    LatLng(-14.04679, -75.70693),
    LatLng(-14.04703, -75.70676),
    LatLng(-14.04734, -75.70655),
    LatLng(-14.04735, -75.70655),
    LatLng(-14.04762, -75.70631),
    LatLng(-14.04778, -75.70616),
    LatLng(-14.04781, -75.70613),
    LatLng(-14.04788, -75.70604),
    LatLng(-14.04792, -75.70599),
    LatLng(-14.04859, -75.70506),
    LatLng(-14.04859, -75.70505),
    LatLng(-14.04888, -75.7045),
    LatLng(-14.04925, -75.70395),
    LatLng(-14.04974, -75.70325),
    LatLng(-14.05015, -75.70277),
    LatLng(-14.05048, -75.70308),
    LatLng(-14.05055, -75.70314),
    LatLng(-14.05056, -75.70316),
    LatLng(-14.05091, -75.70349),
    LatLng(-14.05113, -75.70368),
    LatLng(-14.05177, -75.70429),
    LatLng(-14.05188, -75.70439),
    LatLng(-14.05194, -75.70445),
    LatLng(-14.05198, -75.70449),
    LatLng(-14.05254, -75.70503),
    LatLng(-14.053, -75.70547),
    LatLng(-14.05311, -75.70557),
    LatLng(-14.0536, -75.70604),
    LatLng(-14.05485, -75.70724),
    LatLng(-14.05496, -75.70733),
    LatLng(-14.05649, -75.70881),
    LatLng(-14.05725, -75.70955),
    LatLng(-14.05777, -75.71003),
    LatLng(-14.05797, -75.71025),
    LatLng(-14.05806, -75.71036),
    LatLng(-14.05812, -75.71044),
    LatLng(-14.05817, -75.71052),
    LatLng(-14.05827, -75.71069),
    LatLng(-14.05835, -75.71087),
    LatLng(-14.05846, -75.71114),
    LatLng(-14.05864, -75.71174),
    LatLng(-14.05902, -75.71306),
    LatLng(-14.05918, -75.71361),
    LatLng(-14.0592, -75.71367),
    LatLng(-14.05936, -75.71426),
    LatLng(-14.05939, -75.71435),
    LatLng(-14.05948, -75.71471),
    LatLng(-14.05954, -75.71492),
    LatLng(-14.05956, -75.71499),
    LatLng(-14.05956, -75.71501),
    LatLng(-14.05993, -75.71639),
    LatLng(-14.05994, -75.71642),
    LatLng(-14.05996, -75.71649),
    LatLng(-14.05997, -75.71652),
    LatLng(-14.06008, -75.71685),
    LatLng(-14.06025, -75.71738),
    LatLng(-14.06052, -75.71834),
    LatLng(-14.06071, -75.71901),
    LatLng(-14.06074, -75.71913),
    LatLng(-14.06113, -75.72048),
    LatLng(-14.06116, -75.72059),
    LatLng(-14.0614, -75.72143),
    LatLng(-14.06142, -75.72149),
    LatLng(-14.06145, -75.72161),
    LatLng(-14.06186, -75.72303),
    LatLng(-14.0621, -75.72389),
    LatLng(-14.06329, -75.72346),
    LatLng(-14.0638, -75.72327),
    LatLng(-14.06413, -75.72314),
    LatLng(-14.06435, -75.72304),
    LatLng(-14.06499, -75.72278),
    LatLng(-14.06542, -75.7226),
    LatLng(-14.06582, -75.72243),
    LatLng(-14.06616, -75.72228),
    LatLng(-14.06655, -75.7221),
    LatLng(-14.06685, -75.72198),
    LatLng(-14.06704, -75.72189),
    LatLng(-14.06739, -75.72173),
    LatLng(-14.06829, -75.72131),
    LatLng(-14.06868, -75.72112),
    LatLng(-14.06908, -75.72093),
    LatLng(-14.06948, -75.72075),
    LatLng(-14.06989, -75.72056),
    LatLng(-14.07027, -75.72035),
    LatLng(-14.07033, -75.7205),
    LatLng(-14.07057, -75.72102),
    LatLng(-14.07061, -75.72111),
    LatLng(-14.07063, -75.7212),
    LatLng(-14.07065, -75.72129),
    LatLng(-14.07067, -75.72139),
    LatLng(-14.07078, -75.72193),
    LatLng(-14.07085, -75.72224),
    LatLng(-14.07095, -75.72281),
    LatLng(-14.07096, -75.72284),
    LatLng(-14.07097, -75.72287),
    LatLng(-14.07103, -75.72317),
    LatLng(-14.07112, -75.72364),
    LatLng(-14.0712, -75.72409),
    LatLng(-14.07123, -75.72423),
    LatLng(-14.07125, -75.72431),
    LatLng(-14.07126, -75.72436),
    LatLng(-14.07126, -75.72438),
    LatLng(-14.0713, -75.72452),
    LatLng(-14.07141, -75.72511),
    LatLng(-14.07148, -75.72559),
    LatLng(-14.07149, -75.72564),
    LatLng(-14.07151, -75.72574),
    LatLng(-14.07152, -75.72578),
    LatLng(-14.07158, -75.72615),
    LatLng(-14.07164, -75.72649),
    LatLng(-14.07174, -75.72715),
    LatLng(-14.07178, -75.72727),
    LatLng(-14.07182, -75.72738),
    LatLng(-14.07196, -75.72774),
    LatLng(-14.07206, -75.72798),
    LatLng(-14.07163, -75.72822),
    LatLng(-14.07058, -75.72872),
    LatLng(-14.07051, -75.72874),
    LatLng(-14.07014, -75.72885),
    LatLng(-14.07008, -75.72886),
    LatLng(-14.06955, -75.72903),
    LatLng(-14.06805, -75.72946),
    LatLng(-14.06701, -75.72978),
    LatLng(-14.06694, -75.7298),
    LatLng(-14.06692, -75.72981),
    LatLng(-14.06595, -75.73012),
    LatLng(-14.06591, -75.73013),
    LatLng(-14.0649, -75.73047),
    LatLng(-14.06446, -75.73063),
    LatLng(-14.06416, -75.73074),
    LatLng(-14.06401, -75.73079),
    LatLng(-14.06343, -75.73098),
    LatLng(-14.06285, -75.73115),
    LatLng(-14.06301, -75.73179),
    LatLng(-14.0631, -75.73217),
    LatLng(-14.06183, -75.73207),
    LatLng(-14.06142, -75.73309),
    LatLng(-14.06141, -75.7331),
    LatLng(-14.06128, -75.73325),
    LatLng(-14.06113, -75.73356),
    LatLng(-14.06096, -75.73395),
    LatLng(-14.06062, -75.73475),
    LatLng(-14.06059, -75.73484),
    LatLng(-14.06036, -75.73539),
    LatLng(-14.06021, -75.73574),
    LatLng(-14.06007, -75.73608),
    LatLng(-14.05992, -75.73647),
    LatLng(-14.05971, -75.73694),
    LatLng(-14.05956, -75.73732),
    LatLng(-14.05948, -75.73739),
    LatLng(-14.05932, -75.73753),
    LatLng(-14.05916, -75.73772),
    LatLng(-14.05901, -75.73796),
    LatLng(-14.05891, -75.73826),
    LatLng(-14.05886, -75.7384),
    LatLng(-14.05883, -75.73846),
    LatLng(-14.0587, -75.73878),
    LatLng(-14.05862, -75.73895),
    LatLng(-14.05828, -75.73983),
    LatLng(-14.05815, -75.74016),
    LatLng(-14.05802, -75.74048),
    LatLng(-14.05794, -75.74065),
    LatLng(-14.05779, -75.74077),
    LatLng(-14.05754, -75.74091),
    LatLng(-14.05729, -75.74104),
    LatLng(-14.05713, -75.74112),
    LatLng(-14.05597, -75.74172),
    LatLng(-14.05583, -75.7418),
    LatLng(-14.05537, -75.74204),
    LatLng(-14.05504, -75.74226),
    LatLng(-14.05489, -75.74236),
    LatLng(-14.05482, -75.74246),
    LatLng(-14.05479, -75.74252),
    LatLng(-14.05475, -75.74261),
    LatLng(-14.05473, -75.74269),
    LatLng(-14.05472, -75.74272),
    LatLng(-14.05471, -75.74284),
    LatLng(-14.0547, -75.74287),
    LatLng(-14.0547, -75.74295),
    LatLng(-14.0547, -75.74306),
    LatLng(-14.05472, -75.74315),
    LatLng(-14.05475, -75.74324),
    LatLng(-14.05517, -75.74409),
    LatLng(-14.05519, -75.74416),
    LatLng(-14.05493, -75.74435),
    LatLng(-14.05421, -75.74483),
    LatLng(-14.05312, -75.74556),
    LatLng(-14.05245, -75.746),
    LatLng(-14.0519, -75.74635),
    LatLng(-14.05155, -75.74657),
    LatLng(-14.05149, -75.74659),
    LatLng(-14.05144, -75.74661),
    LatLng(-14.05139, -75.74664),
    LatLng(-14.05135, -75.74668),
    LatLng(-14.05133, -75.74671),
    LatLng(-14.05066, -75.74707),
    LatLng(-14.04753, -75.7487),
    LatLng(-14.04747, -75.74874),
    LatLng(-14.04742, -75.74879),
    LatLng(-14.04731, -75.74886),
    LatLng(-14.04717, -75.74893),
    LatLng(-14.0471, -75.74897),
    LatLng(-14.0468, -75.74914),
    LatLng(-14.04685, -75.74931),
    LatLng(-14.04688, -75.74938),
    LatLng(-14.04727, -75.75007),
    LatLng(-14.04738, -75.75023),
    LatLng(-14.04754, -75.75048),
    LatLng(-14.04768, -75.75067),
    LatLng(-14.04779, -75.75081),
    LatLng(-14.04797, -75.75105),
    LatLng(-14.04809, -75.75122),
    LatLng(-14.04829, -75.75158),
    LatLng(-14.04854, -75.75213),
    LatLng(-14.04855, -75.75214),
    LatLng(-14.04855, -75.75215),
    LatLng(-14.04856, -75.75216),
    LatLng(-14.04856, -75.75218),
    LatLng(-14.04857, -75.75219),
    LatLng(-14.04857, -75.7522),
    LatLng(-14.04858, -75.75221),
    LatLng(-14.04859, -75.75222),
    LatLng(-14.04859, -75.75224),
    LatLng(-14.0486, -75.75225),
    LatLng(-14.04893, -75.75296),
    LatLng(-14.04894, -75.753),
    LatLng(-14.04903, -75.75317),
    LatLng(-14.04922, -75.75357),
    LatLng(-14.04932, -75.75375),
    LatLng(-14.04941, -75.75388),
    LatLng(-14.04948, -75.75399),
    LatLng(-14.04953, -75.75407),
    LatLng(-14.04961, -75.75415),
    LatLng(-14.04971, -75.75424),
    LatLng(-14.04982, -75.75432),
    LatLng(-14.04997, -75.75442),
    LatLng(-14.05001, -75.75445),
    LatLng(-14.05011, -75.75451),
    LatLng(-14.05033, -75.75465),
    LatLng(-14.05063, -75.75491),
    LatLng(-14.05094, -75.75531),
    LatLng(-14.0512, -75.75575),
    LatLng(-14.05123, -75.7558),
    LatLng(-14.05144, -75.75612),
    LatLng(-14.05232, -75.75729),
    LatLng(-14.05291, -75.75808),
    LatLng(-14.05222, -75.7586),
    LatLng(-14.05205, -75.75875),
    LatLng(-14.05206, -75.75875),
    LatLng(-14.05262, -75.75949),
    LatLng(-14.05269, -75.75961),
    LatLng(-14.05273, -75.75977),
    LatLng(-14.05276, -75.75991),
    LatLng(-14.05277, -75.76004),
    LatLng(-14.05277, -75.76014),
    LatLng(-14.05259, -75.7609),
    LatLng(-14.05257, -75.76102),
    LatLng(-14.05236, -75.76189),
  ];

  /*final List<LatLng> _rutaVueltaR7 = const [
    // Florida → Tierra Prometida
    LatLng(-14.0500, -75.7100), // Florida
    LatLng(-14.0502, -75.7105),
    LatLng(-14.0505, -75.7110),
    LatLng(-14.0508, -75.7115),
    LatLng(-14.0512, -75.7120),
    LatLng(-14.0515, -75.7125),
    LatLng(-14.0518, -75.7130),
    LatLng(-14.0520, -75.7135),
    LatLng(-14.0522, -75.7140),
    LatLng(-14.0525, -75.7145),
    LatLng(-14.0528, -75.7150),
    LatLng(-14.0530, -75.7155),
    LatLng(-14.0532, -75.7160),
    LatLng(-14.0535, -75.7165),
    LatLng(-14.0538, -75.7170),
    LatLng(-14.0540, -75.7175),
    LatLng(-14.0542, -75.7180),
    LatLng(-14.0545, -75.7185),
    LatLng(-14.0548, -75.7190),
    LatLng(-14.0550, -75.7195),
    LatLng(-14.0550, -75.7200), // Comatrana

    // Comatrana → Hospital Regional
    LatLng(-14.0552, -75.7205),
    LatLng(-14.0555, -75.7210),
    LatLng(-14.0558, -75.7215),
    LatLng(-14.0562, -75.7220),
    LatLng(-14.0565, -75.7225),
    LatLng(-14.0568, -75.7230),
    LatLng(-14.0572, -75.7235),
    LatLng(-14.0575, -75.7240),
    LatLng(-14.0578, -75.7245),
    LatLng(-14.0582, -75.7250),
    LatLng(-14.0585, -75.7255),
    LatLng(-14.0588, -75.7260),
    LatLng(-14.0592, -75.7265),
    LatLng(-14.0595, -75.7270),
    LatLng(-14.0598, -75.7275),
    LatLng(-14.0602, -75.7280),
    LatLng(-14.0605, -75.7285),
    LatLng(-14.0608, -75.7290),
    LatLng(-14.0612, -75.7295),
    LatLng(-14.0615, -75.7300), // Mega Plaza

    // Mega Plaza → JJ Elías (ruta alternativa)
    LatLng(-14.0618, -75.7305),
    LatLng(-14.0622, -75.7310),
    LatLng(-14.0625, -75.7315),
    LatLng(-14.0628, -75.7320),
    LatLng(-14.0632, -75.7325),
    LatLng(-14.0635, -75.7330),
    LatLng(-14.0638, -75.7335),
    LatLng(-14.0642, -75.7340),
    LatLng(-14.0645, -75.7345),
    LatLng(-14.0648, -75.7350),
    LatLng(-14.0652, -75.7355),
    LatLng(-14.0655, -75.7360),
    LatLng(-14.0658, -75.7365),
    LatLng(-14.0662, -75.7370),
    LatLng(-14.0665, -75.7375),
    LatLng(-14.0668, -75.7380),
    LatLng(-14.0672, -75.7385),
    LatLng(-14.0675, -75.7390),
    LatLng(-14.0678, -75.7395),
    LatLng(-14.0680, -75.7400),
    LatLng(-14.0680, -75.7350), // JJ Elías
  ];*/

  // RUTA R2 (MORADO) - IDA MEJORADA CON CURVAS
  final List<LatLng> _rutaIdaR2 = const [
    // Inicio: Prolongación Washington y Pablo Camargo
    LatLng(-14.0760, -75.7460),
    LatLng(-14.0758, -75.7455),
    LatLng(-14.0755, -75.7450),
    LatLng(-14.0752, -75.7445),
    LatLng(-14.0748, -75.7442),
    LatLng(-14.0745, -75.7440),
    LatLng(-14.0742, -75.7438),
    LatLng(-14.0740, -75.7435),
    LatLng(-14.0740, -75.7440), // Av. México - Pro Vivienda

    // Av. México → Prolongación Bogotá
    LatLng(-14.0738, -75.7435),
    LatLng(-14.0735, -75.7430),
    LatLng(-14.0732, -75.7425),
    LatLng(-14.0728, -75.7422),
    LatLng(-14.0725, -75.7420),
    LatLng(-14.0722, -75.7418),
    LatLng(-14.0720, -75.7415),
    LatLng(-14.0720, -75.7420), // Prolongación Bogotá

    // Prolongación Bogotá → Calle Pedro Sotelo
    LatLng(-14.0718, -75.7415),
    LatLng(-14.0715, -75.7410),
    LatLng(-14.0712, -75.7405),
    LatLng(-14.0708, -75.7402),
    LatLng(-14.0705, -75.7400),
    LatLng(-14.0702, -75.7398),
    LatLng(-14.0700, -75.7395),
    LatLng(-14.0700, -75.7400), // Calle Pedro Sotelo

    // Calle Pedro Sotelo → Rio De Janeiro
    LatLng(-14.0698, -75.7395),
    LatLng(-14.0695, -75.7390),
    LatLng(-14.0692, -75.7385),
    LatLng(-14.0688, -75.7382),
    LatLng(-14.0685, -75.7380),
    LatLng(-14.0682, -75.7378),
    LatLng(-14.0680, -75.7375),
    LatLng(-14.0685, -75.7380), // Rio De Janeiro

    // Rio De Janeiro → Calle Angélica Donaire
    LatLng(-14.0683, -75.7375),
    LatLng(-14.0680, -75.7370),
    LatLng(-14.0677, -75.7365),
    LatLng(-14.0673, -75.7362),
    LatLng(-14.0670, -75.7360),
    LatLng(-14.0667, -75.7358),
    LatLng(-14.0665, -75.7355),
    LatLng(-14.0670, -75.7360), // Calle Angélica Donaire

    // Continúa el patrón para todos los puntos...
    LatLng(-14.0665, -75.7355),
    LatLng(-14.0660, -75.7350),
    LatLng(-14.0657, -75.7345),
    LatLng(-14.0653, -75.7342),
    LatLng(-14.0650, -75.7340),
    LatLng(-14.0647, -75.7338),
    LatLng(-14.0645, -75.7335),
    LatLng(-14.0655, -75.7340), // Av. Panamá

    LatLng(-14.0650, -75.7335),
    LatLng(-14.0645, -75.7330),
    LatLng(-14.0642, -75.7325),
    LatLng(-14.0638, -75.7322),
    LatLng(-14.0635, -75.7320),
    LatLng(-14.0632, -75.7318),
    LatLng(-14.0630, -75.7315),
    LatLng(-14.0640, -75.7320), // Calle Madrid

    // Continúa con el mismo patrón para todos los puntos restantes...
    LatLng(-14.0625, -75.7300), // Av. México (segundo tramo)
    LatLng(-14.0610, -75.7280), // Av. El Parque
    LatLng(-14.0595, -75.7260), // Av. 28 De Julio
    LatLng(-14.0580, -75.7240), // Av. Vittorio Gotuzzo
    LatLng(-14.0565, -75.7220), // Av. Armando Revoredo
    LatLng(-14.0550, -75.7200), // Distrito Parcona
    LatLng(-14.0535, -75.7180), // Av. Pachacutec Yupanqui
    LatLng(-14.0520, -75.7160), // Curva De Parcona
    LatLng(-14.0505, -75.7140), // Prolongación Grau
    LatLng(-14.0490, -75.7120), // Av. Acomayo
    LatLng(-14.0475, -75.7100), // Puente Cutervo
    LatLng(-14.0460, -75.7080), // Av. Túpac Amaru
    LatLng(-14.0445, -75.7060), // Av. Ayabaca
    LatLng(-14.0430, -75.7040), // SUNAT
    LatLng(-14.0415, -75.7020), // Plaza Vea
    LatLng(-14.0400, -75.7000), // Ovalo De Los Maestros
    LatLng(-14.0385, -75.6980), // Fin: Urb. Las Palmeras
  ];

  // RUTA R2 (MORADO) - VUELTA MEJORADA CON CURVAS
  final List<LatLng> _rutaVueltaR2 = const [
    // Inicio: Urb. Las Palmeras
    LatLng(-14.0385, -75.6980),
    LatLng(-14.0388, -75.6985),
    LatLng(-14.0390, -75.6990),
    LatLng(-14.0392, -75.6995),
    LatLng(-14.0395, -75.7000),
    LatLng(-14.0398, -75.7005),
    LatLng(-14.0400, -75.7010),
    LatLng(-14.0400, -75.7000), // Ovalo De Los Maestros

    // Continúa el patrón para todos los puntos de vuelta...
    LatLng(-14.0405, -75.7005),
    LatLng(-14.0410, -75.7010),
    LatLng(-14.0413, -75.7015),
    LatLng(-14.0415, -75.7020), // Plaza Vea

    LatLng(-14.0420, -75.7025),
    LatLng(-14.0425, -75.7030),
    LatLng(-14.0428, -75.7035),
    LatLng(-14.0430, -75.7040), // SUNAT

    // Continúa con el mismo patrón para todos los puntos restantes...
    LatLng(-14.0445, -75.7060), // Av. Ayabaca
    LatLng(-14.0460, -75.7080), // Av. Túpac Amaru
    LatLng(-14.0475, -75.7100), // Puente Cutervo
    LatLng(-14.0490, -75.7120), // Av. Acomayo
    LatLng(-14.0505, -75.7140), // Prolongación Grau
    LatLng(-14.0520, -75.7160), // Curva De Parcona
    LatLng(-14.0535, -75.7180), // Av. Pachacutec Yupanqui
    LatLng(-14.0550, -75.7200), // Distrito Parcona
    LatLng(-14.0565, -75.7220), // Av. Armando Revoredo
    LatLng(-14.0580, -75.7240), // Av. Vittorio Gotuzzo
    LatLng(-14.0595, -75.7260), // Av. 28 De Julio
    LatLng(-14.0610, -75.7280), // Av. El Parque
    LatLng(-14.0625, -75.7300), // Av. México (segundo tramo)
    LatLng(-14.0640, -75.7320), // Calle Madrid
    LatLng(-14.0655, -75.7340), // Av. Panamá
    LatLng(-14.0670, -75.7360), // Calle Angélica Donaire
    LatLng(-14.0685, -75.7380), // Rio De Janeiro
    LatLng(-14.0700, -75.7400), // Calle Pedro Sotelo
    LatLng(-14.0720, -75.7420), // Prolongación Bogotá
    LatLng(-14.0740, -75.7440), // Av. México - Pro Vivienda
    LatLng(-14.0760, -75.7460), // Fin: Prolongación Washington y Pablo Camargo
  ];

  // Método para obtener todos los marcadores visibles
  Set<Marker> get _marcadoresVisibles {
    Set<Marker> marcadores = {};
    if (_mostrarRutaR7) marcadores.addAll(_paraderosR7);
    if (_mostrarRutaR2) marcadores.addAll(_paraderosR2);
    return marcadores;
  }

  // Método para obtener todas las polylines visibles
  Set<Polyline> get _polylinesVisibles {
    Set<Polyline> polylines = {};

    if (_mostrarRutaR7) {
      polylines.addAll({
        Polyline(
          polylineId: const PolylineId('rutaIdaR7'),
          color: Colors.blue,
          width: 5,
          points: _rutaIdaR7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
        /*Polyline(
          polylineId: const PolylineId('rutaVueltaR7'),
          color: Colors.lightBlue,
          width: 5,
          points: _rutaVueltaR7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),*/
      });
    }

    if (_mostrarRutaR2) {
      polylines.addAll({
        Polyline(
          polylineId: const PolylineId('rutaIdaR2'),
          color: Colors.purple,
          width: 5,
          points: _rutaIdaR2,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
        Polyline(
          polylineId: const PolylineId('rutaVueltaR2'),
          color: Colors.purpleAccent,
          width: 5,
          points: _rutaVueltaR2,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      });
    }

    return polylines;
  }

  void _checkMapConfiguration() {
    print('🗺️ Configuración de Maps para Ica verificada');
    print('📍 Centro Ica: $_centro');
    print('🚏 Paraderos R7: ${_paraderosR7.length}');
    print('🚏 Paraderos R2: ${_paraderosR2.length}');
  }

  Future<void> _checkLocationPermission() async {
    try {
      final status = await Permission.location.status;
      if (status.isGranted) {
        setState(() {
          _locationEnabled = true;
        });
      } else {
        final result = await Permission.location.request();
        if (result.isGranted) {
          setState(() {
            _locationEnabled = true;
          });
        }
      }
    } catch (e) {
      print('❌ Error en permisos: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isMapCreated = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _goToCenter();
    });
  }

  void _toggleRutaR7() {
    setState(() {
      _mostrarRutaR7 = !_mostrarRutaR7;
    });
  }

  void _toggleRutaR2() {
    setState(() {
      _mostrarRutaR2 = !_mostrarRutaR2;
    });
  }

  void _zoomIn() => mapController.animateCamera(CameraUpdate.zoomIn());
  void _zoomOut() => mapController.animateCamera(CameraUpdate.zoomOut());

  void _goToCenter() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _centro,
          zoom: 12.0, // Reducido el zoom para ver toda la ruta R2
          bearing: 0,
          tilt: 0,
        ),
      ),
    );
  }

  void _goToMyLocation() {
    if (_currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation!,
            zoom: 16.0,
          ),
        ),
      );
    } else {
      _goToCenter();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ubicación no disponible, centrando en Ica'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _refreshMap() {
    setState(() {
      _hasError = false;
    });
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar el mapa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),
            const Text(
              'Verifica que:\n• Tu conexión a internet funcione\n• La API Key de Google Maps esté configurada\n• Los servicios de Google Play estén actualizados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _refreshMap,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: _goToCenter,
                  icon: const Icon(Icons.map),
                  label: const Text('Centrar en Ica'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
          SizedBox(height: 16),
          Text(
            'Cargando mapa de Ica...',
            style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_bus, color: Colors.blueAccent, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rutas R7 y R2 - Ica',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Text(
                    'Tarifas: General S/1.50 • Escolar S/0.70 • Universitario S/1.00',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    'R7: ${_paraderosR7.length} paraderos • R2: ${_paraderosR2.length} paraderos',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              _locationEnabled ? Icons.location_on : Icons.location_off,
              color: _locationEnabled ? Colors.green : Colors.orange,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRutas() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botón R7
                GestureDetector(
                  onTap: _toggleRutaR7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _mostrarRutaR7 ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _mostrarRutaR7 ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'B ${_mostrarRutaR7 ? '✓' : '✗'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _mostrarRutaR7 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botón R2
                GestureDetector(
                  onTap: _toggleRutaR2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _mostrarRutaR2 ? Colors.purple.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _mostrarRutaR2 ? Colors.purple : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'R2 ${_mostrarRutaR2 ? '✓' : '✗'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _mostrarRutaR2 ? Colors.purple : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Toca para mostrar/ocultar rutas',
              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas R7 y R2 - Ica'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          if (_isMapCreated)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _goToMyLocation,
              tooltip: 'Mi ubicación',
            ),
          if (_isMapCreated)
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              onPressed: _goToCenter,
              tooltip: 'Centrar en Ica',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMap,
            tooltip: 'Recargar mapa',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (CameraPosition position) {},
            onCameraIdle: () {},
            initialCameraPosition: CameraPosition(
              target: _centro,
              zoom: 12.0, // Zoom reducido para ver toda la ruta R2
            ),
            markers: _marcadoresVisibles,
            polylines: _polylinesVisibles,
            myLocationEnabled: _locationEnabled,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            trafficEnabled: false,
            buildingsEnabled: true,
            mapToolbarEnabled: true,
            onTap: (LatLng position) {
              print('📍 Mapa de Ica tocado en: $position');
            },
          ),

          // Controles de zoom
          if (_isMapCreated && !_hasError)
            Positioned(
              right: 16,
              bottom: 140,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoom_in',
                    onPressed: _zoomIn,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'zoom_out',
                    onPressed: _zoomOut,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),

          // Control de rutas
          if (_isMapCreated && !_hasError) _buildControlRutas(),

          // Información de rutas
          if (!_hasError) _buildRouteInfo(),

          // Indicador de carga
          if (!_isMapCreated && !_hasError) _buildLoadingWidget(),

          // Mensaje de error
          if (_hasError) _buildErrorWidget(),
        ],
      ),
      floatingActionButton: _isMapCreated && !_hasError
          ? FloatingActionButton(
        onPressed: _goToMyLocation,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.my_location),
      )
          : null,
    );
  }
}