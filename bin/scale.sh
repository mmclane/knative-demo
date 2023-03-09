export SVC_URL=$(kn service describe prime-generator -o url)
hey -c 50 -z 10s "$SVC_URL/?sleep=3&upto=10000&memload=100"
