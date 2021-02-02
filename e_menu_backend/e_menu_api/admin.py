from django.contrib import admin
from .models import Order, Item, Restaurant


class OrdersAdmin(admin.ModelAdmin):
    list_display = ('restaurant', 'time', 'chosen', 'cost', 'items', 'notes', 'phonenum', 'tablenum', 'tip', 'tax')


class ItemAdmin(admin.ModelAdmin):
    list_display = ('restaurant', 'item', 'price', 'req')


class RestaurantAdmin(admin.ModelAdmin):
    list_display = ('name', 'tip', 'tax', 'stripeid', 'password', 'currency', 'taxed', 'lastTaxedReset', 'lastTipReset',
                    'menuurl')


admin.site.register(Restaurant, RestaurantAdmin)
admin.site.register(Order, OrdersAdmin)
admin.site.register(Item, ItemAdmin)
