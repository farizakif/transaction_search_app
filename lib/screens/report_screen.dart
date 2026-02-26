import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.blue),
            onPressed: () {},
          )
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.state == TransactionState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == TransactionState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage ?? 'An unexpected error occurred',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          
          final data = provider.responseData ?? {};
          final List transactions = _parseTransactionList(data);

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No transactions found'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Filters'),
                  ),
                ],
              ),
            );
          } 

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Text('Search transactions', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('Filters', icon: Icons.tune),
                    const SizedBox(width: 8),
                    _buildFilterChip('Date', icon: Icons.calendar_today),
                    const SizedBox(width: 8),
                    _buildFilterChip('Type'),
                  ],
                ),
              ),
              
              const Divider(height: 1),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: transactions.length,
                  separatorBuilder: (c, i) => const Divider(height: 1, indent: 70),
                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    return _TransactionTile(
                      data: item, 
                      onTap: () => _showDetailSheet(context, item),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.black),
            const SizedBox(width: 4),
          ],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  void _showDetailSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (item['Amount'] ?? item['TxnAmount'] ?? item['Amt']) != null 
                        ? '\$${item['Amount'] ?? item['TxnAmount'] ?? item['Amt']}' 
                        : 'N/A',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (item['TxnDate'] ?? item['TransactionDate'] ?? item['Date']) != null 
                        ? '${item['TxnDate'] ?? item['TransactionDate'] ?? item['Date']}' 
                        : 'Date N/A',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  ...item.entries.map((entry) {
                    if (entry.key == 'Amount' || entry.key == 'TxnAmount' || entry.key == 'Amt' ||
                        entry.key == 'Date' || entry.key == 'TxnDate' || entry.key == 'TransactionDate') {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(height: 24),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _parseTransactionList(Map<String, dynamic> data) {
    if (data['transactions'] is List?) {
      final list = data['transactions'];
      if (list != null) return List<Map<String, dynamic>>.from(list as List);
    }
    if (data['data'] is List?) {
      final list = data['data'];
      if (list != null) return List<Map<String, dynamic>>.from(list as List);
    }
    if (data['records'] is List?) {
      final list = data['records'];
      if (list != null) return List<Map<String, dynamic>>.from(list as List);
    }
    if (data['result'] is List?) {
      final list = data['result'];
      if (list != null) return List<Map<String, dynamic>>.from(list as List);
    }
    if (data['ReportData'] is List?) {
      final list = data['ReportData'];
      if (list != null) return List<Map<String, dynamic>>.from(list as List);
    }
    
    for (final key in data.keys) {
      if (data[key] is List) {
        try {
          return List<Map<String, dynamic>>.from(data[key] as List);
        } catch (e) {
          continue;
        }
      }
    }
    
    return [];
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const _TransactionTile({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = data['TxnID'] ?? data['TransactionID'] ?? data['TxnId'] ?? 'Transaction';
    final category = data['ProdCode'] ?? data['ProductCode'] ?? data['TID'] ?? 'General';
    final amount = double.tryParse((data['Amount'] ?? data['TxnAmount'] ?? data['Amt'] ?? '0').toString()) ?? 0.0;
    final date = data['TxnDate'] ?? data['TransactionDate'] ?? data['Date'] ?? 'N/A';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.receipt,
                color: Colors.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text('$date · $category',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ),
            
            Text('\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}