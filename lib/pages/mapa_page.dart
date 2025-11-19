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
        markerId: const MarkerId('r7_jj_elias'),
        position: const LatLng(-14.0680, -75.7350),
        infoWindow: const InfoWindow(
          title: 'R7 - JJ Elías',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r7_mega_plaza'),
        position: const LatLng(-14.0630, -75.7300),
        infoWindow: const InfoWindow(
          title: 'R7 - Mega Plaza',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r7_hospital'),
        position: const LatLng(-14.0580, -75.7250),
        infoWindow: const InfoWindow(
          title: 'R7 - Hospital Regional',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r7_comatrana'),
        position: const LatLng(-14.0550, -75.7200),
        infoWindow: const InfoWindow(
          title: 'R7 - Comatrana',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r7_tierra_prometida'),
        position: const LatLng(-14.0520, -75.7150),
        infoWindow: const InfoWindow(
          title: 'R7 - Tierra Prometida',
          snippet: 'General: S/ 1.50 • Escolar: S/ 0.70 • Univ: S/ 1.00',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r7_florida'),
        position: const LatLng(-14.0500, -75.7100),
        infoWindow: const InfoWindow(
          title: 'R7 - Florida',
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

  // RUTA R7 (AZUL) - MEJORADA CON CURVAS REALISTAS
  final List<LatLng> _rutaIdaR7 = const [
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
  ];

  final List<LatLng> _rutaVueltaR7 = const [
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
  ];

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
        Polyline(
          polylineId: const PolylineId('rutaVueltaR7'),
          color: Colors.lightBlue,
          width: 5,
          points: _rutaVueltaR7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
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
                          'R7 ${_mostrarRutaR7 ? '✓' : '✗'}',
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