import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locknote/services/password_service.dart';
import 'package:locknote/services/storage_service.dart';
import 'package:locknote/models/draft_model.dart';
import 'package:locknote/models/password_preferences.dart';

class GeneratePasswordScreen extends StatefulWidget {
  const GeneratePasswordScreen({Key? key}) : super(key: key);

  @override
  State<GeneratePasswordScreen> createState() => _GeneratePasswordScreenState();
}

class _GeneratePasswordScreenState extends State<GeneratePasswordScreen> {
  String _generatedPassword = '';
  PasswordPreferences _preferences = PasswordPreferences();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final preferences = await StorageService.loadPasswordPreferences();
      setState(() {
        _preferences = preferences;
      });
      _generatePassword();
    } catch (e) {
      print('Error loading preferences: $e');
      _generatePassword();
    }
  }

  void _generatePassword() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate a small delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      final password = PasswordService.generatePassword(_preferences);
      setState(() {
        _generatedPassword = password;
        _isLoading = false;
      });
    });
  }

  Future<void> _copyPassword() async {
    if (_generatedPassword.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _generatedPassword));
      
      // Save to drafts
      final draft = Draft(
        password: _generatedPassword,
        createdAt: DateTime.now(),
      );
      
      try {
        final drafts = await StorageService.loadDrafts();
        drafts.insert(0, draft); // Add to beginning of list
        await StorageService.saveDrafts(drafts);
      } catch (e) {
        print('Error saving draft: $e');
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password copied and saved to drafts',
              style: GoogleFonts.urbanist(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _togglePreference(String type) {
    setState(() {
      switch (type) {
        case 'lowercase':
          _preferences.includeLowercase = !_preferences.includeLowercase;
          break;
        case 'numbers':
          _preferences.includeNumbers = !_preferences.includeNumbers;
          break;
        case 'uppercase':
          _preferences.includeUppercase = !_preferences.includeUppercase;
          break;
        case 'symbols':
          _preferences.includeSymbols = !_preferences.includeSymbols;
          break;
      }
    });
    _generatePassword();
    _savePreferences();
  }

  void _updateLength(double length) {
    setState(() {
      _preferences.length = length.round();
    });
    _generatePassword();
    _savePreferences();
  }

  Future<void> _savePreferences() async {
    try {
      await StorageService.savePasswordPreferences(_preferences);
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, 'refresh'),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Generate Password',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Password Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.black, Color(0xFF004D40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: Colors.cyanAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Password',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _generatedPassword,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Preferences Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Preferences',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Preference Options
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // First row - Lowercase and Numbers
                      Row(
                        children: [
                          Expanded(
                            child: _buildPreferenceOption(
                              'ab',
                              'Lowercase',
                              _preferences.includeLowercase,
                              () => _togglePreference('lowercase'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildPreferenceOption(
                              '123',
                              'Numbers',
                              _preferences.includeNumbers,
                              () => _togglePreference('numbers'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Second row - Uppercase and Symbols
                      Row(
                        children: [
                          Expanded(
                            child: _buildPreferenceOption(
                              'AB',
                              'Uppercase',
                              _preferences.includeUppercase,
                              () => _togglePreference('uppercase'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildPreferenceOption(
                              '#\$',
                              'Symbols',
                              _preferences.includeSymbols,
                              () => _togglePreference('symbols'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Password Length Section
                Text(
                  'Password Length',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.black,
                          overlayColor: Colors.black.withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _preferences.length.toDouble(),
                          min: 4,
                          max: 15,
                          divisions: 46,
                          onChanged: _updateLength,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${_preferences.length} Characters',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generatePassword,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.cyanAccent,
                      size: 18,
                    ),
                    label: Text(
                      'Regenerate',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _copyPassword,
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                      size: 18,
                    ),
                    label: Text(
                      'Copy Password',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Add some bottom padding to ensure content is not cut off
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceOption(String icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 255, 255),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}