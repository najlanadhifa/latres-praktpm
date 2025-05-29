import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controller buat input form
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // key buat validasi form
  final _formKey = GlobalKey<FormState>();

  // buat handle loading pas register
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC72C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(32),
              // box putih dgn shadow dan radius
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // icon orang tambah di atas form
                    const Icon(
                      Icons.person_add,
                      size: 72,
                      color: Color(0xFF502314),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF502314),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // subjudul
                    const Text(
                      'Buat akun Anda',
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
                    const SizedBox(height: 16),
                    // input konfirmasi password
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hint: 'Konfirmasi Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    // tombol daftar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
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
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // link ke halaman login
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Sudah punya akun? Masuk',
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

  // widget bantu buat input field
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
        prefixIcon: Icon(icon, color: const Color(0xFFE60012)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: const Color(0xFFFFF3E0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        // validasi form biar ga kosong
        if (value == null || value.isEmpty) {
          return 'Silakan isi $hint';
        }

        // validasi username min 3 huruf
        if (hint == 'Username' && value.length < 3) {
          return 'Username minimal terdiri dari 3 karakter';
        }

        // validasi password min 6 huruf
        if ((hint == 'Password' || hint == 'Confirm Password') &&
            value.length < 6) {
          return 'Password minimal terdiri dari 6 karakter';
        }

        // validasi konfirmasi password harus sama
        if (hint == 'Confirm Password' && value != _passwordController.text) {
          return 'Password tidak cocok';
        }

        return null;
      },
    );
  }

  // fungsi buat handle proses register
  Future<void> _register() async {
    // cek validasi form dlu
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // panggil auth service buat register
    final success = await AuthService.register(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    // kalo berhasil, kasih notifikasi hijau & balik ke login
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      // kalo gagal, notif merah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username sudah digunakan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // bersihin controller biar ga memory leak
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
