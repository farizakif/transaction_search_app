import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../utils/helpers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _midController = TextEditingController();
  final _tidController = TextEditingController();
  final _txnIdController = TextEditingController();
  final _beneAcctNoController = TextEditingController();
  final _prodCodeController = TextEditingController();
  final _txnStatusController = TextEditingController();
  final _maxRowController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _midController.dispose();
    _tidController.dispose();
    _txnIdController.dispose();
    _beneAcctNoController.dispose();
    _prodCodeController.dispose();
    _txnStatusController.dispose();
    _maxRowController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade500, size: 20) : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      isDense: true,
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget w = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: w,
              ),
              if (idx != children.length - 1)
                Divider(height: 1, color: Colors.grey.shade100, indent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart 
          ? (_startDate ?? DateTime.now()) 
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF007AFF)),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          if (_endDate != null && _endDate!.isBefore(date)) _endDate = null;
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _onSearch() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }
    final provider = context.read<TransactionProvider>();
    int? txnStatus;
    int? maxRow;
    
    if (_txnStatusController.text.isNotEmpty) {
      txnStatus = int.tryParse(_txnStatusController.text);
    }
    if (_maxRowController.text.isNotEmpty) {
      maxRow = int.tryParse(_maxRowController.text);
    }

    provider.searchTransactions(
      startDate: _startDate!,
      endDate: _endDate!,
      mid: _midController.text.trim(),
      tid: _tidController.text.trim(),
      txnId: _txnIdController.text.trim(),
      beneAcctNo: _beneAcctNoController.text.trim(),
      prodCode: _prodCodeController.text.trim(),
      txnStatus: txnStatus,
      maxRow: maxRow,
    );

    Navigator.of(context).pushNamed('/report');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _formKey.currentState?.reset();
              setState(() { _startDate = null; _endDate = null; });
            },
            child: const Text('Clear all', style: TextStyle(fontSize: 16)),
          )
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Padding for bottom button
              children: [
                _buildSectionLabel('DATE RANGE'),
                _buildSectionContainer([
                  InkWell(
                    onTap: () => _pickDate(true),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Start Date', style: TextStyle(fontSize: 16)),
                          Text(
                            _startDate != null ? DateFormat('MMM dd, yyyy').format(_startDate!) : 'Select',
                            style: TextStyle(
                              color: _startDate != null ? Colors.blue : Colors.grey.shade400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _pickDate(false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('End Date', style: TextStyle(fontSize: 16)),
                          Text(
                            _endDate != null ? DateFormat('MMM dd, yyyy').format(_endDate!) : 'Select',
                            style: TextStyle(
                              color: _endDate != null ? Colors.blue : Colors.grey.shade400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),
                _buildSectionLabel('IDENTIFIERS'),
                _buildSectionContainer([
                  TextFormField(
                    controller: _midController,
                    decoration: _buildInputDecoration('Merchant ID (MID) *', icon: Icons.store),
                    validator: validateMid,
                  ),
                  TextFormField(
                    controller: _tidController,
                    decoration: _buildInputDecoration('Terminal ID (TID)', icon: Icons.terminal),
                    validator: validateTid,
                  ),
                  TextFormField(
                    controller: _txnIdController,
                    decoration: _buildInputDecoration('Transaction ID', icon: Icons.receipt),
                    validator: validateTxnId,
                  ),
                ]),

                const SizedBox(height: 24),
                _buildSectionLabel('OPTIONAL DETAILS'),
                _buildSectionContainer([
                  TextFormField(
                    controller: _beneAcctNoController,
                    decoration: _buildInputDecoration('Beneficiary Account', icon: Icons.account_balance),
                    validator: validateBeneAcctNo,
                  ),
                  TextFormField(
                    controller: _prodCodeController,
                    decoration: _buildInputDecoration('Product Code', icon: Icons.qr_code),
                    validator: validateProdCode,
                  ),
                  TextFormField(
                    controller: _txnStatusController,
                    decoration: _buildInputDecoration('Status Code', icon: Icons.info_outline),
                    keyboardType: TextInputType.number,
                    validator: validateTxnStatus,
                  ),
                  TextFormField(
                    controller: _maxRowController,
                    decoration: _buildInputDecoration('Max Rows', icon: Icons.list),
                    keyboardType: TextInputType.number,
                    validator: validateMaxRow,
                  ),
                ]),
              ],
            ),
          ),
          
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  elevation: 2,
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}