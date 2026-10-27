import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../models/food.dart';
import '../../models/restaurant.dart';

/// Danh mục món ăn & nhà hàng phong phú cho tất cả các mục đồ ăn:
/// - Món Việt & Cơm (`Vietnamese`): 4 món
/// - Món Nước - Phở & Bún (`Noodles`): 4 món
/// - Đồ ăn nhanh & Combo (`Fast food`): 4 món
/// - Trà sữa & Cafe (`Drinks`): 4 món
/// - Bánh ngọt & Ăn vặt (`Dessert`): 4 món
class SampleFoodCatalog {
  SampleFoodCatalog._();

  static const List<Food> defaultFoods = [
    // --- 1. MÓN VIỆT & CƠM (Vietnamese) ---
    Food(
      id: 'food_vn_1',
      name: 'Cơm tấm sườn bì chả đặc biệt',
      price: 55000,
      description: 'Sườn cốt lết nướng than hoa thơm lừng ăn kèm bì thính, chả trứng và mỡ hành.',
      category: 'Vietnamese',
      restaurantId: 'res_2',
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_vn_2',
      name: 'Bún chả que tre phố cổ Hà Nội',
      price: 50000,
      description: 'Chả viên và thịt ba chỉ nướng than hoa ăn cùng nước mắm đu đủ chua ngọt.',
      category: 'Vietnamese',
      restaurantId: 'res_1',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),
    Food(
      id: 'food_vn_3',
      name: 'Cơm gà xối mỡ da giòn Hội An',
      price: 48000,
      description: 'Đùi gà góc tư chiên xối mỡ da giòn rụm, cơm nấu nước luộc gà vàng ươm.',
      category: 'Vietnamese',
      restaurantId: 'res_2',
      imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),
    Food(
      id: 'food_vn_4',
      name: 'Nem nướng Nha Trang mẹt đầy đặn',
      price: 65000,
      description: 'Mẹt nem nướng lụi than hồng kèm bánh tráng chiên giòn, xoài chua và sốt đậu phộng.',
      category: 'Vietnamese',
      restaurantId: 'res_1',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),

    // --- 2. MÓN NƯỚC: PHỞ, BÚN, MÌ (Noodles) ---
    Food(
      id: 'food_nd_1',
      name: 'Phở bò tái nạm gầu Bờ Hồ',
      price: 45000,
      description: 'Nước dùng ninh xương ống bò 12 tiếng trong ngọt, thịt bò tươi mềm thơm phức.',
      category: 'Noodles',
      restaurantId: 'res_1',
      imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_nd_2',
      name: 'Bún bò Huế giò heo chả cua',
      price: 52000,
      description: 'Đậm đà hương sả ruốc chuẩn vị cố đô với bắp bò hoa, giò heo và chả cua tươi.',
      category: 'Noodles',
      restaurantId: 'res_1',
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),
    Food(
      id: 'food_nd_3',
      name: 'Mì Ramen Tonkotsu trứng lòng đào',
      price: 62000,
      description: 'Sợi mì tươi dai ngon trong nước hầm xương heo béo ngậy kèm thịt xá xíu và trứng ngâm tương.',
      category: 'Noodles',
      restaurantId: 'res_2',
      imageUrl: 'https://images.unsplash.com/photo-1557872943-16a5ac26437e?w=600&auto=format&fit=crop&q=80',
      rating: 4.7,
    ),
    Food(
      id: 'food_nd_4',
      name: 'Hủ tiếu Nam Vang tôm thịt đặc biệt',
      price: 48000,
      description: 'Tô hủ tiếu đầy ắp tôm tươi, thịt bằm, trứng cút và tóp mỡ hành phi thơm giòn.',
      category: 'Noodles',
      restaurantId: 'res_2',
      imageUrl: 'https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),

    // --- 3. ĐỒ ĂN NHANH & COMBO (Fast food) ---
    Food(
      id: 'food_ff_1',
      name: 'Combo Gà rán giòn cay + Khoai + Pepsi',
      price: 69000,
      description: '2 miếng gà rán lớp vỏ giòn tan cay nhẹ kèm khoai tây chiên lắc phô mai và 1 ly Pepsi.',
      category: 'Fast food',
      restaurantId: 'res_2',
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_ff_2',
      name: 'Burger Bò Mỹ 2 tầng đẫm phô mai',
      price: 65000,
      description: '2 lớp thịt bò Mỹ nướng lửa hồng kẹp phô mai Cheddar tan chảy và sốt BBQ.',
      category: 'Fast food',
      restaurantId: 'res_2',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),
    Food(
      id: 'food_ff_3',
      name: 'Pizza Hải sản sốt Pesto phô mai kéo sợi',
      price: 99000,
      description: 'Đế bánh tươi nướng củi phủ tôm sú, mực ống và ngập phô mai Mozzarella.',
      category: 'Fast food',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_ff_4',
      name: 'Mì Ý Bò bằm sốt cà chua đút lò',
      price: 58000,
      description: 'Sốt Bolognese bò Úc hầm cà chua tươi phủ lớp phô mai đút lò vàng óng.',
      category: 'Fast food',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=600&auto=format&fit=crop&q=80',
      rating: 4.7,
    ),

    // --- 4. TRÀ SỮA & CAFE (Drinks) ---
    Food(
      id: 'food_dr_1',
      name: 'Trà sữa trân châu đường đen kem trứng',
      price: 35000,
      description: 'Sữa tươi thanh trùng kết hợp trân châu hoàng kim đường đen và lớp kem trứng khè.',
      category: 'Drinks',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1558857563-b37cf05d8a58?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_dr_2',
      name: 'Trà đào cam sả nhiệt đới mát lạnh',
      price: 32000,
      description: 'Trà nhài ủ lạnh thanh mát kết hợp miếng đào giòn ngọt, cam vàng và hương sả.',
      category: 'Drinks',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),
    Food(
      id: 'food_dr_3',
      name: 'Cà phê muối Huế kem béo thơm lừng',
      price: 29000,
      description: 'Cà phê phin đậm đà hòa quyện lớp kem muối mặn ngọt béo ngậy gây thương nhớ.',
      category: 'Drinks',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_dr_4',
      name: 'Matcha Latte Nhật Bản kem Cheese',
      price: 38000,
      description: 'Bột trà xanh Uji Nhật Bản đánh bông cùng sữa tươi và lớp kem phô mai mặn.',
      category: 'Drinks',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),

    // --- 5. BÁNH NGỌT, BÁNH MÌ & ĂN VẶT (Dessert) ---
    Food(
      id: 'food_ds_1',
      name: 'Bánh mì thịt nướng pate bơ đặc biệt',
      price: 30000,
      description: 'Bánh mì giòn rụm kẹp thịt nướng than hoa, pate gan nhà làm, đồ chua và sốt bơ trứng.',
      category: 'Dessert',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1626804475297-41608ea09aeb?w=600&auto=format&fit=crop&q=80',
      rating: 4.8,
    ),
    Food(
      id: 'food_ds_2',
      name: 'Bánh sừng bò Croissant trứng muối tan chảy',
      price: 36000,
      description: 'Vỏ bánh ngàn lớp bơ Pháp nướng giòn rụm bên ngoài, nhân kim sa trứng muối chảy bên trong.',
      category: 'Dessert',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_ds_3',
      name: 'Bánh Tiramisu cacao Ý mềm mịn',
      price: 42000,
      description: 'Cốt bánh Sampa thấm đẫm rượu Rum và Espresso xen kẽ kem phô mai Mascarpone.',
      category: 'Dessert',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&fit=crop&q=80',
      rating: 4.9,
    ),
    Food(
      id: 'food_ds_4',
      name: 'Chè khúc bạch hạnh nhân nhãn lồng',
      price: 32000,
      description: 'Khúc bạch phô mai béo mịn ăn kèm nhãn lồng giòn ngọt và hạnh nhân lát rang thơm.',
      category: 'Dessert',
      restaurantId: 'res_3',
      imageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600&auto=format&fit=crop&q=80',
      rating: 4.7,
    ),
  ];

  static const List<Restaurant> defaultRestaurants = [
    Restaurant(
      id: 'res_1',
      name: 'Phở Thìn Bờ Hồ - Đặc Sản Hà Nội',
      address: '13 Lò Đúc, Hai Bà Trưng, Hà Nội',
      rating: 4.9,
    ),
    Restaurant(
      id: 'res_2',
      name: 'Cơm Tấm & Gà Giòn Sài Gòn Xưa',
      address: '45 Nguyễn Huệ, Quận 1, TP.HCM',
      rating: 4.8,
    ),
    Restaurant(
      id: 'res_3',
      name: 'Bánh Ngọt & Trà Sữa Tiệm Nhà Mây',
      address: '102 Cầu Giấy, Hà Nội',
      rating: 4.8,
    ),
  ];

  /// Danh sách các món Flash Deal hiển thị ở thanh cuộn ngang "Ưu đãi món ngon hôm nay"
  static List<Food> get flashDeals => [
        defaultFoods[4], // Phở bò tái nạm gầu Bờ Hồ
        defaultFoods[0], // Cơm tấm sườn bì chả đặc biệt
        defaultFoods[8], // Combo Gà rán giòn cay + Khoai + Pepsi
        defaultFoods[12], // Trà sữa trân châu đường đen kem trứng
        defaultFoods[10], // Pizza Hải sản sốt Pesto phô mai kéo sợi
        defaultFoods[17], // Bánh sừng bò Croissant trứng muối tan chảy
      ];

  /// Danh sách các món yêu thích hiển thị ở mục "Tiếp tục đặt món yêu thích"
  static List<Food> get favoriteFoods => [
        defaultFoods[4], // Phở bò tái nạm gầu Bờ Hồ
        defaultFoods[1], // Bún chả que tre phố cổ Hà Nội
        defaultFoods[0], // Cơm tấm sườn bì chả đặc biệt
        defaultFoods[12], // Trà sữa trân châu đường đen kem trứng
        defaultFoods[8], // Combo Gà rán giòn cay + Khoai + Pepsi
      ];

  /// Lấy thông tin chi tiết người bán / cửa hàng (bao gồm cả Số điện thoại cửa hàng)
  static ({
    String storeName,
    String ownerName,
    String phone,
    String address,
    String distance,
    String prepTime,
    String openHours,
    double rating,
    int reviewCount,
  }) getSellerInfo(Food food) {
    final lowerCat = food.category.toLowerCase();
    if (food.restaurantId == 'res_1' ||
        lowerCat.contains('noodle') ||
        lowerCat.contains('món nước')) {
      return (
        storeName: 'Phở Thìn Bờ Hồ - Đặc Sản Hà Nội',
        ownerName: 'Nghệ nhân Nguyễn Trọng Thìn • Đối tác Chính hãng',
        phone: '0904.123.888',
        address: '13 Lò Đúc, Quận Hai Bà Trưng, Hà Nội',
        distance: '1.2 km',
        prepTime: '12 - 15 phút',
        openHours: '06:00 - 22:30',
        rating: 4.9,
        reviewCount: 420,
      );
    } else if (food.restaurantId == 'res_3' ||
        lowerCat.contains('drink') ||
        lowerCat.contains('dessert') ||
        lowerCat.contains('đồ uống') ||
        lowerCat.contains('bánh')) {
      return (
        storeName: 'Bánh Ngọt & Trà Sữa Tiệm Nhà Mây',
        ownerName: 'Chef Hoàng Lan Anh • Bếp Bánh & Trà Tươi',
        phone: '0988.654.321',
        address: '102 Xuân Thủy, Quận Cầu Giấy, Hà Nội',
        distance: '0.9 km',
        prepTime: '8 - 12 phút',
        openHours: '07:30 - 23:00',
        rating: 4.8,
        reviewCount: 315,
      );
    }
    return (
      storeName: 'Cơm Tấm & Gà Giòn Sài Gòn Xưa',
      ownerName: 'Bếp trưởng Trần Minh Khang • Chuẩn vị truyền thống',
      phone: '0912.999.686',
      address: '45 Nguyễn Huệ, Quận 1 / Chi nhánh Cầu Giấy',
      distance: '1.5 km',
      prepTime: '15 - 20 phút',
      openHours: '07:00 - 22:00',
      rating: 4.8,
      reviewCount: 510,
    );
  }

  /// Gộp danh sách món từ Firestore với danh mục 20 món mẫu để đảm bảo
  /// mọi mục đồ ăn đều luôn có đầy đủ các món ngon hiển thị.
  static List<Food> mergeWithFirestoreFoods(List<Food> firestoreFoods) {
    final byId = <String, Food>{};
    final existingNames = <String>{};

    for (final food in firestoreFoods) {
      byId[food.id] = food;
      existingNames.add(food.name.trim().toLowerCase());
    }

    for (final sample in defaultFoods) {
      if (!byId.containsKey(sample.id) &&
          !existingNames.contains(sample.name.trim().toLowerCase())) {
        byId[sample.id] = sample;
      }
    }

    return byId.values.toList();
  }

  /// Đồng bộ toàn bộ 20 món ăn & 3 nhà hàng lên Firestore nếu ứng dụng đang kết nối Firebase
  static Future<void> seedToFirestoreIfNeeded() async {
    if (Firebase.apps.isEmpty) return;
    try {
      final db = FirebaseFirestore.instance;
      final foodsSnap = await db.collection('foods').get();
      if (foodsSnap.docs.length < defaultFoods.length) {
        final batch = db.batch();
        for (final food in defaultFoods) {
          final ref = db.collection('foods').doc(food.id);
          batch.set(ref, food.toMap(), SetOptions(merge: true));
        }
        for (final res in defaultRestaurants) {
          final ref = db.collection('restaurants').doc(res.id);
          batch.set(ref, res.toMap(), SetOptions(merge: true));
        }
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SampleFoodCatalog Firestore sync skipped: $e');
      }
    }
  }
}

