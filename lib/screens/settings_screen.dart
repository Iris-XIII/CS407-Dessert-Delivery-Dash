import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFB6C1);
    const lilac = Color(0xFFB39DDB); // soft purple

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background — match your bakery aesthetic
          Image.asset(
            'assets/images/StartPage.jpeg', // change to your image
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                constraints: BoxConstraints(
                  // Max height so it never overflows
                  maxHeight: MediaQuery.of(context).size.height * 0.90,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                // ✅ Make contents scroll if needed
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ✅ Tighter Title
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            "Settings",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          _PinkIconButton(
                            icon: Icons.home,
                            onPressed: () => Navigator.pushNamed(context, '/starting'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // ✅ Tighter toggles
                      _SettingToggle(label: "Background Music"),
                      _SettingToggle(label: "Haptics"),
                      _SettingToggle(label: "Dark Mode"),

                      const SizedBox(height: 6),

                      // ✅ Compressed Volume row
                      const Text(
                        "Volume",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Color(0xFFB39DDB),
                          activeTrackColor: Color(0xFFB39DDB).withOpacity(0.8),
                          inactiveTrackColor: Color(0xFFB39DDB).withOpacity(0.3),
                        ),
                        child: Slider(
                          value: 0.6,
                          onChanged: (v) {},
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ✅ shorter bottom row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Manage Account",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // profile button
                          _PinkIconButton(
                              icon: Icons.person,
                              onPressed: () => Navigator.pushNamed(context, '/profile'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context,
      String text,
      VoidCallback onPressed,
      {double fontSize = 32} // Default font size is 32, can be overridden
      ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.transparent,
        overlayColor: const Color(0x33F2F2F2), // Slight overlay on press
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Caveat',
          fontSize: fontSize, // Use the parameter
          fontWeight: FontWeight.bold,
          color: Color(0xFF424658),
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final String label;
  const _SettingToggle({required this.label});

  @override
  Widget build(BuildContext context) {
    const lilac = Color(0xFFB39DDB);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Switch(
            value: true,
            activeColor: lilac,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) {},
          )
        ],
      ),
    );
  }
}

class _PinkIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _PinkIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,     // ✅ Pink box height SMALLER
      width: 42,      // ✅ Pink box width SMALLER
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1).withOpacity(.75),
        borderRadius: BorderRadius.circular(6), // ✅ smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 22,                 // ✅ tiny icon to match smaller box
        padding: EdgeInsets.zero,     // ✅ no extra padding
        onPressed: onPressed,
        constraints: const BoxConstraints(), // ✅ no minimum size inflation
      ),
    );
  }
}
