from rest_framework import serializers

class DistanceSerializer(serializers.Serializer):
    distance = serializers.FloatField()
