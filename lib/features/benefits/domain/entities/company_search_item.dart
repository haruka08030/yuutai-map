/// 企業検索結果（表示・選択用）
class CompanySearchItem {
  const CompanySearchItem({
    required this.id,
    required this.name,
    this.stockCode,
  });

  final int id;
  final String name;
  final String? stockCode;
}
