import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locknote/models/credential_model.dart';
import 'package:locknote/services/storage_service.dart';
import 'edit_credential_screen.dart'; // Add this import

class ViewCredentialScreen extends StatefulWidget {
  final Credential credential;

  const ViewCredentialScreen({
    Key? key,
    required this.credential,
  }) : super(key: key);

  @override
  State<ViewCredentialScreen> createState() => _ViewCredentialScreenState();
}

class _ViewCredentialScreenState extends State<ViewCredentialScreen> {
  bool _isPasswordVisible = false;
  late Credential _credential;

  @override
  void initState() {
    super.initState();
    _credential = widget.credential;
  }

  void _copyToClipboard(String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$fieldName copied to clipboard',
          style: GoogleFonts.urbanist(),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteCredential() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Credential',
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this credential? This action cannot be undone.',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.urbanist(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await StorageService.deleteCredential(_credential.id);
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, 'deleted'); // Return to vault with result
                }
              },
              child: Text(
                'Delete',
                style: GoogleFonts.urbanist(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Header Banner
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.black, Color(0xFF004D40)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
                ),
              ),
              margin: EdgeInsets.only(top: 10, right: 16, left: 16, bottom: 16),
              child: Stack(
                children: [
                  // App logo and name
                  Positioned(
                    top: 15,
                    left: 24,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '*',
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lock-Note',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Title and subtitle
                  Positioned(
                    bottom: 40,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_credential.platform}',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Credentials',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Memory is Great But',
                          style: GoogleFonts.urbanist(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.urbanist(fontSize: 10),
                            children: const [
                              TextSpan(
                                text: 'Locknote',
                                style: TextStyle(color: Colors.cyanAccent),
                              ),
                              TextSpan(
                                text: ' is Better....',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Phone illustration
                  Positioned(
                    right: 3,
                    top: 5,
                    child: Container(
                      width: 240,
                      height: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/images/iPhone 15.png',
                        width: 240,
                        height: 230,
                    ),
                  ),
                  ),
                ],
              ),
            ),
            
            // Credential Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _buildCredentialField(
                            'Platform Name',
                            _credential.platform,
                            'Platform',
                          ),
                          
                          if (_credential.email != 'N/A') ...[
                            const SizedBox(height: 24),
                            _buildCredentialField(
                              'Username',
                              _credential.email.contains('@') ? _credential.email.split('@')[0] : _credential.email,
                              'Username',
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          _buildPasswordField(),
                          
                          if (_credential.email != 'N/A' && _credential.email.contains('@')) ...[
                            const SizedBox(height: 24),
                            _buildCredentialField(
                              'Email Address',
                              _credential.email,
                              'Email',
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          _buildCredentialField(
                            'Website',
                            'www.${_credential.platform.toLowerCase()}.com',
                            'Website',
                          ),
                          
                          const SizedBox(height: 24),
                          _buildNotesField(),
                        ],
                      ),
                    ),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Navigate to edit screen
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCredentialScreen(credential: _credential),
                                ),
                              );
                              
                              // If credential was updated, reload credential data and refresh parent
                              if (result == 'updated') {
                                // Reload the credential from storage to get updated data
                                try {
                                  final credentials = await StorageService.loadCredentials();
                                  final updatedCredential = credentials.firstWhere(
                                    (cred) => cred.id == _credential.id,
                                    orElse: () => _credential, // fallback to current if not found
                                  );
                                  
                                  setState(() {
                                    _credential = updatedCredential;
                                  });
                                  
                                  // Return to vault with updated result so it can refresh too
                                  if (mounted) {
                                    Navigator.pop(context, 'updated');
                                  }
                                } catch (e) {
                                  // If there's an error loading, just go back with updated result
                                  if (mounted) {
                                    Navigator.pop(context, 'updated');
                                  }
                                }
                              }
                            },
                            icon: const Icon(Icons.edit, size: 20),
                            label: Text(
                              'Edit Credentials',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.cyanAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _deleteCredential,
                            icon: const Icon(Icons.delete_outline, size: 20),
                            label: Text(
                              'Delete Credential',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 241, 240),
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialField(String label, String value, String copyLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _copyToClipboard(value, copyLabel),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Copy',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    _isPasswordVisible ? _credential.password : '••••••••',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _copyToClipboard(_credential.password, 'Password'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Copy',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // MODIFIED: Updated to display actual notes from credential
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Notes',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Show copy button only if there are notes
            if (_credential.notes.isNotEmpty)
              GestureDetector(
                onTap: () => _copyToClipboard(_credential.notes, 'Notes'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Copy',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.copy,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _credential.notes.isEmpty ? 'No notes added' : _credential.notes,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: _credential.notes.isEmpty ? Colors.grey[400] : Colors.black,
            height: 1.5,
            fontStyle: _credential.notes.isEmpty ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}