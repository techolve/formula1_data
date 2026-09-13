/// A page of results returned by the jolpica-f1 API, together with the
/// pagination metadata (`total`, `limit`, `offset`) echoed back by the
/// server in the `MRData` envelope.
class PaginatedResult<T> {
  /// The items returned for this page.
  final List<T> items;

  /// The total number of items available across all pages.
  final int total;

  /// The limit that was applied to this call (may differ from the
  /// requested limit if the server caps it).
  final int limit;

  /// The offset that was applied to this call.
  final int offset;

  const PaginatedResult({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  /// An empty result, used when a request fails or returns no data.
  factory PaginatedResult.empty({int limit = 30, int offset = 0}) {
    return PaginatedResult<T>(
      items: const [],
      total: 0,
      limit: limit,
      offset: offset,
    );
  }

  /// Whether more items are available beyond this page.
  bool get hasMore => offset + items.length < total;

  @override
  String toString() {
    return 'PaginatedResult(items: ${items.length}, total: $total, limit: $limit, offset: $offset)';
  }
}
