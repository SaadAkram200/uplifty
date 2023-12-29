class AppImages {
  static String base = "assets/images/";
  static String logo = getName("logo.png");
  static String logo2 = getName("logo2.png");
  static String seen = getName("seen5.png");
  static String unseen = getName("unseen5.png");
  static String dummyuser = getName("dummyuser.jpg");

  static String getName(String str) {
    return "$base$str";
  }
}
