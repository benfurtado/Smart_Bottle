import re
import serial
import time
from datetime import timedelta

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from django.utils import timezone
from .models import StableWaterLevel  # import your model

# Serial config
SERIAL_PORT = 'COM3'
BAUD_RATE = 9600
TIMEOUT = 2

# Bottle calibration
MAX_DISTANCE_CM = 20.0
MIN_DISTANCE_CM = 2.0
MAX_VOLUME_ML = 1000.0

# Stability settings
STABILITY_THRESHOLD = 0.2  # cm
STABILITY_DURATION = 5.0   # seconds

distance_buffer = []
last_saved_volume = None


def is_stable(buffer):
    if len(buffer) < 2:
        return False

    now = time.time()
    recent = [(d, t) for d, t in buffer if now - t <= STABILITY_DURATION]

    if len(recent) < 2:
        return False

    distances = [d for d, _ in recent]
    stable = max(distances) - min(distances) <= STABILITY_THRESHOLD

    print(f"🧪 Checking stability over last {len(recent)} readings: {distances} → {'✅ Stable' if stable else '❌ Unstable'}")
    return stable


@api_view(['GET'])
def get_distance(request):
    global distance_buffer, last_saved_volume

    try:
        print("🔌 Attempting to connect to serial port...")
        with serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=TIMEOUT) as ser:
            print("✅ Serial connection established.")
            raw_line = ser.readline()
            print(f"📨 Raw bytes received: {raw_line}")

            line = raw_line.decode('utf-8').strip()
            print(f"🧾 Decoded string: '{line}'")

            match = re.search(r"([\d.]+)", line)
            if not match:
                raise ValueError(f"No numeric value found in '{line}'")
            
            distance = float(match.group(1))
            print(f"📏 Parsed distance: {distance} cm")

            # Clamp distance
            distance = max(min(distance, MAX_DISTANCE_CM), MIN_DISTANCE_CM)

            # Store (distance, timestamp)
            now = time.time()
            distance_buffer.append((distance, now))

            # Keep only recent readings
            distance_buffer[:] = [(d, t) for d, t in distance_buffer if now - t <= STABILITY_DURATION]

            # Calculate volume
            fill_ratio = (MAX_DISTANCE_CM - distance) / (MAX_DISTANCE_CM - MIN_DISTANCE_CM)
            volume_ml = round(fill_ratio * MAX_VOLUME_ML, 2)

            print(f"💧 Estimated Volume: {volume_ml} mL")

            if is_stable(distance_buffer):
                if last_saved_volume != volume_ml:
                    # Check last saved timestamp in DB
                    django_now = timezone.now()
                    last_entry = StableWaterLevel.objects.last()

                    if not last_entry or django_now - last_entry.timestamp >= timedelta(minutes=10):
                        StableWaterLevel.objects.create(volume_ml=volume_ml)
                        last_saved_volume = volume_ml
                        print(f"✅ Stable volume saved: {volume_ml} mL at {django_now}")
                    else:
                        print(f"🕒 Skipped saving. Last save was less than an hour ago at {last_entry.timestamp}")
                else:
                    print("ℹ️ Same stable volume already saved.")
            else:
                print("⏳ Distance not stable for 5 seconds yet...")

            return Response({
                "distance_cm": round(distance, 2),
                "volume_ml": volume_ml,
                "is_stable": is_stable(distance_buffer)
            })

    except ValueError as ve:
        print(f"❌ ValueError: {ve}")
        return Response({"error": str(ve)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    except serial.SerialException as se:
        print(f"❌ SerialException: {se}")
        return Response({"error": f"Serial error: {str(se)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return Response({"error": f"Unexpected error: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
