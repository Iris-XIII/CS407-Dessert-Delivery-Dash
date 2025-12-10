import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/player.dart';
import '../services/progress_repository.dart';

const List<String> _gameAvatars = [
  'assets/images/Bear.png',
  'assets/images/Deer.png',
  'assets/images/Fairy.png',
  'assets/images/Female Elf.png',
  'assets/images/Fox.png',
  'assets/images/Frog.png',
  'assets/images/Gnome.png',
  'assets/images/Owl.png',
  'assets/images/Panda.png',
  'assets/images/Raccoon.png',
  'assets/images/Squirel.png',
  'assets/images/Wizard.png'
];

class ProfileScreen extends StatefulWidget {
  final Player player;

  const ProfileScreen({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isEditing = false;
  String? _profilePhotoPath;

  bool isLogin = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = _auth.currentUser;
    if (user != null) {
      _usernameController.text = user.displayName ?? 'New User';
      _profilePhotoPath = user.photoURL ?? 'assets/images/profile_avatar.png';
      _bioController.text = 'A short bio about me.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePhotoPath = pickedFile.path;
      });

      // Save immediately when image is picked
      await _saveAvatarToFirebase(pickedFile.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image selected and saved!")),
      );
    }
  }

  Future<void> _saveAvatarToFirebase(String avatarPath) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // For asset avatars (game avatars), save the path directly
        // For gallery images, you would need to upload to Firebase Storage
        // For now, we'll just save asset paths
        if (avatarPath.startsWith('assets/')) {
          await user.updatePhotoURL(avatarPath);
          debugPrint('Avatar saved to Firebase: $avatarPath');
        }
      }
    } catch (e) {
      debugPrint('Error saving avatar: $e');
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Import from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Choose a Game Avatar:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _gameAvatars.length,
                  itemBuilder: (context, index) {
                    final assetPath = _gameAvatars[index];
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          _profilePhotoPath = assetPath;
                        });
                        Navigator.of(context).pop();

                        // Save the selected game avatar to Firebase
                        await _saveAvatarToFirebase(assetPath);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Avatar updated!")),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: Image.asset(assetPath, height: 40),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitAuthForm() async {
    setState(() => isLoading = true);
    try {
      User? user;
      if (isLogin) {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        user = userCredential.user;
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        user = userCredential.user;
        await user?.updateDisplayName(_emailController.text.split('@').first);
        // Set default avatar for new users
        await user?.updatePhotoURL('assets/images/profile_avatar.png');
      }

      if (user != null) {
        setState(() {
          _usernameController.text = user?.displayName ?? 'New User';
          _profilePhotoPath = user?.photoURL ?? 'assets/images/profile_avatar.png';
          _bioController.text = 'A short bio about me.';
        });

        // After successful login, navigate back to starting page to reload progress
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful! Reloading progress...")),
          );

          // Navigate to starting page and clear navigation stack
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/starting',
                (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication failed")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveProfileEdits() async {
    setState(() => isLoading = true);
    final user = _auth.currentUser;

    if (user != null) {
      try {
        // Save username
        await user.updateDisplayName(_usernameController.text.trim());

        // Avatar is already saved when selected, but save again to be safe
        if (_profilePhotoPath != null) {
          await user.updatePhotoURL(_profilePhotoPath);
        }

        // Reload user to get updated info
        await user.reload();
        final updatedUser = _auth.currentUser;

        if (updatedUser != null) {
          setState(() {
            _usernameController.text = updatedUser.displayName ?? 'New User';
            _profilePhotoPath = updatedUser.photoURL;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );

        setState(() {
          _isEditing = false;
        });
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: $e")),
        );
      }
    }
    setState(() => isLoading = false);
  }

  Widget _buildAuthForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_emailFocusNode.hasFocus) _emailFocusNode.requestFocus();
    });

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? 'Log In' : 'Sign Up',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submitAuthForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB6C1),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12),
              ),
              child: Text(
                isLogin ? 'Log In' : 'Sign Up',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? "Don't have an account? Sign up"
                    : "Already have an account? Log in",
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getAvatarProvider(String? path) {
    if (path == null) {
      return const AssetImage('assets/images/profile_avatar.png');
    }

    if (path.startsWith('http')) {
      return NetworkImage(path);
    }

    if (path.startsWith('/data') || path.startsWith('file://')) {
      return FileImage(File(path));
    }
    return AssetImage(path);
  }

  Widget _buildEditableAvatar({required bool isEditing, required String? photoPath, required VoidCallback onTap}) {
    const double avatarRadius = 40;

    return GestureDetector(
      onTap: isEditing ? onTap : null,
      child: Stack(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: const Color(0xFFFFB6C1),
            backgroundImage: _getAvatarProvider(photoPath),
            child: photoPath == null
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),

          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB6C1),
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(User user) {
    const TextStyle labelStyle = TextStyle(fontSize: 18, color: Color(0xFF8B6F8F));
    const TextStyle valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditableAvatar(
                      isEditing: _isEditing,
                      photoPath: _profilePhotoPath,
                      onTap: _showImageSourceSheet,
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isEditing
                              ? SizedBox(
                            height: 35,
                            child: TextField(
                              controller: _usernameController,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: 'Enter Username',
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                errorStyle: const TextStyle(height: 0),
                              ),
                            ),
                          )
                              : Text(
                            user.displayName ?? 'New User',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Money: \$${widget.player.money}',
                            style: valueStyle.copyWith(color: const Color(0xFF87D68D)),
                          ),

                          Text(
                            'Day: ${widget.player.day} • Level: ${widget.player.level}',
                            style: labelStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _isEditing
                  ? isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveProfileEdits,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87D68D),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
              )
                  : ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  setState(() {
                    _profilePhotoPath = null;
                    _usernameController.text = '';
                  });

                  // Navigate back to starting screen and clear navigation stack
                  // This ensures player data gets reset when the starting screen initializes
                  if (mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/starting',
                          (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Log Out", style: TextStyle(color: Colors.white)),
              ),

              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB6C1),
                  ),
                  child: const Text("Back to Home")
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFFFB6C1),
        actions: user != null
            ? [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfileEdits();
              } else {
                setState(() {
                  _usernameController.text = user.displayName ?? 'New User';
                  _isEditing = true;
                });
              }
            },
          ),
        ]
            : null,
      ),
      body: user == null ? _buildAuthForm() : _buildProfileInfo(user),
    );
  }
}