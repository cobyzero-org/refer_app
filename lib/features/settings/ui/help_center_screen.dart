import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/core/widgets/app_snackbar.dart';
import '../../../l10n/app_localizations.dart';

class FAQItem {
  final String question;
  final String answer;
  final String category;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
    this.isExpanded = false,
  });
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'ALL';
  String _searchQuery = '';
  List<FAQItem> _allFaqs = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _allFaqs = [
      FAQItem(
        question: l10n.faqQ1,
        answer: l10n.faqA1,
        category: 'GENERAL',
      ),
      FAQItem(
        question: l10n.faqQ2,
        answer: l10n.faqA2,
        category: 'ORDERS',
      ),
      FAQItem(
        question: l10n.faqQ3,
        answer: l10n.faqA3,
        category: 'PAYMENTS',
      ),
      FAQItem(
        question: l10n.faqQ4,
        answer: l10n.faqA4,
        category: 'ACCOUNT',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FAQItem> get _filteredFaqs {
    return _allFaqs.where((faq) {
      final matchesCategory = _selectedCategory == 'ALL' || faq.category == _selectedCategory;
      final matchesSearch = faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF1E3932);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.helpCenter,
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Category selection
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: l10n.searchFAQ,
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildCategoryChip('ALL', l10n.all),
                        _buildCategoryChip('GENERAL', l10n.faqCategoryGeneral),
                        _buildCategoryChip('PAYMENTS', l10n.faqCategoryPayments),
                        _buildCategoryChip('ORDERS', l10n.faqCategoryOrders),
                        _buildCategoryChip('ACCOUNT', l10n.faqCategoryAccount),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FAQ List
            Expanded(
              child: _filteredFaqs.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noResults,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredFaqs.length,
                      itemBuilder: (context, index) {
                        final faq = _filteredFaqs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.shade100),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              key: ValueKey(faq.question),
                              title: Text(
                                faq.question,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D3132),
                                ),
                              ),
                              iconColor: primaryColor,
                              collapsedIconColor: Colors.grey,
                              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              expandedAlignment: Alignment.topLeft,
                              children: [
                                Text(
                                  faq.answer,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Contact support footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.contactSupport,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Logic or action to email
                            AppSnackBar.info(context, 'support@referapp.com');
                          },
                          icon: const Icon(Icons.email_outlined, color: primaryColor),
                          label: Text(
                            l10n.contactUsEmail,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Logic or action to phone call
                            AppSnackBar.info(context, '+1 (800) 555-0199');
                          },
                          icon: const Icon(Icons.phone_outlined, color: primaryColor),
                          label: Text(
                            l10n.contactUsPhone,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryCode, String label) {
    final isSelected = _selectedCategory == categoryCode;
    const activeColor = Color(0xFF1E3932);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        onSelected: (val) {
          if (val) {
            setState(() {
              _selectedCategory = categoryCode;
            });
          }
        },
        selectedColor: activeColor,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected ? activeColor : Colors.grey.shade200,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        showCheckmark: false,
      ),
    );
  }
}
