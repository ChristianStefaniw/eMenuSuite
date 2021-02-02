from django.db import models


class Restaurant(models.Model):
    name = models.TextField(primary_key=True, unique=True)
    tip = models.FloatField(default=0.0)
    tax = models.FloatField()
    stripeid = models.TextField()
    password = models.TextField()
    currency = models.TextField()
    taxed = models.FloatField(default=0.0)
    lastTaxedReset = models.DateTimeField()
    lastTipReset = models.DateTimeField()
    menuurl = models.URLField()

    def __str__(self):
        return str(self.name)


class Order(models.Model):
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    time = models.DateTimeField(primary_key=True)
    chosen = models.BooleanField(default=False)
    tax = models.FloatField()
    tip = models.FloatField()
    cost = models.FloatField()
    items = models.TextField()
    notes = models.TextField(null=True, blank=True)
    phonenum = models.TextField()
    tablenum = models.IntegerField()

    def __str__(self):
        return str(self.time)


class Item(models.Model):
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    price = models.FloatField()
    item = models.TextField()
    req = models.BooleanField(default=False)

    def __str__(self):
        return self.item
