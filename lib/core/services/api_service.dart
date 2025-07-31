import 'package:dio/dio.dart';
import '../../features/product_details/data/models/product_model.dart';


class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://687c225eb4bc7cfbda883994.mockapi.io/Product';

  Future<List<ProductModel>?> fetchAllProducts() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
    return null;
  }
}
