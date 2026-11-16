# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Tugas 7

1. Widget tree. Semua elemen UI adalah widget yang tersusun bertingkat. Dengan susuan: MyApp, MaterialApp, MyHomePage, Scaffold, AppBar dan body, Padding, Column, Row (isi InfoCard) dan GridView (isi ItemCard). Parent menyimpan child lewat properti child atau children. Parent memberi batasan ukuran ke child, child menentukan ukurannya, lalu parent menentukan posisinya. Gunakan contoh dari kodemu.

2. Daftar widget:
- MaterialApp: root aplikasi dan tema.
- Scaffold: kerangka halaman.
- AppBar: bilah atas.
- Padding: jarak di sekeliling konten.
- Column dan Row: susunan vertikal dan horizontal.
- SizedBox: jarak antar-elemen.
- Center: memusatkan konten.
- GridView.count: kisi tombol.
- Card: kartu InfoCard.
- Container: pembungkus dengan ukuran dan padding.
- Material dan InkWell: latar berwarna dan efek sentuh pada ItemCard.
- Icon: ikon.
- Text: teks.
- SnackBar: pesan singkat di bawah layar.
- Widget buatanmu sendiri: MyApp, MyHomePage, InfoCard, ItemCard.

3. MaterialApp. Membungkus aplikasi dengan konfigurasi Material Design: title, theme, home, navigasi/route, dan lokalisasi. Ia juga menyediakan layanan yang dibutuhkan widget di bawahnya, seperti Theme, Navigator, dan konteks untuk ScaffoldMessenger. Itu sebabnya ia umum jadi root.

4. Stateless vs Stateful. StatelessWidget tidak punya state yang berubah, tampilannya hanya bergantung pada konfigurasi yang diberikan (MyHomePage, InfoCard). StatefulWidget punya objek State yang bisa berubah lewat setState() (misalnya form, counter, switch). Pilih stateless dulu, dan beralih ke stateful kalau tampilan harus berubah karena data internal.

5. BuildContext. Penunjuk lokasi widget di dalam tree. Dengannya kamu bisa mencari widget leluhur, misalnya Theme.of(context), MediaQuery.of(context), dan ScaffoldMessenger.of(context). Ia menjadi parameter di build(BuildContext context).

6. Hot reload vs hot restart. Hot reload menyuntikkan kode baru ke aplikasi yang berjalan dan membangun ulang tree dengan state tetap. Hot restart menjalankan ulang aplikasi dari main() dan state kembali ke awal. Pakai hot restart atau full restart (stop lalu run) untuk perubahan di main(), inisialisasi state awal (initState) atau variabel global, perubahan pubspec.yaml (setelah pub get), dan konfigurasi platform native (Android/iOS).

### AI Disclosure

Saya tidak menggunakan AI untuk pengerjaan Tugas Individu 7