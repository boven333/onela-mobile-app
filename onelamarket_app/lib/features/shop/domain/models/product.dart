class Product {
  final String id;
  final String name;
  final String subtitle;
  final int price; // THB (บาท)
  final String imageAsset; // mock ใช้ asset หรือ placeholder
  final String categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageAsset,
    required this.categoryId,
  });
}

class Category {
  final String id;
  final String name;
  final String? iconPath; // เดี๋ยวค่อยใส่ asset จริง

  const Category({required this.id, required this.name, this.iconPath});
}
