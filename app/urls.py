from django.urls import path
from . import views


urlpatterns = [
    path("form/", views.person_form, name="person_form"),
    path("list/", views.person_list, name="person_list"),
]

# urlpatterns = [
#     path('', views.home, name='home'),
# ]
