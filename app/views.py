from django.http import HttpResponse
from .models import Student



from django.shortcuts import render, redirect
from .forms import PersonForm
from .models import Person

def person_form(request):
    if request.method == "POST":
        form = PersonForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('person_list')
    else:
        form = PersonForm()
    return render(request, "app/form.html", {"form": form})

def person_list(request):
    people = Person.objects.all()
    return render(request, "app/list.html", {"people": people})

def home(request):
    students = Student.objects.all()
    names = ", ".join([s.name for s in students])
    return HttpResponse(f"Students: {names}")
