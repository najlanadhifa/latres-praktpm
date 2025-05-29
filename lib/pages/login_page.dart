// import yg dibutuhin
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import 'restaurant_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controller buat input username & password
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // flag loading pas login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC72C), 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24), // jarak sekeliling
            child: Container(
              padding: const EdgeInsets.all(32), // isi card
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6), // bayangan ke bawah
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // biar ngikut isi
                  children: [
                    const Icon(
                      Icons.lunch_dining,
                      size: 72,
                      color: Color(0xFF502314),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Restaurant',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF502314),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selamat datang! Ayo makan.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF502314),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // input username
                    _buildTextField(
                      controller: _usernameController,
                      hint: 'Username',
                      icon: Icons.person,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    // input password
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    // tombol login
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login, // disable pas loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE60012),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ke halaman daftar
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(
                          color: Color(0xFF502314),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget input form
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Color(0xFF502314)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFE60012)), // ikon kiri
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: const Color(0xFFFFF3E0), // bg input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please enter $hint'; // validasi kosong
        }
        return null;
      },
    );
  }

  // proses login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // cek form valid

    setState(() {
      _isLoading = true; // mulai loading
    });

    // panggil auth service
    final success = await AuthService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false; // stop loading
    });

    if (success) {
      // kalo sukses, ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RestaurantPage()),
      );
    } else {
      // kalo gagal, munculin snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    // buang controller pas widget dihapus
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
