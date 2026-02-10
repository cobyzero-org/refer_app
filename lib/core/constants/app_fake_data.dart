import 'package:refer_app/core/entities/category_entity.dart';
import 'package:refer_app/core/entities/product_entity.dart';
import 'package:refer_app/core/entities/sub_category_entity.dart';

class AppFakeData {
  static List<CategoryEntity> categories = [
    CategoryEntity(id: '1', name: 'Bebidas'),
    CategoryEntity(id: '2', name: 'Alimentos'),
    CategoryEntity(id: '3', name: 'Merch & Café en Grano'),
    CategoryEntity(id: '4', name: 'Packs & Boxes'),
    CategoryEntity(id: '5', name: 'Bebidas'),
    CategoryEntity(id: '6', name: 'Alimentos'),
    CategoryEntity(id: '7', name: 'Merch & Café en Grano'),
    CategoryEntity(id: '8', name: 'Packs & Boxes'),
    CategoryEntity(id: '9', name: 'Bebidas'),
    CategoryEntity(id: '10', name: 'Alimentos'),
    CategoryEntity(id: '11', name: 'Merch & Café en Grano'),
    CategoryEntity(id: '12', name: 'Packs & Boxes'),
  ];

  static List<SubCategoryEntity> subCategories = [
    SubCategoryEntity(id: '1', name: 'Frappuccinos'),
    SubCategoryEntity(id: '2', name: 'Café Caliente'),
    SubCategoryEntity(id: '3', name: 'Té Caliente'),
    SubCategoryEntity(id: '4', name: 'Chocolates Calientes'),
    SubCategoryEntity(id: '5', name: 'Té Caliente'),
    SubCategoryEntity(id: '6', name: 'Chocolates Calientes'),
  ];

  static List<ProductEntity> products = [
    ProductEntity(
      id: '1',
      name: 'Pistacho Mocha Blanco Frappuccino',
      price: 10.0,
      image: 'assets/images/product.png',
      description: 'Bebidas',
      category: categories[0],
      subCategory: subCategories[0],
    ),
    ProductEntity(
      id: '2',
      name: 'Pistacho Frappuccino',
      price: 20.0,
      image: 'assets/images/product.png',
      description: 'Alimentos',
      category: categories[1],
      subCategory: subCategories[1],
    ),
    ProductEntity(
      id: '3',
      name: 'Manjar Blanco Frappuccino',
      price: 30.0,
      image: 'assets/images/product.png',
      description: 'Merch & Café en Grano',
      category: categories[2],
      subCategory: subCategories[2],
    ),
    ProductEntity(
      id: '4',
      name: 'Black & White Mocha Frappuccino',
      price: 40.0,
      image: 'assets/images/product.png',
      description: 'Packs & Boxes',
      category: categories[3],
      subCategory: subCategories[3],
    ),
    ProductEntity(
      id: '5',
      name: 'Black & White Mocha Frappuccino',
      price: 40.0,
      image: 'assets/images/product.png',
      description: 'Packs & Boxes',
      category: categories[3],
      subCategory: subCategories[3],
    ),
    ProductEntity(
      id: '6',
      name: 'Black & White Mocha Frappuccino',
      price: 40.0,
      image: 'assets/images/product.png',
      description: 'Packs & Boxes',
      category: categories[3],
      subCategory: subCategories[3],
    ),
  ];
}
