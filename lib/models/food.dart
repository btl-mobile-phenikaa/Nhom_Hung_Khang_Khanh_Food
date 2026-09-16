class Food {
  int id;
  String name;
  double price;
  String description;
  String category;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  void setFood(
    int id,
    String name,
    double price,
    String description,
    String category,
  ) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.description = description;
    this.category = category;
  }

  String getFoodName() {
    return name;
  }

  double getPrice() {
    return price;
  }

  String getFoodInfo() {
    return 'ID: $id\n'
        'Tên món: $name\n'
        'Giá: $price VNĐ\n'
        'Mô tả: $description\n'
        'Danh mục: $category';
  }
}
