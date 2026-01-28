# EasyBroker API Challenge

Solución en Ruby para consumir la API de pruebas de EasyBroker, leer **todas las propiedades** y mostrar sus títulos en consola.

## Requisitos

- Ruby (2.6+)
- Bundler

## Instalación

```bash
bundle install
```

## Ejecutar las pruebas

```bash
bundle exec ruby -Itest test/property_repository_test.rb
bundle exec ruby -Itest test/api_client_test.rb
```

## Ejecutar el script de propiedades

Configura las variables de entorno:

```bash
export EASYBROKER_API_KEY="TU_API_KEY_DE_PRUEBAS"
# Opcional, por defecto usa https://api.stagingeb.com
export EASYBROKER_BASE_URL="https://api.stagingeb.com"
```

Luego ejecuta:

```bash
ruby bin/print_properties
```

El script inicializará el cliente, leerá todas las propiedades paginadas y mostrará los títulos en consola.

