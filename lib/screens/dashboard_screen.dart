import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TerminalProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MOUNTALGO TERMINAL',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: provider.isDiscordConnected ? Colors.green.withOpacity(0.15) : theme.dividerColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: provider.isDiscordConnected ? Colors.green : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.discord,
                  size: 16,
                  color: provider.isDiscordConnected ? Colors.green : theme.disabledColor,
                ),
                const SizedBox(width: 4),
                Text(
                  provider.isDiscordConnected ? 'LINKED' : 'OFFLINE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: provider.isDiscordConnected ? Colors.green : theme.disabledColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Institutional Trading Command Center',
              style: theme.textTheme.headline6?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome, Commander. Track your statistics, deploy shortcuts, and synchronize your data in real-time.',
              style: theme.textTheme.bodyText2,
            ),
            const SizedBox(height: 24),

            // Visual Mode Selector Card
            _buildSectionHeader(context, 'VISUAL MODE CONFIGURATION'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildModeBtn(
                          context,
                          'DARK MODE',
                          VisualMode.dark,
                          provider.currentVisualMode == VisualMode.dark,
                          Icons.dark_mode,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildModeBtn(
                          context,
                          'LIGHT MODE',
                          VisualMode.light,
                          provider.currentVisualMode == VisualMode.light,
                          Icons.light_mode,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildModeBtn(
                          context,
                          'GLASSES',
                          VisualMode.glasses,
                          provider.currentVisualMode == VisualMode.glasses,
                          Icons.visibility,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.currentVisualMode == VisualMode.glasses
                        ? 'Glasses Mode activated: Optimized with ultra-high contrast levels for maximum readability under intense outdoor sun.'
                        : provider.currentVisualMode == VisualMode.light
                            ? 'Light Mode activated: Minimalist, crisp, daylight optimized aesthetics.'
                            : 'Dark Mode activated: Low-emission illumination, perfect for high-focus trading environments.',
                    style: theme.textTheme.bodyText2?.copyWith(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Advanced Statistics Grid
            _buildSectionHeader(context, 'METRICS AND PERFORMANCE'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  context,
                  'NET PROFIT/LOSS',
                  '\$${provider.totalPnL.toStringAsFixed(2)}',
                  provider.totalPnL >= 0 ? Colors.green : Colors.red,
                  provider.totalPnL >= 0 ? Icons.trending_up : Icons.trending_down,
                ),
                _buildStatCard(
                  context,
                  'WIN RATE',
                  '${provider.winRate.toStringAsFixed(1)}%',
                  theme.colorScheme.secondary,
                  Icons.percent,
                ),
                _buildStatCard(
                  context,
                  'EXPECTANCY',
                  '${provider.expectancy.toStringAsFixed(2)} R',
                  Colors.amber,
                  Icons.calculate,
                ),
                _buildStatCard(
                  context,
                  'PROFIT FACTOR',
                  provider.profitFactor.toStringAsFixed(2),
                  provider.profitFactor >= 1.5 ? Colors.green : Colors.orange,
                  Icons.assessment,
                ),
                _buildStatCard(
                  context,
                  'AVERAGE R-MULTIPLE',
                  '${provider.averageR.toStringAsFixed(2)} R',
                  Colors.purple,
                  Icons.bolt,
                ),
                _buildStatCard(
                  context,
                  'MAX DRAWDOWN',
                  '\$${provider.maxDrawdown.toStringAsFixed(2)}',
                  Colors.redAccent,
                  Icons.warning,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Daily Discipline Rule Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield, color: theme.colorScheme.primary, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAILY TRADING CODE',
                          style: theme.textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"Your ultimate edge is discipline, not direction. Manual journaling ensures absolute execution consistency."',
                          style: theme.textTheme.bodyText2?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildModeBtn(BuildContext context, String title, VisualMode mode, bool isSelected, IconData icon) {
    final theme = Theme.of(context);
    final provider = Provider.of<TerminalProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        provider.setVisualMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : theme.dividerColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : theme.textTheme.bodyText1?.color,
              size: 18,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : theme.textTheme.bodyText1?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color accentColor, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.disabledColor,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 16, color: accentColor),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.headline5?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
