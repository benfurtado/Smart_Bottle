from django.urls import path
from . import views

urlpatterns = [
    path('get-distance/', views.get_distance, name='get_distance'),
]
