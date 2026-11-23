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

#### AI Disclosure
Saya tidak menggunakan AI untuk pengerjaan Tugas Individu 7

### Tugas 8

1. Perbedaan Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop()
Navigator.push() menambahkan rute baru di atas tumpukan (stack) rute. Halaman sebelumnya tetap tersimpan di bawahnya, sehingga pengguna bisa kembali ke halaman tersebut.
Navigator.pushReplacement() membuka rute baru sekaligus menggantikan rute yang sedang aktif. Halaman lama dibuang dari stack, jadi tidak bisa dibuka lagi lewat tombol kembali.
Navigator.pop() mengeluarkan rute teratas dari stack sehingga tampilan kembali ke rute di bawahnya. Metode ini juga dapat mengembalikan sebuah nilai ke halaman sebelumnya.
Untuk membuka formulir dari kartu aksi, saya memakai Navigator.push(). Dengan begitu halaman utama tetap ada di stack dan pengguna dapat kembali memakai tombol kembali bawaan perangkat. Opsi Home di drawer memakai Navigator.pushReplacement() ke MyHomePage. Halaman formulir yang sedang aktif digantikan oleh halaman utama, sehingga pengguna langsung tiba di halaman utama tanpa menumpuk halaman formulir di stack. Alur ini juga yang saya pakai untuk menguji navigasi kembali di Chrome, karena di browser tidak ada tombol kembali bawaan perangkat.

2. Peran Scaffold, AppBar, dan Drawer dalam menjaga struktur halaman Scaffold menyediakan kerangka standar halaman Material: appBar di bagian atas, drawer untuk menu samping, dan body untuk isi. Karena setiap halaman (halaman utama dan halaman formulir) memakai kerangka yang sama, posisi judul, tombol menu, dan area konten selalu konsisten, sehingga pengguna tidak perlu beradaptasi ulang saat berpindah halaman. Drawer dibuat sebagai satu widget terpisah (lib/widgets/) yang dipakai ulang di semua halaman, jadi daftar menu (Home, Add Project, dan opsi formulir baru) selalu sama dan perubahan cukup dilakukan di satu tempat. Contoh penggunaan warna tema di lebih dari satu halaman: warna utama portofolio ([ISI: warna yang dipakai, mis. Colors.indigo]) didefinisikan sekali di ThemeData pada main.dart, lalu dipakai lewat Theme.of(context).colorScheme.primary pada AppBar halaman utama, AppBar halaman formulir, DrawerHeader, dan tombol Simpan. Dengan begitu tampilan antarhalaman seragam, dan jika warna tema diganti, semua halaman ikut berubah.

3. Alasan pemilihan tata letak formulir, serta peran widget jarak dan widget penggulir Formulir saya susun dengan Scaffold → SingleChildScrollView → Padding → Form → Column, dengan semua input dan tombol Simpan berada di dalam Column. Susunan vertikal ini cocok untuk formulir karena setiap input mudah dibaca dari atas ke bawah dan lebar kolom menyesuaikan lebar layar.
- Padding memberi ruang di tepi layar agar input tidak menempel ke sisi layar.
- SizedBox memberi jarak vertikal antarinput dan sebelum tombol Simpan, sehingga pesan kesalahan dan label tetap terbaca jelas.
- SingleChildScrollView membuat seluruh isi formulir dapat digulir. Pada layar sempit atau saat papan ketik tampil dan memakan sebagian tinggi layar, isi yang tidak muat tidak menyebabkan RenderFlex overflow, dan pengguna tetap bisa menggulir ke bawah untuk menjangkau input terakhir serta tombol Simpan.

4. Peran GlobalKey<FormState>, validator, dan validate()
- GlobalKey<FormState> dipasang pada widget Form sebagai pengenal. Lewat key ini, tombol Simpan (yang berada di luar TextFormField) bisa mengakses FormState milik Form dengan _formKey.currentState.
- validator adalah fungsi pada setiap TextFormField yang menerima nilai input dan mengembalikan null jika valid atau String berisi pesan kesalahan jika tidak valid.
- validate() dipanggil saat tombol Simpan ditekan. Fungsi ini menjalankan seluruh validator, menampilkan pesan kesalahan pada kolom yang bermasalah, dan mengembalikan true hanya jika semua input valid. Dialog ringkasan hanya ditampilkan jika hasilnya true.

#### AI Disclosure

Saya menggunakan AI assistant melalui Copilot di VS Code dan Claude sebagai pendamping selama pengerjaan Tugas 8. Saya memberikan PDF tugas dan meminta bantuan dengan batasan yang spesifik: memenuhi checklist implementasi saja, tanpa mengerjakan README/refleksi sebelum diminta. AI membantu membuat formulir Pendidikan, validasi input, dialog ringkasan, integrasi kartu aksi dan drawer, serta test widget untuk alur navigasi dan form.

Saya menggunakan AI secara bertahap: meminta implementasi berdasarkan checklist, lalu menjalankan `flutter analyze` dan `flutter test` untuk memeriksa hasilnya. Ketika test menemukan masalah interaksi atau layout, saya meminta penyesuaian dan menjalankan test kembali. AI dapat membuat asumsi atau menghasilkan kode yang belum sesuai dengan perilaku aplikasi, sehingga saran dan hasilnya tetap perlu diperiksa terhadap instruksi tugas dan diverifikasi dengan tool proyek. Keputusan fitur Pendidikan sebagai bagian portofolio yang dipilih serta pemeriksaan akhir tetap menjadi tanggung jawab saya.
