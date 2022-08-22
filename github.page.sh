#!/bin/bash
set -e

cd example/

flutter pub get
flutter build web --release --base-href="/easy_camera_plus/"

echo "Deploy Done !!!"