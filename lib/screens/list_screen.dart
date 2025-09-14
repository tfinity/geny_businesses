import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geny_businesses/providers/business_list_provider.dart';
import 'package:geny_businesses/widgets/business_card.dart';
import 'package:geny_businesses/models/business.dart';
import 'package:geny_businesses/screens/detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late BusinessListProvider provider;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BusinessListProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => provider.load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildBody(BusinessListProvider p) {
    switch (p.state) {
      case ViewState.loading:
        return _loading();
      case ViewState.empty:
        return _empty(p);
      case ViewState.error:
        return _error(p);
      case ViewState.loaded:
        return _list(p);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _loading() {
    // simple skeleton list
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) =>
          const SizedBox(height: 80, child: Card(child: SizedBox.shrink())),
    );
  }

  Widget _empty(BusinessListProvider p) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.storefront_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('No businesses found'),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: p.retry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _error(BusinessListProvider p) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              p.errorMessage.isNotEmpty ? p.errorMessage : 'An error occurred',
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: p.retry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _list(BusinessListProvider p) {
    final items = p.filteredItems;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No matches for your search'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => p.setSearch(''),
              child: const Text('Clear'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final b = items[index];
        return BusinessCard<Business>(
          model: b,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(business: b)),
          ),
          builder: (_, biz) => _businessCardBody(biz),
        );
      },
    );
  }

  Widget _businessCardBody(Business b) {
    return Row(
      children: [
        CircleAvatar(child: Text(b.name.isNotEmpty ? b.name[0] : '?')),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                b.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(b.location),
              const SizedBox(height: 4),
              Text(b.contactNumber, style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Businesses'),
        actions: [
          IconButton(
            onPressed: () => provider.load(forceNetwork: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Consumer<BusinessListProvider>(
                builder: (context, p, _) {
                  // Selector could be used for just search text if heavy rebuilds seen
                  return TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by name or location',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: p.setSearch,
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<BusinessListProvider>(
                builder: (context, p, _) => _buildBody(p),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
