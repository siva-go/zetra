class WalletModel {
  final String id;
  final int balancePaise;
  final double balance;
  final String? currency;

  const WalletModel({
    required this.id,
    required this.balancePaise,
    required this.balance,
    this.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final int paise = json['balancePaise'] is num
        ? (json['balancePaise'] as num).toInt()
        : 0;
    final double bal = json['balance'] is num
        ? (json['balance'] as num).toDouble()
        : (paise / 100.0);

    return WalletModel(
      id: json['id']?.toString() ?? '',
      balancePaise: paise,
      balance: bal,
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}

class WalletTransactionModel {
  final String id;
  final String type; // CREDIT, DEBIT, REFUND, VOUCHER
  final int amountPaise;
  final double amount;
  final String? description;
  final String? reference;
  final DateTime createdAt;

  const WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amountPaise,
    required this.amount,
    this.description,
    this.reference,
    required this.createdAt,
  });

  bool get isCredit => type == 'CREDIT' || type == 'VOUCHER' || type == 'REFUND';

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    final int paise = json['amountPaise'] is num
        ? (json['amountPaise'] as num).toInt()
        : 0;
    final double amt = json['amount'] is num
        ? (json['amount'] as num).toDouble()
        : (paise / 100.0);

    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'DEBIT',
      amountPaise: paise,
      amount: amt,
      description: json['description']?.toString() ?? json['title']?.toString(),
      reference: json['reference']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class WalletTransactionsPage {
  final List<WalletTransactionModel> data;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  const WalletTransactionsPage({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  factory WalletTransactionsPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawList = json['data'] as List<dynamic>? ?? <dynamic>[];
    final List<WalletTransactionModel> items = rawList
        .map((dynamic item) => WalletTransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final Map<String, dynamic>? pagination = json['pagination'] as Map<String, dynamic>?;
    final int currentPage = pagination?['page'] is num ? (pagination!['page'] as num).toInt() : 1;
    final int size = pagination?['pageSize'] is num ? (pagination!['pageSize'] as num).toInt() : 20;
    final int tot = pagination?['total'] is num ? (pagination!['total'] as num).toInt() : items.length;
    final int totalPages = pagination?['totalPages'] is num ? (pagination!['totalPages'] as num).toInt() : 1;

    return WalletTransactionsPage(
      data: items,
      page: currentPage,
      pageSize: size,
      total: tot,
      hasMore: currentPage < totalPages,
    );
  }
}

class TopupResponseModel {
  final String paymentId;
  final String checkoutUrl;

  const TopupResponseModel({
    required this.paymentId,
    required this.checkoutUrl,
  });

  factory TopupResponseModel.fromJson(Map<String, dynamic> json) {
    return TopupResponseModel(
      paymentId: json['id']?.toString() ?? json['paymentId']?.toString() ?? '',
      checkoutUrl: json['checkoutUrl']?.toString() ?? json['paymentUrl']?.toString() ?? '',
    );
  }
}
