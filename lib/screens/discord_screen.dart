import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';

class DiscordScreen extends StatefulWidget {
  const DiscordScreen({Key? key}) : super(key: key);

  @override
  State<DiscordScreen> createState() => _DiscordScreenState();
}

class _DiscordScreenState extends State<DiscordScreen> {
  final _webhookController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TerminalProvider>(context, listen: false);
    _webhookController.text = provider.discordWebhookUrl;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TerminalProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DISCORD CONNECTION',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Text(
              'Real-Time Sync Platform',
              style: theme.textTheme.headline6?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 6),
            Text(
              'Synchronize your MountAlgo Terminal manual trading journal data with your personal or team Discord servers using webhooks and our official bot.py scripts.',
              style: theme.textTheme.bodyText2,
            ),
            const SizedBox(height: 24),

            // Connection Controller Panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: provider.isDiscordConnected ? Colors.green.withOpacity(0.5) : theme.dividerColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BOT CONNECTION STATUS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.disabledColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: provider.isDiscordConnected ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          provider.discordBotStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: provider.isDiscordConnected ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  if (!provider.isDiscordConnected) ...[
                    Text(
                      'CONNECT DISCORD SERVER',
                      style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Input your Discord Server Webhook URL below to link your Terminal with your Discord server logs.',
                      style: theme.textTheme.bodyText2?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _webhookController,
                      decoration: const InputDecoration(
                        labelText: 'Discord Webhook URL',
                        border: OutlineInputBorder(),
                        hintText: 'https://discord.com/api/webhooks/...',
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: theme.colorScheme.primary,
                        ),
                        icon: const Icon(Icons.power),
                        label: const Text('INITIALIZE BOT.PY HANDSHAKE', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (_webhookController.text.isNotEmpty && _webhookController.text.startsWith('https://')) {
                            provider.connectDiscord(_webhookController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Connection initialized! bot.py linked with terminal successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please input a valid Discord Webhook URL starting with https://')),
                            );
                          }
                        },
                      ),
                    ),
                  ] else ...[
                    Text(
                      'ACTIVE ENDPOINT',
                      style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.discordWebhookUrl,
                      style: theme.textTheme.bodyText2?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: theme.colorScheme.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),

                    // Sync Configurations
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sync Trade Saves Automatically', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Switch(
                          value: provider.syncOnSave,
                          onChanged: (val) {
                            provider.toggleSyncOnSave(val);
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                        icon: const Icon(Icons.power_off, color: Colors.red),
                        label: const Text('DISCONNECT SERVER INTEGRATION', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          provider.disconnectDiscord();
                          _webhookController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Discord connection severed.')),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Setup Guide Steps
            _buildSectionHeader(context, 'SETUP AND DEPLOYMENT GUIDE'),
            const SizedBox(height: 12),
            _buildGuideStep(
              context,
              '1',
              'Create Webhook',
              'Navigate to Server Settings > Integrations > Webhooks inside your Discord desktop or web application. Create a new webhook for the desired channel.',
            ),
            _buildGuideStep(
              context,
              '2',
              'Copy Webhook URL',
              'Click the "Copy Webhook URL" button. This unique API URL allows our secure FlutLab compiler and terminal to broadcast logs directly.',
            ),
            _buildGuideStep(
              context,
              '3',
              'Deploy bot.py script',
              'Clone our server bot.py script into your self-hosted terminal or cloud server to receive customized role-based trade updates and advanced performance alerts.',
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

  Widget _buildGuideStep(BuildContext context, String number, String title, String description) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: theme.colorScheme.primary, width: 1),
            ),
            child: Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
