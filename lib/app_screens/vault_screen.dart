// Models
// Main Vault Screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locknote/app_screens/add_credentials_screen.dart';
import 'package:locknote/app_screens/draft_screen.dart';
import 'package:locknote/app_screens/generate_screen.dart';
import 'package:locknote/app_screens/settings_screen.dart';
import 'package:locknote/models/credential_model.dart';


class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data
  final List<Credential> _credentials = [
    Credential(
      id: '1',
      platform: 'Instagram',
      email: 'okosolarry@gmail.com',
      password: 'password123',
      category: CredentialCategory.personal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Credential(
      id: '2',
      platform: 'Facebook',
      email: 'okosolarry@gmail.com',
      password: 'password123',
      category: CredentialCategory.social,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Credential(
      id: '3',
      platform: 'Facebook',
      email: 'okosolarry@gmail.com',
      password: 'password123',
      category: CredentialCategory.personal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Credential(
      id: '4',
      platform: 'Facebook',
      email: 'okosolarry@gmail.com',
      password: 'password123',
      category: CredentialCategory.personal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Credential(
      id: '5',
      platform: 'Facebook',
      email: 'okosolarry@gmail.com',
      password: 'password123',
      category: CredentialCategory.personal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  List<Credential> get _filteredCredentials {
    List<Credential> filtered = _credentials;
    
    // Apply filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((cred) => 
        cred.category.displayName == _selectedFilter).toList();
    }
    // Apply search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((cred) =>
        cred.platform.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        cred.email.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _currentIndex == 0
          ? _buildVaultContent()
          : _currentIndex == 1
            ? const GenerateScreen()
            : const SettingsScreen(),
      ),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCredentialScreen()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.cyanAccent, size: 30),
      ) : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0 ? Icons.lock_reset_rounded : Icons.lock_reset_rounded),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1 ? Icons.cloud_sync_outlined : Icons.cloud_sync_outlined),
              label: 'Generate',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 2 ? Icons.settings : Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaultContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:  Center(
                  child: Text(
                    '*',
                    style: GoogleFonts.urbanist(
                      fontSize: 60,
                      fontWeight: FontWeight.w800,
                      color: Colors.cyanAccent,
                    ),
                  )
                ),

              ),

              SizedBox(width: 10,),
              Text(
                'Lock-Note',
                  style: GoogleFonts.urbanist(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.urbanist(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Banner Card
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF004D40)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Your Memory is great, But',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Locknote',
                              style: TextStyle(color: Colors.cyanAccent),
                            ),
                            TextSpan(
                              text: ' Is Better....',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Placeholder for phone image
                Positioned(
                  right: 0,
                  top: 20,
                  bottom: 0,
                  child: Container(
                    width: 185,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/iPhone 15.png',
                        width: 185,
                        height: 200,
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Filter Tabs
          Row(
            children: [
              _buildFilterTab('All', _selectedFilter == 'All'),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DraftsScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Drafts',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Credentials List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCredentials.length,
              itemBuilder: (context, index) {
                final credential = _filteredCredentials[index];
                return _buildCredentialItem(credential);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isSelected ? Colors.cyanAccent : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialItem(Credential credential) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  credential.platform,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  credential.email,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: credential.category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: credential.category.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  size: 12,
                  color: credential.category.color,
                ),
                const SizedBox(width: 4),
                Text(
                  credential.category.displayName,
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    color: credential.category.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}