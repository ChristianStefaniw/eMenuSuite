from rest_framework import serializers
from e_menu_api.models import Restaurant, Item, Order


class RestaurantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Restaurant
        fields = ('name', 'tip', 'tax', 'stripeid', 'password', 'currency', 'taxed', 'lastTaxedReset', 'lastTipReset', 'menuurl')


class ItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = Item
        fields = ('restaurant', 'price', 'item', 'req')


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ('restaurant', 'time', 'chosen', 'cost', 'items', 'notes', 'phonenum', 'tablenum', 'tip', 'tax')
