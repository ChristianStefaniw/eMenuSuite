from django.shortcuts import render
import django_filters
from django.http import HttpResponse
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets
from rest_framework.decorators import action

from e_menu_api import models
from e_menu_api.serializers import RestaurantSerializer, ItemSerializer, OrderSerializer
from e_menu_api.models import Restaurant, Item, Order
from e_menu_backend.settings import TEMPLATE_DIR


# WEBSITE VIEWS

def home(request):
    numOfRestaurants = {'num': models.Restaurant.objects.count()}
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/index.html", numOfRestaurants)


def eMenuCustomer(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/eMenuCustomer.html")


def features(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/features.html")


def updates(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/updates.html")


def contact(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/contact.html")

def privacy(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/privacy.html")

def terms(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/terms.html")

def download(request):
    return render(request, TEMPLATE_DIR + "/e_menu/HTML/download.html")

# API Views

class RestaurantView(viewsets.ModelViewSet):
    filter_fields = ['name']
    lookup_field = 'name'
    filter_backends = (django_filters.rest_framework.DjangoFilterBackend,)
    serializer_class = RestaurantSerializer
    queryset = Restaurant.objects.all()

    def create(self, request, *args, **kwargs):
        response = RestaurantSerializer(data=request.data)
        if response.is_valid():
            response.save()
            return HttpResponse("Done")
        else:
            return HttpResponse(response)

    def update(self, request, *args, **kwargs):
        obj = self.get_object()
        response = RestaurantSerializer(obj, data=request.data, partial=True)
        if response.is_valid():
            response.save()
            return HttpResponse("Done")
        else:
            return HttpResponse(response)


class ItemView(viewsets.ModelViewSet):
    filter_fields = ['restaurant']
    filter_backends = (django_filters.rest_framework.DjangoFilterBackend,)
    lookup_field = 'item'
    serializer_class = ItemSerializer
    queryset = Item.objects.all()

    def create(self, request, *args, **kwargs):
        response = ItemSerializer(data=request.data)
        if response.is_valid():
            response.save()
            return HttpResponse("Done")
        else:
            return HttpResponse(response)

    @action(methods=['delete'], detail=False)
    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return HttpResponse("Done")

    def update(self, request, *args, **kwargs):
        obj = self.get_object()
        response = ItemSerializer(obj, data=request.data, partial=True)
        if response.is_valid():
            response.save()
            return HttpResponse("Done")
        else:
            return HttpResponse(response)


class OrderView(viewsets.ModelViewSet):
    queryset = Order.objects.all().order_by('time')
    serializer_class = OrderSerializer
    filter_fields = ('restaurant', 'phonenum')
    lookup_field = 'phonenum'
    filter_backends = [DjangoFilterBackend]

    def create(self, request, *args, **kwargs):
        response = OrderSerializer(data=request.data)
        if response.is_valid():
            response.save()
            return HttpResponse("Done")
        else:
            return HttpResponse(response)

    @action(methods=['delete'], detail=False)
    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return HttpResponse("Done")

    def update(self, request, *args, **kwargs):
        obj = self.get_object()
        response = OrderSerializer(obj, data=request.data, partial=True)
        if response.is_valid():
            response.save()
            return HttpResponse("Done")
        else:
            return HttpResponse(response)
