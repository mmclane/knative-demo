echo 'calling the following command three times:'
echo "curl $(kn service describe greeter -o url)"
curl $(kn service describe greeter -o url)
curl $(kn service describe greeter -o url)
curl $(kn service describe greeter -o url)
