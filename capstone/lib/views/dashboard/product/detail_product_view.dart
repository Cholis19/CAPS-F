import 'package:flutter/material.dart';
import 'package:mobile_flutter/models/item_cart_model.dart';
import 'package:mobile_flutter/models/product_model.dart';
import 'package:mobile_flutter/shared/buttons.dart';
import 'package:mobile_flutter/shared/format_rupiah.dart';
import 'package:mobile_flutter/shared/popup_dialog.dart';
import 'package:mobile_flutter/views/dashboard/product/cart_provider.dart';
import 'package:mobile_flutter/views/dashboard/product/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/api/favorite_api.dart';
import '../../../models/favorite_model.dart';

class DetailProductView extends StatefulWidget {
  final int index;
  const DetailProductView({super.key, required this.index});

  @override
  State<DetailProductView> createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  List<FavoriteModel>? products;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _getProductList();
    super.initState();
  }

  _getProductList() {
    setState(() {
      _isLoading = true;
    });
    FavoriteService().getAllProducts().then((value) {
      setState(() {
        products = value;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  _addAsFavourite(String id, String name, String description, int stock,
      int price, String imgUrl, bool isFav, int index) {
    FavoriteService()
        .addAsFav(
            name, description, imgUrl, id as int, stock, price as String, isFav)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('favourites updated successfully!')),
      );
      setState(() {
        products![index].isFav = isFav;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding favourite!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductModel product =
        Provider.of<ProductProvider>(context).products[widget.index];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 420,
                        child: Hero(
                          tag: product.id,
                          child: Image(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(product.imgUrl),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 30,
                          left: -20,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: Row(
                              children: [
                                const SizedBox(width: 30),
                                customBackButton(context),
                              ],
                            ),
                          )),
                      Positioned(
                        top: 30,
                        right: -40,
                        child: Container(
                          padding: const EdgeInsets.only(right: 50, left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => popupMessageDialog(
                                        context,
                                        judul: 'Maaf',
                                        content:
                                            ' Akun Anda belum terdaftar. Silahkan daftar akun untuk menikmati fitur ini.'),
                                  );
                                },
                                icon: const Icon(Icons.favorite_outline,
                                    color: Color(0xFF264ECA)),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.shopping_cart_outlined,
                                    color: Color(0xFF264ECA)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset:
                              const Offset(0, -1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            formatRupiah(product.price),
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF264ECA)),
                          ),
                          Text(
                            '100+ Terfavorit',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Divider(),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          buyNowButton(
            context,
            leftContent: IconButton(
              onPressed: () {
                showBuyNowDialog(context, product);
              },
              icon: const Icon(Icons.shopping_cart_outlined,
                  color: Color(0xFF264ECA)),
            ),
            labelButton: 'Beli Sekarang',
            onPressed: () {
              //notAMember(context);
              final ItemCartModel item =
                  ItemCartModel(product: product, itemCount: 1);
              Provider.of<CartProvider>(context, listen: false).addToCart(item);
              Navigator.pushNamed(context, '/checkout');
            },
          )
        ],
      ),
    );
  }

  Future<void> notAMember(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Image(image: AssetImage('assets/images/sorry.png')),
                  const Text(
                    'Maaf, akun Anda belum terdaftar. Silahkan daftar akun untuk dapat melakukan pembelian produk.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 50),
                  fullWidthButton(
                      label: 'Daftar Akun',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/welcome', (route) => false);
                      }),
                  const SizedBox(height: 50)
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showBuyNowDialog(BuildContext context, ProductModel product) {
    int itemCount = 1;
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Wrap(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image(
                          width: MediaQuery.of(context).size.width * 0.4,
                          image: NetworkImage(product.imgUrl),
                        ),
                        Expanded(
                            child: Text(formatRupiah(product.price),
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF264ECA)),
                                textAlign: TextAlign.end))
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jumlah',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                              color: const Color(0xFFEAF2FF),
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            children: [
                              miniButton(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    if (itemCount > 1) {
                                      setState(() {
                                        itemCount--;
                                      });
                                    }
                                  }),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  itemCount.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              miniButton(
                                icon: Icons.add,
                                onPressed: () {
                                  setState(() {
                                    itemCount++;
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    fullWidthButton(
                      label: 'Beli Sekarang',
                      onPressed: () {
                        Navigator.pop(context);
                        notAMember(context);
                      },
                    )
                  ],
                ),
              ),
            ]);
          },
        );
      },
    );
  }
}
