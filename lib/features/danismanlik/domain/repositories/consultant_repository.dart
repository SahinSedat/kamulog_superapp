import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/danismanlik/domain/entities/consultant.dart';

abstract class ConsultantRepository {
  Future<Either<Failure, List<Consultant>>> getConsultants({
    ConsultantCategory? category,
    bool? onlineOnly,
  });
  Future<Either<Failure, Consultant>> getConsultantById(String id);
}
