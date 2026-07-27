import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => VpnProvider(),
      child: const KrugerVpnApp(),
    ),
  );
}

// ==========================================
// ENUMS & MODELS
// ==========================================

enum AppLanguage { burmese, english }

enum AppThemeMode { light, dark, system }

enum ClientVpnState { disconnected, connecting, connected }

class VpsNode {
  final String id;
  final String name;
  final String provider;
  final String location;
  final String country;
  final int priority;
  final String ruleBurmese;
  final String ruleEnglish;
  final String ip;
  final int port;
  final String publicKey;
  final String endpoint;
  final double pingMs;

  VpsNode({
    required this.id,
    required this.name,
    required this.provider,
    required this.location,
    required this.country,
    required this.priority,
    required this.ruleBurmese,
    required this.ruleEnglish,
    required this.ip,
    required this.port,
    required this.publicKey,
    required this.endpoint,
    required this.pingMs,
  });
}

// ==========================================
// BILINGUAL STRINGS
// ==========================================

class AppStrings {
  final AppLanguage language;
  AppStrings(this.language);

  bool get isBurmese => language == AppLanguage.burmese;

  String get appName => isBurmese ? "ကရူဂါ VPN" : "Kruger VPN";
  String get appTagline => isBurmese ? "မူရင်း VPN အကာအကွယ်စနစ်" : "Native VPN Protection";

  String get shieldInactive => isBurmese ? "ဒိုင်း အကာအကွယ် ပိတ်ထားသည်" : "SHIELD INACTIVE";
  String get shieldConnecting => isBurmese ? "ချိတ်ဆက်နေသည်..." : "CONNECTING...";
  String get shieldActive => isBurmese ? "ဒိုင်း အကာအကွယ် ဖွင့်ထားသည်" : "SHIELD ACTIVE";

  String get subtitleDisconnected => isBurmese ? "လုံခြုံသော ချိတ်ဆက်မှုပြုလုပ်ရန် အောက်တွင် နှိပ်ပါ" : "Tap below to secure your connection";
  String get subtitleConnecting => isBurmese ? "လုံခြုံသော WireGuard တာနယ် တည်ဆောက်နေသည်..." : "Establishing secure WireGuard tunnel...";
  String get subtitleConnected => isBurmese ? "သင့်ချိတ်ဆက်မှုကို လျှို့ဝှက်ကုဒ်လုပ်ထားပြီး ကာကွယ်ထားပါသည်" : "Your connection is encrypted & protected";

  String get buttonSecureConnection => isBurmese ? "လုံခြုံစွာ ချိတ်ဆက်မည်" : "Secure Connection";
  String get buttonConnecting => isBurmese ? "ချိတ်ဆက်နေသည်..." : "Connecting...";
  String get buttonDisconnect => isBurmese ? "ချိတ်ဆက်မှု ဖြတ်မည်" : "Disconnect";

  String get activeSince => isBurmese ? "စတင် ချိတ်ဆက်ချိန်" : "ACTIVE SINCE";
  String get notConnected => isBurmese ? "ချိတ်ဆက်မထားပါ" : "Not connected";
  String get connectionLatency => isBurmese ? "ချိတ်ဆက်မှု ကြာချိန် (PING)" : "CONNECTION LATENCY";
  String get fastestServer => isBurmese ? "အမြန်ဆုံး ဆာဗာ" : "Fastest Server";

  String get vpnSettings => isBurmese ? "VPN ဆက်တင်များ" : "VPN Settings";
  String get preferencesAndNodes => isBurmese ? "ရွေးချယ်စရာများနှင့် ဂိတ်ဝေး ဆာဗာများ" : "Preferences & Gateway Nodes";
  String get themeSectionTitle => "APPEARANCE MODE / အပြင်အဆင်";
  String get modeLight => isBurmese ? "လင်းသော မုဒ်" : "Light";
  String get modeDark => isBurmese ? "မှောင်သော မုဒ်" : "Dark";
  String get modeSystem => isBurmese ? "စနစ် မုဒ်" : "System";

  String get languageSectionTitle => "LANGUAGE / ဘာသာစကား";
  String get selectGatewayLocation => isBurmese ? "ဂိတ်ဝေး တည်နေရာ ရွေးချယ်ပါ" : "SELECT GATEWAY LOCATION";
  String get protectionAndProtocol => isBurmese ? "အကာအကွယ်နှင့် ပရိုတိုကော" : "PROTECTION & PROTOCOL";

  String get killSwitchTitle => isBurmese ? "Kill Switch (အင်တာနက် ဖြတ်တောက်စနစ်)" : "Kill Switch";
  String get killSwitchDesc => isBurmese ? "VPN ပြုတ်သွားပါက ဒေတာ ထွက်မသွားအောင် တားဆီးမည်" : "Block non-VPN traffic during drops";

  String get autoConnectTitle => isBurmese ? "အလိုအလျောက် ချိတ်ဆက်မှု" : "Auto-Connect Wi-Fi";
  String get autoConnectDesc => isBurmese ? "မယုံကြည်ရသော Wi-Fi တွင် အလိုအလျောက် ကာကွယ်မည်" : "Protect automatically on untrusted networks";

  String get encryptedDnsTitle => isBurmese ? "1.1.1.1 လျှို့ဝှက် DNS" : "1.1.1.1 Encrypted DNS";
  String get encryptedDnsDesc => isBurmese ? "DNS ယိုစိမ့်မှုနှင့် စောင့်ကြည့်ခံရမှုကို တားဆီးမည်" : "Prevent DNS leaks & domain tracking";

  String get fastapiBackendUrl => "FASTAPI BACKEND URL";
  String get apiEndpointLabel => isBurmese ? "API အဆုံးသတ် (/get-vps)" : "API Endpoint (/get-vps)";
  String get saveEndpoint => isBurmese ? "URL သိမ်းဆည်းမည်" : "Save Endpoint";

  String get wireguardConfigFile => "WIREGUARD CONFIG FILE";
  String get copyConf => isBurmese ? ".conf ကူးယူမည်" : "Copy .conf";
  String get confCopiedToast => isBurmese ? "WireGuard .conf ကို ကူးယူပြီးပါပြီ!" : "WireGuard .conf copied to clipboard!";
  String get apiUpdatedToast => isBurmese ? "API Endpoint ကို အောင်မြင်စွာ ပြင်ဆင်ပြီးပါပြီ!" : "API Endpoint updated successfully!";

  String get tabShield => isBurmese ? "ဒိုင်းကာ" : "Shield";
  String get tabSettings => isBurmese ? "ဆက်တင်များ" : "Settings";
}

// ==========================================
// STATE MANAGEMENT PROVIDER
// ==========================================

class VpnProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.burmese;
  AppThemeMode _themeMode = AppThemeMode.dark;
  ClientVpnState _vpnState = ClientVpnState.disconnected;
  
  int _durationSeconds = 0;
  Timer? _timer;

  bool killSwitch = true;
  bool autoConnect = true;
  bool encryptedDns = true;
  String apiUrl = "https://your-fastapi-backend.onrender.com/get-vps";

  final List<VpsNode> _vpsList = [
    VpsNode(
      id: "vps-1-oracle-sg",
      name: "VPS 1 (Primary)",
      provider: "Oracle Cloud Free",
      location: "Singapore",
      country: "SG",
      priority: 1,
      ruleBurmese: "အမြဲသုံးမည်",
      ruleEnglish: "Always use (Primary)",
      ip: "140.238.200.12",
      port: 51820,
      publicKey: "aB3x9Kz+L8qP2wN1mO5rT7vX8yZ0aC1bD2eE3fF4gH5=",
      endpoint: "140.238.200.12:51820",
      pingMs: 24.5,
    ),
    VpsNode(
      id: "vps-2-aws-tokyo",
      name: "VPS 2 (Secondary)",
      provider: "AWS Free Tier",
      location: "Tokyo, Japan",
      country: "JP",
      priority: 2,
      ruleBurmese: "VPS 1 မရရင် သုံးမည်",
      ruleEnglish: "Fallback if VPS 1 fails",
      ip: "54.249.120.88",
      port: 51820,
      publicKey: "fG5hJ6kL7mN8oP9qR0sT1uV2wX3yZ4aB5cC6dD7eE8f=",
      endpoint: "54.249.120.88:51820",
      pingMs: 38.2,
    ),
    VpsNode(
      id: "vps-3-gcp-taiwan",
      name: "VPS 3 (Backup)",
      provider: "Google Cloud Free",
      location: "Changhua, Taiwan",
      country: "TW",
      priority: 3,
      ruleBurmese: "VPS 1 & 2 မရရင် သုံးမည်",
      ruleEnglish: "Backup if VPS 1 & 2 fail",
      ip: "35.221.180.45",
      port: 51820,
      publicKey: "xY1zA2bC3dE4fG5hJ6kL7mN8oP9qR0sT1uV2wX3yZ4a=",
      endpoint: "35.221.180.45:51820",
      pingMs: 45.1,
    ),
  ];

  late VpsNode _activeNode;

  VpnProvider() {
    _activeNode = _vpsList.first;
  }

  AppLanguage get language => _language;
  AppThemeMode get themeMode => _themeMode;
  ClientVpnState get vpnState => _vpnState;
  int get durationSeconds => _durationSeconds;
  List<VpsNode> get vpsList => _vpsList;
  VpsNode get activeNode => _activeNode;
  AppStrings get strings => AppStrings(_language);

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void selectNode(VpsNode node) {
    _activeNode = node;
    notifyListeners();
  }

  void toggleVpn(BuildContext context) {
    if (_vpnState == ClientVpnState.disconnected) {
      _vpnState = ClientVpnState.connecting;
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 1200), () {
        _vpnState = ClientVpnState.connected;
        _startTimer();
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.subtitleConnected)),
        );
      });
    } else if (_vpnState == ClientVpnState.connected || _vpnState == ClientVpnState.connecting) {
      _vpnState = ClientVpnState.disconnected;
      _stopTimer();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.shieldInactive)),
      );
    }
  }

  void _startTimer() {
    _durationSeconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durationSeconds++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _durationSeconds = 0;
  }

  String get activeDurationFormatted {
    if (_vpnState != ClientVpnState.connected) return strings.notConnected;
    final h = (_durationSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((_durationSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_durationSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  String get wireGuardConfString => '''
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY_HERE
Address = 10.8.0.2/24, fd42:42:42::2/64
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = ${_activeNode.publicKey}
Endpoint = ${_activeNode.endpoint}
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
''';
}

// ==========================================
// MAIN APPLICATION
// ==========================================

class KrugerVpnApp extends StatelessWidget {
  const KrugerVpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VpnProvider>(context);

    ThemeMode mode;
    switch (provider.themeMode) {
      case AppThemeMode.light:
        mode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        mode = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        mode = ThemeMode.system;
        break;
    }

    return MaterialApp(
      title: 'Kruger VPN',
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        cardColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF059669),
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        cardColor: const Color(0xFF162238),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          surface: Color(0xFF162238),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VpnProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      const ShieldTabScreen(),
      const SettingsTabScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: isDark ? const Color(0xFF0F182A) : Colors.white,
        selectedItemColor: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
        unselectedItemColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.shield_outlined),
            activeIcon: const Icon(Icons.shield),
            label: provider.strings.tabShield,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: provider.strings.tabSettings,
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: SHIELD CLIENT SCREEN
// ==========================================

class ShieldTabScreen extends StatelessWidget {
  const ShieldTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VpnProvider>(context);
    final strings = provider.strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF162238) : Colors.white;
    final circleBg = isDark ? const Color(0xFF223354) : const Color(0xFFE2E8F0);
    final borderColor = isDark ? const Color(0xFF233352) : const Color(0xFFCBD5E1);

    String statusTitle;
    String statusSubtitle;
    String buttonText;

    switch (provider.vpnState) {
      case ClientVpnState.disconnected:
        statusTitle = strings.shieldInactive;
        statusSubtitle = strings.subtitleDisconnected;
        buttonText = strings.buttonSecureConnection;
        break;
      case ClientVpnState.connecting:
        statusTitle = strings.shieldConnecting;
        statusSubtitle = strings.subtitleConnecting;
        buttonText = strings.buttonConnecting;
        break;
      case ClientVpnState.connected:
        statusTitle = strings.shieldActive;
        statusSubtitle = strings.subtitleConnected;
        buttonText = strings.buttonDisconnect;
        break;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // App Header & Language Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield, color: primaryColor, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        strings.appName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.extrabold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    strings.appTagline,
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  final next = provider.language == AppLanguage.burmese
                      ? AppLanguage.english
                      : AppLanguage.burmese;
                  provider.setLanguage(next);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: circleBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Text(provider.language == AppLanguage.burmese ? "🇲🇲" : "🇺🇸"),
                      const SizedBox(width: 6),
                      Text(
                        provider.language == AppLanguage.burmese ? "မြန်မာ" : "English",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Main Shield Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                // Shield Status Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.vpnState == ClientVpnState.connected
                        ? primaryColor.withOpacity(0.2)
                        : circleBg,
                    border: Border.all(
                      color: provider.vpnState == ClientVpnState.connected
                          ? primaryColor
                          : borderColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: provider.vpnState == ClientVpnState.connecting
                        ? const CircularProgressIndicator(color: Colors.amber)
                        : Icon(
                            provider.vpnState == ClientVpnState.connected
                                ? Icons.check_circle
                                : Icons.warning_amber_rounded,
                            size: 54,
                            color: provider.vpnState == ClientVpnState.connected
                                ? primaryColor
                                : subtitleColor,
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: subtitleColor),
                ),

                const SizedBox(height: 28),

                // Action Toggle Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => provider.toggleVpn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.vpnState == ClientVpnState.connected
                          ? const Color(0xFFEF4444)
                          : primaryColor,
                      shape: RoundedCornerShapeBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Icon(
                      provider.vpnState == ClientVpnState.connected
                          ? Icons.stop
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
 
