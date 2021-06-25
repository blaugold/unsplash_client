import 'model_base.dart';

// ignore_for_file: public_member_api_docs

/// Results returned from a search request.
class SearchResults<T extends ModelBase> extends ModelBase {
  const SearchResults({
    Map<String, dynamic>? source,
    required this.total,
    required this.totalPages,
    required this.results,
  }) : super(source: source);

  final int total;
  final int totalPages;
  final List<T> results;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'total_pages': totalPages,
      'results': results.map((it) => it.toJson()).toList(),
    };
  }

  factory SearchResults.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) mapResult,
  ) {
    return SearchResults(
      source: json,
      total: json['total'] as int,
      totalPages: json['total_pages'] as int,
      results: (json['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(mapResult)
          .toList(),
    );
  }
}
