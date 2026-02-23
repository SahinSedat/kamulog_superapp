import 'package:dio/dio.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';

abstract class JobsRemoteDataSource {
  Future<List<JobListingModel>> getJobs({String type = 'ALL', String? search});
}

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  final Dio apiClient =
      Dio(); // Genel kullanıma açık endpoint olduğu için direkt Dio instance'ı ekleniyor
  // Not: Eger proje bazında ozel auth header kullaniliyorsa interceptor ile eklenebilir.
  // Su anki API endpointi public e e-erisilebilir oldugu icin dogrudan call edilebilir.

  @override
  Future<List<JobListingModel>> getJobs({
    String type = 'ALL',
    String? search,
  }) async {
    try {
      final queryParams = {'type': type};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await apiClient.get(
        'https://kamulogkariyer.com/api/jobs',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jobsList = response.data['jobs'] ?? [];
        return jobsList.map((j) => JobListingModel.fromJson(j)).toList();
      } else {
        throw Exception('İş ilanlarını yüklerken bir hata oluştu.');
      }
    } catch (e) {
      throw Exception('İlanlar alınırken ağ hatası: \$e');
    }
  }
}
