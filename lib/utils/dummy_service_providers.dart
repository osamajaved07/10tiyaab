import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceProvider {
  final String name;
  final String skill;
  final String price;
  final String travelTime;
  final LatLng location;

  ServiceProvider({
    required this.name,
    required this.skill,
    required this.price,
    required this.travelTime,
    required this.location,
  });
}

List<ServiceProvider> dummyServiceProviders = [
  ServiceProvider(
    name: "Kamran Ghulam",
    skill: "Plumber",
    price: "Rs 400",
    travelTime: "800m away",
    location: const LatLng(24.8607, 67.0011), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Babar Khan",
    skill: "Electrician",
    price: "Rs 600",
    travelTime: "1km away",
    location: const LatLng(24.8617, 67.0021), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Rizwan Ali",
    skill: "Painter",
    price: "Rs 800",
    travelTime: "1.2km away",
    location: const LatLng(24.8627, 67.0031), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Ahmed Khan",
    skill: "Carpenter",
    price: "Rs 500",
    travelTime: "1.5km away",
    location: const LatLng(24.8637, 67.0041), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Zainab",
    skill: "Cleaner",
    price: "Rs 300",
    travelTime: "2km away",
    location: const LatLng(24.8647, 67.0051), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Fahad",
    skill: "Mechanic",
    price: "Rs 700",
    travelTime: "2.5km away",
    location: const LatLng(24.8657, 67.0061), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Sana",
    skill: "Cook",
    price: "Rs 900",
    travelTime: "3km away",
    location: const LatLng(24.8667, 67.0071), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Ali Raza",
    skill: "Gardener",
    price: "Rs 450",
    travelTime: "3.5km away",
    location: const LatLng(24.8677, 67.0081), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Nasir",
    skill: "Driver",
    price: "Rs 550",
    travelTime: "4km away",
    location: const LatLng(24.8687, 67.0091), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Hassan",
    skill: "Tailor",
    price: "Rs 350",
    travelTime: "4.5km away",
    location: const LatLng(24.8697, 67.0101), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Ayesha",
    skill: "Laundry",
    price: "Rs 250",
    travelTime: "5km away",
    location: const LatLng(24.8707, 67.0111), // Gulshan Chowrangi
  ),
  ServiceProvider(
    name: "Hamza",
    skill: "Plumber",
    price: "Rs 400",
    travelTime: "800m away",
    location: const LatLng(24.8717, 67.0121), // Clifton
  ),
  ServiceProvider(
    name: "Nida",
    skill: "Electrician",
    price: "Rs 600",
    travelTime: "1km away",
    location: const LatLng(24.8727, 67.0131), // Clifton
  ),
  ServiceProvider(
    name: "Mehran",
    skill: "Painter",
    price: "Rs 800",
    travelTime: "1.2km away",
    location: const LatLng(24.8737, 67.0141), // Clifton
  ),
  ServiceProvider(
    name: "Saima",
    skill: "Carpenter",
    price: "Rs 500",
    travelTime: "1.5km away",
    location: const LatLng(24.8747, 67.0151), // Clifton
  ),
  ServiceProvider(
    name: "Tariq",
    skill: "Cleaner",
    price: "Rs 300",
    travelTime: "2km away",
    location: const LatLng(24.8757, 67.0161), // Clifton
  ),
  ServiceProvider(
    name: "Fatima",
    skill: "Mechanic",
    price: "Rs 700",
    travelTime: "2.5km away",
    location: const LatLng(24.8767, 67.0171), // Clifton
  ),
  ServiceProvider(
    name: "Waqar",
    skill: "Cook",
    price: "Rs 900",
    travelTime: "3km away",
    location: const LatLng(24.8777, 67.0181), // Clifton
  ),
  ServiceProvider(
    name: "Aisha",
    skill: "Gardener",
    price: "Rs 450",
    travelTime: "3.5km away",
    location: const LatLng(24.8787, 67.0191), // Clifton
  ),
  // North Karachi Service Providers
  ServiceProvider(
    name: "Aslam",
    skill: "Plumber",
    price: "Rs 500",
    travelTime: "1km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Haseeb",
    skill: "Electrician",
    price: "Rs 700",
    travelTime: "1.2km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Naveed",
    skill: "Painter",
    price: "Rs 900",
    travelTime: "1.5km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Saeed",
    skill: "Carpenter",
    price: "Rs 600",
    travelTime: "2km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Amna",
    skill: "Cleaner",
    price: "Rs 400",
    travelTime: "2.5km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Raza",
    skill: "Mechanic",
    price: "Rs 800",
    travelTime: "3km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Sobia",
    skill: "Cook",
    price: "Rs 1000",
    travelTime: "3.5km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Farooq",
    skill: "Plumber",
    price: "Rs 550",
    travelTime: "4km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Rahman",
    skill: "Carpenter",
    price: "Rs 450",
    travelTime: "4.5km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Nasir",
    skill: "Welder",
    price: "Rs 450",
    travelTime: "5km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
  ServiceProvider(
    name: "Hamza",
    skill: "Electrician",
    price: "Rs 350",
    travelTime: "5.5km away",
    location: const LatLng(24.9729, 67.0643), // North Karachi
  ),
];
