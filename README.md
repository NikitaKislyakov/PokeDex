# PokeDex
## Описание

Pokedex позволяет пользователям просматривать список покемонов, получать подробную информацию о каждом покемоне, редактировать их способности и сохранять изменения в локальной базе данных.

Секция с описанием на главном экране со списком покемонов содержит только название покемонов из-за данных получаемых по API (https://pokeapi.co): Список покемонов, их имена и URL каждого покемона.

# InfiniteListVK

InfiniteListVK - это приложение для работы с API Pokémon, позволяющее загружать и отображать информацию о покемонах, а также редактировать их способности и сохранять изменения.

## Содержание

- [Описание](#описание)
- [Технологии](#технологии)
- [Структура проекта](#структура-проекта)

## Описание

InfiniteListVK позволяет пользователям просматривать список покемонов, получать подробную информацию о каждом покемоне, редактировать их способности и сохранять изменения в локальной базе данных.

## Технологии

- Swift
- SwiftUI
- Async/await
- Realm
- URLSession для работы с API
- Архитектура: Clean Architecture

# Структура проекта

Проект состоит из следующих основных компонентов:

## Папка Data
Папка Data отвечает за слой, взаимодействующий с данными: локальное управление данными и загрузка данных по API.
- **NetworkService.swift**: Служба для выполнения сетевых запросов к API Pokémon.
- **PokemonRepository.swift**: Репозиторий для управления данными покемонов, включая загрузку из сети и сохранение в локальной базе данных.
## Папка Domain
Папка Domain содержит доменные модели и слой, отвечающий за основной функционал приложения.
- **GetPokemons.swift**: Использует репозиторий и сетевую службу для получения данных о покемонах.
## Папка Presentation
Папка Presentation отвечает за слой представления приложения, а так же за взаимодействие представления с моделями и функционалом приложения (Use cases).
- **DetailViewModel.swift**: Модель представления для экрана деталей покемона, обрабатывающая логику получения и сохранения данных.
- **DetailView.swift**: Представление для отображения деталей покемона и редактирования его способностей.
- **MainView.swift**: Основное представление приложения, отображающее список покемонов.
- **MainViewModel.swift**: Модель представления для основного экрана, управляющая загрузкой и отображением списка покемонов.
## Папка Utilities
- Папка Utilities содержит вспомогательные файлы: расширения, кастомные ошибки и DI. 
