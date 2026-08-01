import 'package:flutter/material.dart';

enum VisualMode { dark, light, glasses }

class JournalEntry {
  final String id;
  final DateTime date;
  final String pair;
  final String direction; // "Long" or "Short"
  final double entryPrice;
  final double exitPrice;
  final double stopLoss;
  final double takeProfit;
  final double riskPercent; // e.g. 1.0 for 1%
  final double positionSize;
  final double fees;
  final String emotionTag;
  final String setupType; // e.g. "Break of Structure", "Liquidity Sweep"
  final String timeframe; // "1m", "5m", "15m", "1h", "4h", "D"
  final String session; // "London", "New York", "Asia"
  final String notes;
  final double rMultiple; // Calculated automatically or custom overridden
  final double edgeScore; // 1-10 scale
  final String setupGrading; // "A+", "A", "B", "C"
  final String mistakeTag; // e.g. "None", "FOMO", "Overleveraging", "Early Exit"
  final String marketCondition; // "Bullish Trend", "Ranging", "Bearish Trend"
  final bool isWin;

  JournalEntry({
    required this.id,
    required this.date,
    required this.pair,
    required this.direction,
    required this.entryPrice,
    required this.exitPrice,
    required this.stopLoss,
    required this.takeProfit,
    required this.riskPercent,
    required this.positionSize,
    required this.fees,
    required this.emotionTag,
    required this.setupType,
    required this.timeframe,
    required this.session,
    required this.notes,
    required this.rMultiple,
    required this.edgeScore,
    required this.setupGrading,
    required this.mistakeTag,
    required this.marketCondition,
    required this.isWin,
  });

  double get pnlAmount {
    // Basic pnl simulation for the terminal demonstration
    final double absoluteDiff = (exitPrice - entryPrice).abs();
    final double riskDistance = (entryPrice - stopLoss).abs();
    if (riskDistance == 0) return 0.0;

    double basePnl = (absoluteDiff / riskDistance) * (riskPercent / 100.0) * positionSize * 100;
    if (!isWin) {
      basePnl = -basePnl;
    }
    return basePnl - fees;
  }
}

class WebAppShortcut {
  final String name;
  final String url;
  final IconData icon;
  final bool isCustom;

  WebAppShortcut({
    required this.name,
    required this.url,
    required this.icon,
    this.isCustom = false,
  });
}

class TerminalProvider extends ChangeNotifier {
  // Visual Mode State
  VisualMode _currentVisualMode = VisualMode.dark;
  VisualMode get currentVisualMode => _currentVisualMode;

  void setVisualMode(VisualMode mode) {
    _currentVisualMode = mode;
    notifyListeners();
  }

  // Discord Bot Connection State
  bool _isDiscordConnected = false;
  bool get isDiscordConnected => _isDiscordConnected;

  String _discordWebhookUrl = "";
  String get discordWebhookUrl => _discordWebhookUrl;

  String _discordBotStatus = "Offline";
  String get discordBotStatus => _discordBotStatus;

  bool _syncOnSave = true;
  bool get syncOnSave => _syncOnSave;

  void connectDiscord(String webhookUrl) {
    if (webhookUrl.isNotEmpty) {
      _discordWebhookUrl = webhookUrl;
      _isDiscordConnected = true;
      _discordBotStatus = "Online (bot.py Linked)";
      notifyListeners();
    }
  }

  void disconnectDiscord() {
    _isDiscordConnected = false;
    _discordWebhookUrl = "";
    _discordBotStatus = "Offline";
    notifyListeners();
  }

  void toggleSyncOnSave(bool val) {
    _syncOnSave = val;
    notifyListeners();
  }

  // Launcher State (WebApps)
  final List<WebAppShortcut> _shortcuts = [
    WebAppShortcut(name: "TradingView", url: "https://www.tradingview.com", icon: Icons.show_chart),
    WebAppShortcut(name: "Discord", url: "https://discord.com", icon: Icons.discord),
    WebAppShortcut(name: "Binance", url: "https://www.binance.com", icon: Icons.currency_bitcoin),
    WebAppShortcut(name: "OKX", url: "https://www.okx.com", icon: Icons.grid_view),
    WebAppShortcut(name: "Exness", url: "https://www.exness.com", icon: Icons.account_balance),
    WebAppShortcut(name: "Bybit", url: "https://www.bybit.com", icon: Icons.swap_horiz),
    WebAppShortcut(name: "Bitget", url: "https://www.bitget.com", icon: Icons.security),
    WebAppShortcut(name: "MIFX", url: "https://mifx.com", icon: Icons.trending_up),
  ];

  List<WebAppShortcut> get shortcuts => _shortcuts;

  void addCustomShortcut(String name, String url) {
    _shortcuts.add(
      WebAppShortcut(
        name: name,
        url: url.startsWith("http") ? url : "https://$url",
        icon: Icons.language,
        isCustom: true,
      ),
    );
    notifyListeners();
  }

  void removeShortcut(int index) {
    if (_shortcuts[index].isCustom) {
      _shortcuts.removeAt(index);
      notifyListeners();
    }
  }

  // Journal State
  final List<JournalEntry> _journalEntries = [
    JournalEntry(
      id: "1",
      date: DateTime.now().subtract(const Duration(days: 2)),
      pair: "EURUSD",
      direction: "Long",
      entryPrice: 1.08500,
      exitPrice: 1.09000,
      stopLoss: 1.08300,
      takeProfit: 1.09100,
      riskPercent: 1.0,
      positionSize: 50000,
      fees: 3.50,
      emotionTag: "Calm & Disciplined",
      setupType: "Order Block Bounce",
      timeframe: "15m",
      session: "London",
      notes: "Clean rejection off daily demand. Executed flawlessly according to trading plan.",
      rMultiple: 2.5,
      edgeScore: 9.0,
      setupGrading: "A+",
      mistakeTag: "None",
      marketCondition: "Bullish Trend",
      isWin: true,
    ),
    JournalEntry(
      id: "2",
      date: DateTime.now().subtract(const Duration(days: 1)),
      pair: "BTCUSDT",
      direction: "Short",
      entryPrice: 65000,
      exitPrice: 65400,
      stopLoss: 65300,
      takeProfit: 64100,
      riskPercent: 1.5,
      positionSize: 0.5,
      fees: 5.00,
      emotionTag: "Slight FOMO",
      setupType: "Liquidity Sweep",
      timeframe: "5m",
      session: "New York",
      notes: "Swept local highs but entry was slightly delayed due to hesitation.",
      rMultiple: -1.0,
      edgeScore: 6.0,
      setupGrading: "B",
      mistakeTag: "Hesitation",
      marketCondition: "Ranging",
      isWin: false,
    )
  ];

  List<JournalEntry> get journalEntries => _journalEntries;

  void addJournalEntry(JournalEntry entry) {
    _journalEntries.insert(0, entry);
    notifyListeners();
  }

  // Advanced Stats Computations
  double get totalPnL {
    double total = 0.0;
    for (var entry in _journalEntries) {
      total += entry.pnlAmount;
    }
    return total;
  }

  double get winRate {
    if (_journalEntries.isEmpty) return 0.0;
    int wins = _journalEntries.where((entry) => entry.isWin).length;
    return (wins / _journalEntries.length) * 100;
  }

  double get profitFactor {
    double grossProfits = 0.0;
    double grossLosses = 0.0;
    for (var entry in _journalEntries) {
      double pnl = entry.pnlAmount;
      if (pnl > 0) {
        grossProfits += pnl;
      } else {
        grossLosses += pnl.abs();
      }
    }
    if (grossLosses == 0) return grossProfits > 0 ? 99.9 : 0.0;
    return grossProfits / grossLosses;
  }

  double get averageR {
    if (_journalEntries.isEmpty) return 0.0;
    double totalR = 0.0;
    for (var entry in _journalEntries) {
      totalR += entry.rMultiple;
    }
    return totalR / _journalEntries.length;
  }

  double get expectancy {
    // Expectancy = (Win Rate * Avg Win) - (Loss Rate * Avg Loss)
    if (_journalEntries.isEmpty) return 0.0;
    final wins = _journalEntries.where((e) => e.isWin).toList();
    final losses = _journalEntries.where((e) => !e.isWin).toList();

    double avgWin = wins.isEmpty ? 0.0 : wins.map((e) => e.pnlAmount).reduce((a, b) => a + b) / wins.length;
    double avgLoss = losses.isEmpty ? 0.0 : losses.map((e) => e.pnlAmount).reduce((a, b) => a + b).abs() / losses.length;

    double pWin = wins.length / _journalEntries.length;
    double pLoss = losses.length / _journalEntries.length;

    return (pWin * avgWin) - (pLoss * avgLoss);
  }

  double get maxDrawdown {
    // Simulated simple drawdown logic for demo
    if (_journalEntries.isEmpty) return 0.0;
    double peak = 0.0;
    double currentBal = 0.0;
    double maxDd = 0.0;

    // Chronological analysis (from oldest to newest)
    final reversedList = _journalEntries.reversed.toList();
    for (var entry in reversedList) {
      currentBal += entry.pnlAmount;
      if (currentBal > peak) {
        peak = currentBal;
      }
      double dd = peak - currentBal;
      if (dd > maxDd) {
        maxDd = dd;
      }
    }
    return maxDd;
  }
}
