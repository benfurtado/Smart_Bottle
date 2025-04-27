from django.db import models

# Create your models here.


from django.db import models
from django.utils import timezone

class StableWaterLevel(models.Model):
    timestamp = models.DateTimeField(default=timezone.now)
    volume_ml = models.FloatField()

    def __str__(self):
        return f"{self.timestamp.strftime('%Y-%m-%d %H:%M:%S')} - {self.volume_ml} mL"
