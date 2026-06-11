# 🎮 Pokémon Infinite Scroll Flutter

Aplicación móvil desarrollada con **Flutter** que consume la API pública de Pokémon (**PokeAPI**) para mostrar información detallada de los personajes utilizando **Infinite Scrolling Pagination** y un buscador por nombre.

## 📱 Descripción

Esta aplicación permite explorar Pokémon de forma dinámica obteniendo información directamente desde la API oficial de Pokémon.

Los personajes se cargan automáticamente de **5 en 5** conforme el usuario se desplaza por la lista, implementando la técnica de **Infinite Scroll**. Además, se incluye una funcionalidad adicional para buscar Pokémon por nombre.

---

## ✨ Características

✅ Consumo de API REST (PokeAPI)

✅ Infinite Scroll Pagination

✅ Carga de Pokémon de 5 en 5

✅ Buscador por nombre

✅ Visualización de imágenes oficiales

✅ Diseño con Material 3

✅ Manejo de errores de carga

✅ Compatible con Android y Web

---

## 📊 Información mostrada de cada Pokémon

La aplicación muestra más de 10 atributos por personaje:

* ID
* Nombre
* Imagen
* Altura
* Peso
* Experiencia Base
* Orden
* Tipos
* Habilidades
* Cantidad de Tipos
* Cantidad de Habilidades
* Disponibilidad de Imagen

---

## 🛠️ Tecnologías Utilizadas

* Flutter
* Dart
* HTTP Package
* Infinite Scroll Pagination
* Material Design 3
* PokeAPI

---

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter

  http: ^1.6.0
  infinite_scroll_pagination: ^5.1.1
```

---

## 🌐 API Utilizada

PokeAPI:

https://pokeapi.co/

Endpoint principal:

https://pokeapi.co/api/v2/pokemon

---

## 🚀 Instalación

Clonar el repositorio:

```bash
git clone https://github.com/TU_USUARIO/Pokemon-Infinite-Scroll-Flutter.git
```

Ingresar al proyecto:

```bash
cd Pokemon-Infinite-Scroll-Flutter
```

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar aplicación:

```bash
flutter run
```

---

## 📸 Capturas de Pantalla

### Pantalla Principal

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/3a3b40d3-0f56-49f9-be66-106cae18f4de" />

---

### Infinite Scroll

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/303d6d53-2a57-4846-9c0c-5bac2f270a79" />

---

### Búsqueda de Pokémon

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/9949b05e-98c8-4a31-8a11-91b5b7c4533a" />

### Información Detallada

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/f1af8f83-a731-4d6b-ad26-7725e4214de2" />

---

## 🎯 Funcionalidades Implementadas

### Actividad 1

Mostrar al menos 10 elementos del personaje.

✔ Implementado.

---

### Actividad 2

Implementar Infinite Scrolling para mostrar personajes de 5 en 5.

✔ Implementado mediante el paquete:

```text
infinite_scroll_pagination
```

---

### Funcionalidad Extra

Búsqueda de Pokémon por nombre.

✔ Implementado.

---

## 📂 Estructura del Proyecto

```text
lib/
│
├── main.dart
│
├── models/
│   └── pokemon.dart
│
├── services/
│   └── pokemon_service.dart
│
android/
ios/
web/
```

---

## 👩‍💻 Autor

**Odaliz Balseca Valencia**

Desarrollo de Aplicaciones Móviles - Flutter

---

## 📄 Licencia

Este proyecto fue desarrollado con fines académicos.
