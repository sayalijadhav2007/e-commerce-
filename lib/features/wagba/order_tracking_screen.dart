import 'dart:convert';

import 'package:dual_role_delivery_app/application/orders/order_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  static const _restaurant = LatLng(19.0760, 72.8777);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersProvider.notifier).getById(orderId);
    if (order == null) {
      return const Scaffold(
        backgroundColor: WagbaColors.background,
        body: Center(child: Text('Order not found')),
      );
    }

    final destination = LatLng(order.latitude, order.longitude);
    return Scaffold(
      backgroundColor: WagbaColors.background,
      appBar: AppBar(title: const Text('Track Order')),
      body: FutureBuilder<RouteResult>(
        future: _fetchRoute(_restaurant, destination),
        builder: (context, snapshot) {
          final route = snapshot.data;
          return Column(
            children: [
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: destination,
                    initialZoom: 12.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dual_role_delivery_app',
                    ),
                    if (route != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: route.points,
                            color: WagbaColors.primary,
                            strokeWidth: 4,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        // ignore: prefer_const_constructors
                        Marker(
                          point: _restaurant,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.restaurant, color: Colors.white),
                        ),
                        Marker(
                          point: destination,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_pin, color: WagbaColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: WagbaColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'ETA',
                            style: TextStyle(color: WagbaColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            route == null
                                ? 'Calculating...'
                                : '${route.durationMinutes} min',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Distance',
                            style: TextStyle(color: WagbaColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            route == null
                                ? '--'
                                : '${route.distanceKm.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<RouteResult> _fetchRoute(LatLng start, LatLng end) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return RouteResult(points: [start, end], distanceKm: 0, durationMinutes: 0);
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final routes = json['routes'] as List<dynamic>;
    if (routes.isEmpty) {
      return RouteResult(points: [start, end], distanceKm: 0, durationMinutes: 0);
    }
    final route = routes.first as Map<String, dynamic>;
    final geometry = route['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;
    final points = coordinates
        .map((coord) => LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble()))
        .toList();
    final distanceKm = (route['distance'] as num).toDouble() / 1000.0;
    final durationMinutes = ((route['duration'] as num).toDouble() / 60).round();

    return RouteResult(
      points: points,
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
    );
  }
}

class RouteResult {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;

  const RouteResult({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });
}
