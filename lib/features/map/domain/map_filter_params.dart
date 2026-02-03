/// 地図フィルター適用時のパラメータ（一括渡し用）
typedef FilterParams = ({
  bool showAllStores,
  Set<String> categories,
  String? folderId,
  String? region,
  String? prefecture,
});
