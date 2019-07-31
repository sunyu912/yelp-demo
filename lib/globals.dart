library my_prj.globals;

String search;

class Restaurant {
  String name;
  // String imagePath;
  String location;
  String recDish1;
  String recDish2;
  String recDish3;

  Restaurant(this.name, this.location, this.recDish1, this.recDish2, this.recDish3);
}

List<Restaurant> lol = [Restaurant("KFC", "Arcadia", "Dumplings", "Pizza", "Meatballs")];

getRests() async {
  return lol;
}

