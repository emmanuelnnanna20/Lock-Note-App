import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locknote/models/credential_model.dart';
import 'package:locknote/services/storage_service.dart';
import 'dart:math';

class EditCredentialScreen extends StatefulWidget {
  final Credential credential;

  const EditCredentialScreen({Key? key, required this.credential}) : super(key: key);

  @override
  State<EditCredentialScreen> createState() => _EditCredentialScreenState();
}

class _EditCredentialScreenState extends State<EditCredentialScreen> {
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  late CredentialCategory _selectedCategory;
  bool _isPasswordVisible = false;
  bool _showEmailField = false;
  bool _showUsernameField = false;
  bool _showWebsiteField = false;
  bool _showNoteField = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    // Pre-fill all fields with existing credential data
    _platformController.text = widget.credential.platform;
    _passwordController.text = widget.credential.password;
    _selectedCategory = widget.credential.category;
    
    // Handle email field
    if (widget.credential.email != 'N/A' && widget.credential.email.isNotEmpty) {
      _emailController.text = widget.credential.email;
      _showEmailField = true;
    }
    
    // Handle notes field
    if (widget.credential.notes.isNotEmpty) {
      _noteController.text = widget.credential.notes;
      _showNoteField = true;
    }
    
    // For now, we'll show username and website fields if email is present
    // You can modify this logic based on your requirements
    if (widget.credential.email != 'N/A' && widget.credential.email.isNotEmpty) {
      if (widget.credential.email.contains('@')) {
        _usernameController.text = widget.credential.email.split('@')[0];
        _showUsernameField = true;
      }
      _websiteController.text = 'www.${widget.credential.platform.toLowerCase()}.com';
      _showWebsiteField = true;
    }
  }

  @override
  void dispose() {
    _platformController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _websiteController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final Random random = Random();
    String password = '';
    
    for (int i = 0; i < 12; i++) {
      password += chars[random.nextInt(chars.length)];
    }
    
    setState(() {
      _passwordController.text = password;
    });
  }

  void _saveCredential() async {
    if (_platformController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in required fields',
            style: GoogleFonts.urbanist(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create updated credential with the same ID but new data
    final updatedCredential = widget.credential.copyWith(
      platform: _platformController.text,
      email: _emailController.text.isNotEmpty ? _emailController.text : 'N/A',
      password: _passwordController.text,
      category: _selectedCategory,
      updatedAt: DateTime.now(),
      notes: _noteController.text,
    );

    try {
      // Update in storage
      await StorageService.updateCredential(updatedCredential);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Credential updated successfully',
              style: GoogleFonts.urbanist(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Return to previous screen with updated result
        Navigator.pop(context, 'updated');
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating credential: $e',
              style: GoogleFonts.urbanist(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Credentials',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Platform Name Field
                    _buildSectionTitle('Platform Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _platformController,
                      hintText: 'Eg. facebook',
                      prefixIcon: Icons.search,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Password'),
                        GestureDetector(
                          onTap: _generatePassword,
                          child: Text(
                            'Generate',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordField(),
                    
                    const SizedBox(height: 24),
                    
                    // Tag Field
                    _buildSectionTitle('Tag'),
                    const SizedBox(height: 8),
                    _buildCategoryDropdown(),
                    
                    const SizedBox(height: 32),
                    
                    // Additional Fields Grid
                    _buildAdditionalFieldsGrid(),
                    
                    const SizedBox(height: 24),
                    
                    // Dynamic Fields
                    if (_showEmailField) ...[
                      const SizedBox(height: 16),
                      _buildDynamicField(
                        'Email',
                        _emailController,
                        'Enter email address',
                        Icons.email_outlined,
                        onRemove: () => setState(() {
                          _showEmailField = false;
                          _emailController.clear();
                        }),
                      ),
                    ],
                    
                    if (_showUsernameField) ...[
                      const SizedBox(height: 16),
                      _buildDynamicField(
                        'Username',
                        _usernameController,
                        'Enter username',
                        Icons.person_outline,
                        onRemove: () => setState(() {
                          _showUsernameField = false;
                          _usernameController.clear();
                        }),
                      ),
                    ],
                    
                    if (_showWebsiteField) ...[
                      const SizedBox(height: 16),
                      _buildDynamicField(
                        'Website Link',
                        _websiteController,
                        'Enter website URL',
                        Icons.link,
                        onRemove: () => setState(() {
                          _showWebsiteField = false;
                          _websiteController.clear();
                        }),
                      ),
                    ],
                    
                    if (_showNoteField) ...[
                      const SizedBox(height: 16),
                      _buildDynamicField(
                        'Note',
                        _noteController,
                        'Enter note',
                        Icons.note_outlined,
                        maxLines: 3,
                        onRemove: () => setState(() {
                          _showNoteField = false;
                          _noteController.clear();
                        }),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Save Button
            Container(
              width: double.infinity,
              height: 56,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: _saveCredential,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.cyanAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Credentials',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.urbanist(
            color: Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: GoogleFonts.urbanist(
            color: Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<CredentialCategory>(
        value: _selectedCategory,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
        items: CredentialCategory.values.map((category) {
          return DropdownMenuItem<CredentialCategory>(
            value: category,
            child: Text(
              category.displayName,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedCategory = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildAdditionalFieldsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAddFieldButton(
                'Add Email Credential',
                Icons.add,
                isEnabled: !_showEmailField,
                onTap: () => setState(() => _showEmailField = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAddFieldButton(
                'Add Note',
                Icons.add,
                isEnabled: !_showNoteField,
                onTap: () => setState(() => _showNoteField = true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAddFieldButton(
                'Add Username',
                Icons.add,
                isEnabled: !_showUsernameField,
                onTap: () => setState(() => _showUsernameField = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAddFieldButton(
                'Add Website Link',
                Icons.add,
                isEnabled: !_showWebsiteField,
                onTap: () => setState(() => _showWebsiteField = true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddFieldButton(String text, IconData icon, {required bool isEnabled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFE0F7FA) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isEnabled ? Colors.black : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicField(
    String label,
    TextEditingController controller,
    String hintText,
    IconData icon, {
    int maxLines = 1,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(label),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: controller,
          hintText: hintText,
          prefixIcon: icon,
          maxLines: maxLines,
        ),
      ],
    );
  }
}