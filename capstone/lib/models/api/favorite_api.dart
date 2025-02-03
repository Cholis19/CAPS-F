import 'package:appwrite/appwrite.dart';

import '../favorite_model.dart';

class FavoriteService {
  Client client = Client();
  Databases? db;

  ProductService() {
    _init();
  }

  //initialize the application
  _init() async {
    client
        .setEndpoint(AppConstant().endpoint)
        .setProject(AppConstant().projectId);
    db = Databases(client);

    //get current session
    Account account = Account(client);

    try {
      await account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        account
            .createAnonymousSession()
            .then((value) => value)
            .catchError((e) => e);
      }
    }
  }

  Future<List<FavoriteModel>> getAllProducts() async {
    try {
      var data = await db?.listDocuments(
          collectionId: AppConstant().collectionId, databaseId: '');
      var productList = data?.documents
          .map((product) => FavoriteModel.fromJson(product.data))
          .toList();
      return productList!;
    } catch (e) {
      throw Exception('Error getting list of products');
    }
  }

  Future<List<FavoriteModel>> getAllFavourites() async {
    try {
      var data = await db?.listDocuments(
          collectionId: AppConstant().collectionId,
          queries: [Query.equal('isFav', true)],
          databaseId: '');
      var favList = data?.documents
          .map((fav) => FavoriteModel.fromJson(fav.data))
          .toList();
      return favList!;
    } catch (e) {
      throw Exception('Error getting list of favourites');
    }
  }

  Future addAsFav(String id, String name, String description, int stock,
      int price, String imgUrl, bool isFav) async {
    try {
      FavoriteModel updateProduct = FavoriteModel(
          name: name,
          description: description,
          stock: stock,
          price: price,
          imgUrl: imgUrl,
          isFav: isFav);
      var data = await db?.updateDocument(
        collectionId: AppConstant().collectionId,
        documentId: id,
        data: updateProduct.toJson(),
        databaseId: '',
      );
      return data;
    } catch (e) {
      throw Exception('Error updating product');
    }
  }
}
