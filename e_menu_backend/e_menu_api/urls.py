from django.urls import path, include
from rest_framework import routers
from e_menu_api import views


router = routers.DefaultRouter()
router.register(r'restaurant', views.RestaurantView, 'restaurant')
router.register(r'order', views.OrderView, 'order')
router.register(r'item', views.ItemView, 'item')


urlpatterns = [
  path('', views.home, name='home'),
  path('features', views.features, name='features'),
  path('emenucustomer', views.eMenuCustomer, name='eMenuCustomer'),
  path('updates', views.updates, name='updates'),
  path('contact', views.contact, name='contact'),
  path('privacy', views.privacy, name='privacy'),
  path('terms', views.terms, name='terms'),
  path('api/', include(router.urls)),
]
