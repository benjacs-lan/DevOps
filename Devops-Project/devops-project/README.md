Mi aplicación Flask lee variables de entorno usando os.getenv().
La configuración está desacoplada del código y se pasa mediante un archivo .env que cargo automáticamente desde docker-compose.yml con env_file.
Esto permite cambiar valores sin reconstruir la imagen y es compatible con pipelines, ECS, Kubernetes y entornos multi-stage.
