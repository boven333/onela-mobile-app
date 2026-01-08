import '../../domain/models/product.dart';

class MockCatalog {
  static const categories = <Category>[
    Category(id: 'cat_all', name: 'ทั้งหมด', iconPath: 'assets/icons/icon_all.png'),

    Category(id: 'cat_drink', name: 'เครื่องดื่ม', iconPath: 'assets/icons/icon_drink.png'),
    Category(id: 'cat_clean', name: 'ผลิตภัณฑ์...', iconPath: 'assets/icons/icon_cleaner.png'),
    Category(id: 'cat_egg', name: 'ไข่', iconPath: 'assets/icons/icon_egg.png'),
    Category(id: 'cat_fruit', name: 'ผลไม้', iconPath: 'assets/icons/icon_fruit.png'),
    Category(id: 'cat_herb', name: 'ธัญพืช', iconPath: 'assets/icons/icon_grain.png'),
    Category(
      id: 'cat_snack',
      name: 'พาสต้า...',
      iconPath: 'assets/icons/icon_pasta.png',
    ), // ถ้าชื่อจริงคืออะไร แก้ทีหลัง
    Category(id: 'cat_soup', name: 'สมุนไพร...', iconPath: 'assets/icons/icon_herb.png'),
    Category(id: 'cat_bakery', name: 'น้ำผึ้ง', iconPath: 'assets/icons/icon_honey.png'),
    Category(id: 'cat_dessert', name: 'นมและ...', iconPath: 'assets/icons/icon_milk.png'),
    Category(id: 'cat_mushroom', name: 'เห็ด', iconPath: 'assets/icons/icon_mushroom.png'),
    Category(id: 'cat_paper', name: 'Paper Pr...', iconPath: 'assets/icons/icon_paper.png'),
    Category(id: 'cat_rice', name: 'ข้าว', iconPath: 'assets/icons/icon_rice.png'),
    Category(id: 'cat_seasoning', name: 'เครื่องปรุง', iconPath: 'assets/icons/icon_satt.png'),
    Category(id: 'cat_coffee', name: 'ชา กาแฟ ...', iconPath: 'assets/icons/icon_coffee.png'),
    Category(id: 'cat_veg', name: 'ผัก', iconPath: 'assets/icons/icon_vegetable.png'),
  ];

  // ใช้ placeholder asset เดียวไปก่อน (มึงจะเอารูปจริงทีหลัง)
  static const placeholderImg = 'assets/images/onela_box.png';

  // ✅ ทำให้ mock เยอะๆ
  static final products = _generateProducts();

  static List<Product> _generateProducts() {
    final items = <Product>[];
    int id = 1;

    // ชื่อสินค้า template ต่อหมวด (เอาไว้สุ่มวน)
    final templates = <String, List<Map<String, dynamic>>>{
      'cat_drink': [
        {'name': 'โค้กกระป๋อง', 'subtitle': '325 ml x 24', 'price': 298},
        {'name': 'สไปรท์', 'subtitle': '325 ml x 24', 'price': 311},
        {'name': 'ชาเขียว', 'subtitle': '330 ml x 24', 'price': 325},
        {'name': 'กระทิงแดง', 'subtitle': '150 ml x 10', 'price': 85},
      ],
      'cat_clean': [
        {'name': 'น้ำยาซักผ้า', 'subtitle': '3.2 ลิตร', 'price': 145},
        {'name': 'สเปรย์ทำความสะอาด', 'subtitle': '500 ml', 'price': 65},
        {'name': 'ถุงขยะ', 'subtitle': '24x28 นิ้ว 50 ใบ', 'price': 79},
        {'name': 'แชมพูสระผม', 'subtitle': '450 ml', 'price': 75},
      ],
      'cat_egg': [
        {'name': 'ไข่ไก่', 'subtitle': 'เบอร์ 2 (30 ฟอง)', 'price': 125},
        {'name': 'ไข่เป็ด', 'subtitle': '10 ฟอง', 'price': 65},
        {'name': 'ไข่เค็ม', 'subtitle': '10 ฟอง', 'price': 85},
      ],
      'cat_fruit': [
        {'name': 'มะละกอ', 'subtitle': '1-2 ลูก', 'price': 58},
        {'name': 'แตงโม', 'subtitle': '2-3 กก', 'price': 65},
        {'name': 'เสาวรส', 'subtitle': '1 กก', 'price': 50},
        {'name': 'กล้วยหอม', 'subtitle': '1-2 หวี', 'price': 75},
        {'name': 'อะโวคาโด', 'subtitle': '1 กก', 'price': 65},
      ],
      'cat_veg': [
        {'name': 'มะเขือเทศ', 'subtitle': '500 กรัม', 'price': 38},
        {'name': 'มะเขือเทศลูกใหญ่', 'subtitle': '1 กก', 'price': 120},
        {'name': 'คะน้า', 'subtitle': '1 กก', 'price': 75},
        {'name': 'บีทรูท', 'subtitle': '1 กก', 'price': 45},
        {'name': 'แตงกวาญี่ปุ่น', 'subtitle': '1 กก', 'price': 70},
      ],
      'cat_rice': [
        {'name': 'ข้าวหอมมะลิ', 'subtitle': '1 กก', 'price': 55},
        {'name': 'ข้าวกล้องแดง', 'subtitle': '1 กก', 'price': 68},
        {'name': 'ข้าวหอมปทุม', 'subtitle': '1 กก', 'price': 45},
        {'name': 'ข้าวเหนียวดำ', 'subtitle': '1 กก', 'price': 80},
      ],
      'cat_seasoning': [
        {'name': 'ผงปรุงรส', 'subtitle': '165 กรัม', 'price': 24},
        {'name': 'ซอสปรุงรส', 'subtitle': '1 ขวด', 'price': 38},
        {'name': 'น้ำปลา', 'subtitle': '1 ลิตร', 'price': 70},
        {'name': 'น้ำส้มสายชู', 'subtitle': '1.8 ลิตร', 'price': 150},
        {'name': 'น้ำมันพืช', 'subtitle': '5 ลิตร', 'price': 230},
      ],
      'cat_coffee': [
        {'name': 'กาแฟผง', 'subtitle': '250 กรัม', 'price': 265},
        {'name': 'น้ำดื่ม', 'subtitle': '1.5 ลิตร x 6', 'price': 55},
        {'name': 'น้ำส้ม', 'subtitle': '100% 2 ลิตร', 'price': 145},
        {'name': 'น้ำผลไม้', 'subtitle': '180 ml x 12', 'price': 205},
      ],
      'cat_paper': [
        {'name': 'กระดาษทิชชู่', 'subtitle': '20 ม้วน', 'price': 60},
        {'name': 'ทิชชู่เปียก', 'subtitle': '1200 แผ่น', 'price': 115},
        {'name': 'กระดาษชำระ', 'subtitle': 'แพ็ค 3', 'price': 93},
        {'name': 'กระดาษ A4', 'subtitle': '115 แผ่น', 'price': 89},
      ],
      'cat_mushroom': [
        {'name': 'เห็ดหอม', 'subtitle': '0.5 กก', 'price': 185},
        {'name': 'เห็ดหลินจือ', 'subtitle': '0.5 กก', 'price': 55},
        {'name': 'เห็ดหูหนู', 'subtitle': '0.5 กก', 'price': 50},
        {'name': 'เห็ดออรินจิ', 'subtitle': '0.5 กก', 'price': 58},
        {'name': 'เห็ดเข็มทอง', 'subtitle': '0.5 กก', 'price': 45},
      ],
      'cat_honey': [
        {'name': 'น้ำผึ้งแท้', 'subtitle': '250 กรัม', 'price': 200},
        {'name': 'รวงผึ้ง', 'subtitle': '300 กรัม', 'price': 350},
      ],
    };

    // สร้างหมวดละ 20 ชิ้น (ปรับเลขนี้ได้)
    const perCategory = 15;

    for (final entry in templates.entries) {
      final catId = entry.key;
      final list = entry.value;

      for (var i = 0; i < perCategory; i++) {
        final t = list[i % list.length];
        items.add(
          Product(
            id: 'p$id',
            name: '${t['name']} ${i + 1}', // ใส่เลขท้ายให้ไม่ซ้ำ
            subtitle: t['subtitle'] as String,
            price: (t['price'] as int) + (i % 5) * 3, // ให้ราคามันขยับนิดๆ ดูสมจริง
            imageAsset: placeholderImg,
            categoryId: catId,
          ),
        );
        id++;
      }
    }

    return items;
  }
}
