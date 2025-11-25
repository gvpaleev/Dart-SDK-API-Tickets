# Dart SDK API Tickets

A Telegram bot for learning Dart SDK API through interactive quizzes. The bot scrapes documentation from the official Dart API and generates quiz questions about core Dart classes (List, Set, Map, Iterable).

## Features

- Interactive quiz system via Telegram bot
- Covers Dart core collections: List, Set, Map, Iterable
- Scrapes live data from Dart API documentation
- Questions about Constructors, Properties, Methods, Operators, and Static Methods
- Multiple choice answers with instant feedback

## Prerequisites

- Dart SDK 3.2.5 or higher
- Firefox browser (for headless scraping)
- Geckodriver
- Docker and Docker Compose (optional)

## Installation

1. Clone the repository
2. Install dependencies:
```bash
dart pub get
```

3. Configure environment variables by copying `env_example` to `.env`:
```bash
cp env_example .env
```

4. Update `.env` with your Telegram bot token:
```
BOT_TG_TOKEN=your_telegram_bot_token_here
```

## Configuration

The `.env` file contains:
- `LIST_DART_SDK_API_URL` - URL to List class documentation
- `SET_DART_SDK_API_URL` - URL to Set class documentation
- `MAP_DART_SDK_API_URL` - URL to Map class documentation
- `ITERABLE_DART_SDK_API_URL` - URL to Iterable class documentation
- `WEBDRIVE_URL` - WebDriver endpoint (default: http://localhost:9515)
- `BOT_TG_TOKEN` - Your Telegram bot token

## Usage

### Local Development

1. Start Geckodriver:
```bash
./geckodriver --port 9515
```

2. Run the bot:
```bash
dart run bin/main.dart
```

Or compile and run:
```bash
dart compile exe bin/main.dart -o bin/server
./bin/server
```

### Docker

Build and run with Docker Compose:
```bash
docker-compose up --build
```

## Bot Commands

- `/list` - Start quiz on List class
- `/set` - Start quiz on Set class
- `/map` - Start quiz on Map class
- `/iterable` - Start quiz on Iterable class

Type `exit` to stop the current quiz.

## Project Structure

```
├── bin/
│   ├── main.dart              # Main bot application
│   └── domain/
│       ├── document_dart.dart # Web scraper for Dart API docs
│       └── tiсket.dart        # Quiz ticket model
├── lib/
│   └── dart_sdk_api_tickets.dart
├── test/
│   └── dart_sdk_api_tickets_test.dart
├── pubspec.yaml               # Dependencies
├── Dockerfile                 # Docker configuration
├── docker-compose.yaml        # Docker Compose setup
└── .env                       # Environment variables
```

## Dependencies

- `televerse` - Telegram bot framework
- `webdriver` - Browser automation for scraping
- `dotenv` - Environment variable management

## How It Works

1. On startup, the bot launches a headless Firefox browser via WebDriver
2. It scrapes the Dart API documentation for List, Set, Map, and Iterable classes
3. Extracts information about Constructors, Properties, Methods, Operators, and Static Methods
4. When a user invokes a command, it generates a random quiz question
5. Presents 4 multiple-choice options (1 correct + 3 random)
6. Validates the user's answer and provides feedback

## License

This project is a sample command-line application for educational purposes.
