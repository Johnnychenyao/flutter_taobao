class ProductItemModel {
  String jumpurl;
  String bgColor;
  String picurl;
  String title;
  String titleColor;
  String subtitle;
  String subtitleColor;
  ProductItemModel({
    this.jumpurl,
    this.bgColor,
    this.picurl,
    this.title,
    this.titleColor,
    this.subtitle,
    this.subtitleColor
  });
  factory ProductItemModel.fromJson(Map<String, dynamic> json){
    return ProductItemModel(
      bgColor: json['bg_color'],
      jumpurl: json['jump_url'],
      picurl: json['pic_url'],
      title: json['title'],
      titleColor: json['title_color'],
      subtitle: json['subtitle'],
      subtitleColor: json['subtitle_color'],
    );
  }
}

class ProductListModel {
  List<ProductItemModel> items;
  String title;

  ProductListModel({this.items, this.title});
  factory ProductListModel.fromJson(Map<String, dynamic> json){
    var itemsList = json['items'] as List;
    var menueItems = itemsList.map((i) {
      return ProductItemModel.fromJson(i);
    }).toList();

    return ProductListModel(items: menueItems, title: json['title']);
  }
}