class MenuObj {
  String _menuURL = '';
  List _itemsAndPrices = [];
  List<String> _itemsFromMenu = [];
  List<double> _pricesFromMenu = [];
  String _restaurantStripeAccount;
  List _fullQuery = [];
  double _tax;

  void setMenuURL(String url) => this._menuURL = url;

  void setTax(double tax) => this._tax = tax;

  void setFullQuery(List query) => this._fullQuery = query;

  void setRestaurantStripeAccount(String account) =>
      this._restaurantStripeAccount = account;

  void setItemsAndPrices(List itemsAndPrices) =>
      this._itemsAndPrices = itemsAndPrices;

  void addItemsFromMenu(List<String> item) => this._itemsFromMenu.addAll(item);

  void addPricesFromMenu(List<double> price) =>
      this._pricesFromMenu.addAll(price);

  void resetMenuItems() => this._itemsAndPrices.clear();



  double getTax() => this._tax;

  List getFullQuery() => this._fullQuery;

  String getRestaurantStripeAccount() => this._restaurantStripeAccount;

  List getItemsAndPrices() => this._itemsAndPrices;

  String getMenuURL() => this._menuURL;

  void reset() {
    this._itemsAndPrices.clear();
    this._pricesFromMenu.clear();
    this._itemsFromMenu.clear();
    this._restaurantStripeAccount = null;
    this._fullQuery.clear();
    this._tax = null;
  }
}
