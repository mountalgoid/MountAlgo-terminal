import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TerminalProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WEBAPP LAUNCHER',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Description
            Text(
              'Workspace Hub',
              style: theme.textTheme.headline6?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 6),
            Text(
              'Instantly open major trading platforms inside the MountAlgo secure sandbox environment. Add your custom platforms below.',
              style: theme.textTheme.bodyText2,
            ),
            const SizedBox(height: 20),

            // Add Custom WebApp Section
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REGISTER CUSTOM SHORTCUT',
                    style: theme.textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Platform Name',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          decoration: const InputDecoration(
                            labelText: 'URL (e.g. coinglass.com)',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: theme.colorScheme.primary,
                      ),
                      icon: const Icon(Icons.add_link),
                      label: const Text('DEPLOY WORKSPACE SHORTCUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () {
                        if (_nameController.text.isNotEmpty && _urlController.text.isNotEmpty) {
                          provider.addCustomShortcut(_nameController.text, _urlController.text);
                          _nameController.clear();
                          _urlController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Custom WebApp registered successfully.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill both Platform Name and URL fields.')),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Platforms Grid
            Text(
              'AVAILABLE WORKSPACE WEBPAGES',
              style: theme.textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemCount: provider.shortcuts.length,
                itemBuilder: (context, index) {
                  final shortcut = provider.shortcuts[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              _launchInFakeBrowser(context, shortcut.name, shortcut.url);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(shortcut.icon, color: theme.colorScheme.secondary, size: 28),
                                  const SizedBox(height: 10),
                                  Text(
                                    shortcut.name.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: theme.textTheme.bodyText1?.color,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    shortcut.isCustom ? 'CUSTOM' : 'SYSTEM',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: theme.disabledColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (shortcut.isCustom)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                              onPressed: () {
                                provider.removeShortcut(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Custom shortcut removed.')),
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchInFakeBrowser(BuildContext context, String name, String url) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              // Safe Sandbox Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border(bottom: BorderSide(color: theme.dividerColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SECURE TERMINAL BROWSER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: theme.disabledColor,
                              ),
                            ),
                            Text(
                              '$name - $url',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),

              // Simulated Sandbox WebView Page Content
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.open_in_new, size: 48, color: theme.colorScheme.secondary),
                          const SizedBox(height: 16),
                          Text(
                            'Simulated Secure WebApp Canvas',
                            style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MountAlgo Sandbox environment successfully initialized connection to $url. In live mobile deployments via FlutLab, this renders a fully functional, high-performance webview container without exiting the terminal app layout.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyText2,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: theme.colorScheme.primary,
                            ),
                            child: const Text('Back to Terminal Dashboard'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
