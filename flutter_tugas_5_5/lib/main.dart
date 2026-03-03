import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi GridView',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior().copyWith(
        overscroll: false,
      ), // Removes the stretch overscroll effect
      theme: ThemeData(
        // Menggunakan warna hijau gelap sebagai warna utama sesuai referensi
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E502B)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HalamanProduk(),
    );
  }
}

// Model data untuk produk
class Produk {
  final String nama;
  final String gambar;
  final String ukuran;
  final double rating;
  final double harga;
  final String? tag;
  final Color? warnaTag;

  Produk({
    required this.nama,
    required this.gambar,
    required this.ukuran,
    required this.rating,
    required this.harga,
    this.tag,
    this.warnaTag,
  });
}

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  // Warna utama yang digunakan di aplikasi
  final Color hijauGelap = const Color(0xFF0E502B);
  final Color abuTerang = const Color(0xFFF7F7F9);

  // Data dummy produk berdasarkan gambar referensi
  final List<Produk> daftarProduk = [
    Produk(
      nama: "Organic Green Big Capsicum",
      gambar:
          "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&q=80&w=200",
      ukuran: "1000gm",
      rating: 4.8,
      harga: 24.00,
      tag: "FROZEN",
      warnaTag: Colors.amber,
    ),
    Produk(
      nama: "Seoul Yopokki Topokki",
      gambar:
          "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&q=80&w=200",
      ukuran: "1000gm",
      rating: 4.8,
      harga: 24.00,
      tag: "Best Sale",
      warnaTag: const Color(0xFF8B0000), // Merah gelap
    ),
    Produk(
      nama: "Tazaj Mart Full Cream Fresh Milk",
      gambar:
          "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&q=80&w=200",
      ukuran: "4pack",
      rating: 4.8,
      harga: 24.00,
    ),
    Produk(
      nama: "Cavendish banana Malaysia",
      gambar:
          "https://images.unsplash.com/photo-1587132137056-bfbf0166836e?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ukuran: "1000gm",
      rating: 4.8,
      harga: 0.40,
    ),
    Produk(
      nama: "Organic 100% Italian avocado",
      gambar:
          "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&q=80&w=200",
      ukuran: "10000gm",
      rating: 4.8,
      harga: 12.35,
    ),
    Produk(
      nama: "Mahin Brand Basmati Rice",
      gambar:
          "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&q=80&w=200",
      ukuran: "4pack",
      rating: 4.8,
      harga: 24.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        title: const Text(
          'All products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // Ikon Keranjang Belanja dengan Badge
          Badge(
            label: const Text('1'),
            backgroundColor: Colors.orange,
            offset: const Offset(-4, 4),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hijauGelap,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Foto Profil Pengguna
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=100',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Banner Promo ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: hijauGelap,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                height: 1.2,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Get ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: 'free delivery ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                TextSpan(
                                  text: 'on\nshopping \$200',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&q=80&w=300',
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Baris Filter & Sort ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'All Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Sort by',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- GridView Produk ---
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Scroll diatur oleh SingleChildScrollView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom sesuai referensi
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio:
                      0.62, // Mengatur rasio tinggi dan lebar item grid
                ),
                itemCount: daftarProduk.length,
                itemBuilder: (context, index) {
                  return _buildKartuProduk(daftarProduk[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat masing-masing kartu produk di dalam Grid
  Widget _buildKartuProduk(Produk produk) {
    return Container(
      decoration: BoxDecoration(
        color: abuTerang,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar dan Tag
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      produk.gambar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                if (produk.tag != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: produk.warnaTag,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        produk.tag!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Judul Produk
          Text(
            produk.nama,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: hijauGelap,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Ukuran dan Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                produk.ukuran,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '(${produk.rating}/5)',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Harga dan Tombol Tambah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${produk.harga.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: hijauGelap,
                ),
              ),
              InkWell(
                onTap: () {
                  // Aksi ketika tombol tambah ditekan
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: hijauGelap,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
