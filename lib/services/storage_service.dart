import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locknote/models/credential_model.dart';
import 'package:locknote/models/draft_model.dart';
import 'package:locknote/models/password_preferences.dart';

class StorageService {
  static const String _credentialsKey = 'saved_credentials';
  static const String _draftsKey = 'password_drafts';
  static const String _passwordPreferencesKey = 'password_preferences';
  
  // ===== CREDENTIAL METHODS (existing) =====
  
  // Save credentials to storage
  static Future<void> saveCredentials(List<Credential> credentials) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert credentials to JSON
    List<Map<String, dynamic>> credentialsJson = credentials.map((credential) => {
      'id': credential.id,
      'platform': credential.platform,
      'email': credential.email,
      'password': credential.password,
      'category': credential.category.index, // Save as index
      'createdAt': credential.createdAt.toIso8601String(),
      'updatedAt': credential.updatedAt.toIso8601String(),
      'notes': credential.notes, // Added notes field
    }).toList();
    
    // Save to SharedPreferences
    await prefs.setString(_credentialsKey, jsonEncode(credentialsJson));
  }
  
  // Load credentials from storage
  static Future<List<Credential>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final String? credentialsString = prefs.getString(_credentialsKey);
    
    if (credentialsString == null) {
      return []; // Return empty list if no data
    }
    
    try {
      List<dynamic> credentialsJson = jsonDecode(credentialsString);
      
      return credentialsJson.map((json) => Credential(
        id: json['id'],
        platform: json['platform'],
        email: json['email'],
        password: json['password'],
        category: CredentialCategory.values[json['category']],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        notes: json['notes'] ?? '', // Handle missing notes field for backward compatibility
      )).toList();
    } catch (e) {
      print('Error loading credentials: $e');
      return [];
    }
  }
  
  // Add a single credential
  static Future<void> addCredential(Credential credential) async {
    List<Credential> credentials = await loadCredentials();
    credentials.add(credential);
    await saveCredentials(credentials);
  }
  
  // Update a credential
  static Future<void> updateCredential(Credential updatedCredential) async {
    List<Credential> credentials = await loadCredentials();
    int index = credentials.indexWhere((cred) => cred.id == updatedCredential.id);
    
    if (index != -1) {
      credentials[index] = updatedCredential;
      await saveCredentials(credentials);
    }
  }
  
  // Delete a credential
  static Future<void> deleteCredential(String credentialId) async {
    List<Credential> credentials = await loadCredentials();
    credentials.removeWhere((cred) => cred.id == credentialId);
    await saveCredentials(credentials);
  }
  
  // Clear all credentials (useful for testing)
  static Future<void> clearAllCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }
  
  // ===== DRAFT METHODS (new) =====
  
  // Save drafts to storage
  static Future<void> saveDrafts(List<Draft> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert drafts to JSON
    List<Map<String, dynamic>> draftsJson = drafts.map((draft) => draft.toJson()).toList();
    
    // Save to SharedPreferences
    await prefs.setString(_draftsKey, jsonEncode(draftsJson));
  }
  
  // Load drafts from storage
  static Future<List<Draft>> loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? draftsString = prefs.getString(_draftsKey);
    
    if (draftsString == null) {
      return []; // Return empty list if no data
    }
    
    try {
      List<dynamic> draftsJson = jsonDecode(draftsString);
      return draftsJson.map((json) => Draft.fromJson(json)).toList();
    } catch (e) {
      print('Error loading drafts: $e');
      return [];
    }
  }
  
  // Add a single draft
  static Future<void> addDraft(Draft draft) async {
    List<Draft> drafts = await loadDrafts();
    drafts.insert(0, draft); // Add to beginning of list
    await saveDrafts(drafts);
  }
  
  // Delete a draft
  static Future<void> deleteDraft(int index) async {
    List<Draft> drafts = await loadDrafts();
    if (index >= 0 && index < drafts.length) {
      drafts.removeAt(index);
      await saveDrafts(drafts);
    }
  }
  
  // Clear all drafts
  static Future<void> clearAllDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftsKey);
  }
  
  // ===== PASSWORD PREFERENCES METHODS (new) =====
  
  // Save password preferences
  static Future<void> savePasswordPreferences(PasswordPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordPreferencesKey, jsonEncode(preferences.toJson()));
  }
  
  // Load password preferences
  static Future<PasswordPreferences> loadPasswordPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? preferencesString = prefs.getString(_passwordPreferencesKey);
    
    if (preferencesString == null) {
      // Return default preferences if none exist
      return PasswordPreferences();
    }
    
    try {
      Map<String, dynamic> preferencesJson = jsonDecode(preferencesString);
      return PasswordPreferences.fromJson(preferencesJson);
    } catch (e) {
      print('Error loading password preferences: $e');
      return PasswordPreferences(); // Return default on error
    }
  }
  
  // Clear password preferences (reset to default)
  static Future<void> clearPasswordPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_passwordPreferencesKey);
  }
}