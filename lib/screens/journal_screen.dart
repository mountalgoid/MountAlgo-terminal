import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String _pair = "EURUSD";
  String _direction = "Long";
  double _entryPrice = 0.0;
  double _exitPrice = 0.0;
  double _stopLoss = 0.0;
  double _takeProfit = 0.0;
  double _riskPercent = 1.0;
  double _positionSize = 1.0;
  double _fees = 2.0;
  String _emotionTag = "Calm";
  String _setupType = "Order Block";
  String _timeframe = "15m";
  String _session = "London";
  String _notes = "";
  double _edgeScore = 8.0;
  String _setupGrading = "A";
  String _mistakeTag = "None";
  String _marketCondition = "Bullish Trend";
  bool _isWin = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TerminalProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRADING JOURNAL',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Add New Entry',
            onPressed: () => _showAddEntryDialog(context, provider),
          )
        ],
      ),
      body: Column(
        children: [
          // Filter / Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL TRADES RECORDED: ${provider.journalEntries.length}',
                  style: theme.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddEntryDialog(context, provider),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('NEW ENTRY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Entries List
          Expanded(
            child: provider.journalEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, size: 64, color: theme.disabledColor),
                        const SizedBox(height: 12),
                        const Text('No Trades Journaled Yet', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Consistency is key. Click "+" to journal your first trade.', style: theme.textTheme.bodyText2),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.journalEntries.length,
                    itemBuilder: (context, index) {
                      final entry = provider.journalEntries[index];
                      final isWin = entry.isWin;
                      final cardAccent = isWin ? Colors.green : Colors.red;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cardAccent.withOpacity(0.4), width: 1.5),
                        ),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: cardAccent.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          entry.direction.toUpperCase(),
                                          style: TextStyle(
                                            color: cardAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.pair,
                                        style: theme.textTheme.headline6?.copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${entry.session} Session | ${entry.timeframe}',
                                    style: theme.textTheme.bodyText2?.copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${isWin ? "+" : "-"}\$${entry.pnlAmount.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: cardAccent,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${entry.rMultiple >= 0 ? "+" : ""}${entry.rMultiple} R',
                                    style: TextStyle(
                                      color: cardAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  _buildDetailGrid(context, entry),
                                  const SizedBox(height: 16),
                                  Text(
                                    'NOTES & POST-TRADE REVIEW',
                                    style: theme.textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: theme.dividerColor),
                                    ),
                                    child: Text(
                                      entry.notes.isNotEmpty ? entry.notes : "No notes or review recorded.",
                                      style: theme.textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(BuildContext context, JournalEntry entry) {
    final theme = Theme.of(context);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 12,
      children: [
        _buildDetailItem(theme, 'Entry Price', entry.entryPrice.toString()),
        _buildDetailItem(theme, 'Exit Price', entry.exitPrice.toString()),
        _buildDetailItem(theme, 'Stop Loss', entry.stopLoss.toString()),
        _buildDetailItem(theme, 'Take Profit', entry.takeProfit.toString()),
        _buildDetailItem(theme, 'Risk Amount', '${entry.riskPercent}%'),
        _buildDetailItem(theme, 'Position Size', entry.positionSize.toString()),
        _buildDetailItem(theme, 'Fees Deducted', '\$${entry.fees.toStringAsFixed(2)}'),
        _buildDetailItem(theme, 'Setup Grade', entry.setupGrading),
        _buildDetailItem(theme, 'Edge Score (1-10)', '${entry.edgeScore}/10'),
        _buildDetailItem(theme, 'Emotion/Psychology', entry.emotionTag),
        _buildDetailItem(theme, 'Mistake Tags', entry.mistakeTag),
        _buildDetailItem(theme, 'Market Condition', entry.marketCondition),
      ],
    );
  }

  Widget _buildDetailItem(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: theme.disabledColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyText1?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showAddEntryDialog(BuildContext context, TerminalProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default controller content for easier demo input
    final pairController = TextEditingController(text: "EURUSD");
    final entryController = TextEditingController(text: "1.0850");
    final exitController = TextEditingController(text: "1.0890");
    final slController = TextEditingController(text: "1.0830");
    final tpController = TextEditingController(text: "1.0920");
    final riskController = TextEditingController(text: "1.0");
    final sizeController = TextEditingController(text: "10000");
    final feesController = TextEditingController(text: "2.50");
    final notesController = TextEditingController(text: "");
    final setupController = TextEditingController(text: "Order Block");
    final rController = TextEditingController(text: "2.0");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 20,
                left: 16,
                right: 16,
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'JOURNAL NEW TRADE',
                            style: theme.textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pair & Direction
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: pairController,
                              decoration: const InputDecoration(
                                labelText: 'PAIR / ASSET',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _pair = value ?? "EURUSD",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _direction,
                              decoration: const InputDecoration(
                                labelText: 'DIRECTION',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: "Long", child: Text("LONG")),
                                DropdownMenuItem(value: "Short", child: Text("SHORT")),
                              ],
                              onChanged: (val) {
                                setModalState(() {
                                  _direction = val ?? "Long";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Prices (Entry, Exit, SL, TP)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: entryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'ENTRY PRICE',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _entryPrice = double.tryParse(value ?? "") ?? 0.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: exitController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'EXIT PRICE',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _exitPrice = double.tryParse(value ?? "") ?? 0.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: slController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'STOP LOSS',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _stopLoss = double.tryParse(value ?? "") ?? 0.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: tpController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'TAKE PROFIT',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _takeProfit = double.tryParse(value ?? "") ?? 0.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Risk, Position Size, Fees, R
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: riskController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'RISK %',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _riskPercent = double.tryParse(value ?? "") ?? 1.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: sizeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'POSITION SIZE',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _positionSize = double.tryParse(value ?? "") ?? 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: feesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'FEES (\$)',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _fees = double.tryParse(value ?? "") ?? 2.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: rController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'R-MULTIPLE',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _edgeScore = double.tryParse(value ?? "") ?? 2.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Multi-Select Tags (Emotion, Grading, Timeframe, Session)
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _timeframe,
                              decoration: const InputDecoration(
                                labelText: 'TIMEFRAME',
                                border: OutlineInputBorder(),
                              ),
                              items: ["1m", "5m", "15m", "1h", "4h", "D"].map((String tf) {
                                return DropdownMenuItem(value: tf, child: Text(tf));
                              }).toList(),
                              onChanged: (val) => setModalState(() => _timeframe = val ?? "15m"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _session,
                              decoration: const InputDecoration(
                                labelText: 'SESSION',
                                border: OutlineInputBorder(),
                              ),
                              items: ["London", "New York", "Asia"].map((String ss) {
                                return DropdownMenuItem(value: ss, child: Text(ss));
                              }).toList(),
                              onChanged: (val) => setModalState(() => _session = val ?? "London"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _setupGrading,
                              decoration: const InputDecoration(
                                labelText: 'SETUP GRADING',
                                border: OutlineInputBorder(),
                              ),
                              items: ["A+", "A", "B", "C"].map((String grade) {
                                return DropdownMenuItem(value: grade, child: Text(grade));
                              }).toList(),
                              onChanged: (val) => setModalState(() => _setupGrading = val ?? "A"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _emotionTag,
                              decoration: const InputDecoration(
                                labelText: 'EMOTION TAG',
                                border: OutlineInputBorder(),
                              ),
                              items: ["Calm", "Anxious", "Greedy", "Fearful", "Excited", "Disciplined"].map((String tag) {
                                return DropdownMenuItem(value: tag, child: Text(tag));
                              }).toList(),
                              onChanged: (val) => setModalState(() => _emotionTag = val ?? "Calm"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _mistakeTag,
                              decoration: const InputDecoration(
                                labelText: 'MISTAKE TAG',
                                border: OutlineInputBorder(),
                              ),
                              items: ["None", "FOMO", "Overleveraging", "Hesitation", "Early Exit", "Rule Broken"].map((String tf) {
                                return DropdownMenuItem(value: tf, child: Text(tf));
                              }).toList(),
                              onChanged: (val) => setModalState(() => _mistakeTag = val ?? "None"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _marketCondition,
                              decoration: const InputDecoration(
                                labelText: 'MARKET CONDITION',
                                border: OutlineInputBorder(),
                              ),
                              items: ["Bullish Trend", "Ranging", "Bearish Trend", "High Volatility"].map((String ss) {
                                return DropdownMenuItem(value: ss, child: Text(ss));
                              }).toList(),
                              onChanged: (val) => setModalState(() => _marketCondition = val ?? "Bullish Trend"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Win / Loss Toggle Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('IS THIS TRADE A WIN?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Switch(
                              value: _isWin,
                              onChanged: (val) {
                                setModalState(() {
                                  _isWin = val;
                                });
                              },
                              activeColor: Colors.green,
                              inactiveTrackColor: Colors.red.withOpacity(0.3),
                              inactiveThumbColor: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Setup Type and Notes
                      TextFormField(
                        controller: setupController,
                        decoration: const InputDecoration(
                          labelText: 'SETUP TYPE',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _setupType = value ?? "Order Block",
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'NOTES & POST-TRADE REVIEW CHECKLIST',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Confluence: swept liquidity, got displacement, target key levels.',
                        ),
                        onSaved: (value) => _notes = value ?? "",
                      ),
                      const SizedBox(height: 20),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              final newEntry = JournalEntry(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                date: DateTime.now(),
                                pair: pairController.text.toUpperCase(),
                                direction: _direction,
                                entryPrice: double.tryParse(entryController.text) ?? 0.0,
                                exitPrice: double.tryParse(exitController.text) ?? 0.0,
                                stopLoss: double.tryParse(slController.text) ?? 0.0,
                                takeProfit: double.tryParse(tpController.text) ?? 0.0,
                                riskPercent: double.tryParse(riskController.text) ?? 1.0,
                                positionSize: double.tryParse(sizeController.text) ?? 1.0,
                                fees: double.tryParse(feesController.text) ?? 0.0,
                                emotionTag: _emotionTag,
                                setupType: setupController.text,
                                timeframe: _timeframe,
                                session: _session,
                                notes: notesController.text,
                                rMultiple: double.tryParse(rController.text) ?? 0.0,
                                edgeScore: _edgeScore,
                                setupGrading: _setupGrading,
                                mistakeTag: _mistakeTag,
                                marketCondition: _marketCondition,
                                isWin: _isWin,
                              );

                              provider.addJournalEntry(newEntry);
                              Navigator.pop(context);

                              // Notify user if Discord sync enabled
                              if (provider.isDiscordConnected && provider.syncOnSave) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Trade saved. Synchronized & dispatched to Discord channel!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Trade saved to manual terminal ledger.')),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'SAVE JOURNAL ENTRY',
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
