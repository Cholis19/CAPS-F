import 'package:flutter/material.dart';

import '../../../models/api/favorite_api.dart';
import '../../../models/favorite_model.dart'; //add this

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);
  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<FavoriteModel>? favourites;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _getFavList();
    super.initState();
  }

  _getFavList() {
    setState(() {
      _isLoading = true;
    });
    FavoriteService().getAllFavourites().then((value) {
      setState(() {
        favourites = value;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'Error loading products',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : favourites!.isEmpty
                ? const Center(
                    child: Text(
                      'No items added to favourites yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: favourites?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favourites![index].name,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(favourites![index].description)
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
  }
}
