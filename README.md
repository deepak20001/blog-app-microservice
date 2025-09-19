# Blog App - Microservice Architecture

A full-stack blog application built with Flutter frontend and microservice backend architecture. The application provides comprehensive blog management features including user authentication, blog creation, commenting, and social interactions.

## Screenshots

### Login Screen

![Login Screen](login_screen.png)


## Architecture Overview

The project follows a microservice architecture with three main services:

- **User Service** (Node.js + TypeScript + MongoDB)
- **Blog Service** (Node.js + TypeScript + PostgreSQL)
- **Media Service** (Go + Cloudinary)
- **Flutter Client** (Dart + Flutter)

## Tech Stack

### Frontend

- **Flutter** - Cross-platform mobile framework
- **BLoC Pattern** - State management
- **Auto Route** - Navigation
- **Dio** - HTTP client
- **Injectable** - Dependency injection
- **Freezed** - Data classes generation

### Backend Services

#### User Service

- **Node.js** + **TypeScript**
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **Redis** - Caching
- **RabbitMQ** - Message queuing

#### Blog Service

- **Node.js** + **TypeScript**
- **Express.js** - Web framework
- **PostgreSQL** - Database
- **Neon Database** - Serverless PostgreSQL
- **Redis** - Caching
- **RabbitMQ** - Message queuing
- **Google GenAI** - AI content generation

#### Media Service

- **Go** - Programming language
- **Fiber** - Web framework
- **Cloudinary** - Image storage and processing
- **JWT** - Authentication

## Features

### User Management

- User registration and login
- Email verification with OTP
- Password reset functionality
- Profile management
- Avatar upload
- User search and discovery
- Follow/Unfollow system

### Blog Management

- Create and edit blog posts
- Rich text editor with HTML support
- Image upload for blog posts
- Category management
- Blog search and filtering
- Pagination support
- AI-powered content generation

### Social Features

- Like/Unlike blog posts
- Save/Unsave blog posts
- Comment system
- Comment likes/dislikes , delete
- User profiles with statistics

### Additional Features

- Real-time caching with Redis
- Message queuing with RabbitMQ
- JWT-based authentication
- File upload with Cloudinary

## Project Structure

```
blog-app/
├── blog_client/                 # Flutter mobile app
│   ├── lib/
│   │   ├── core/               # Core utilities and services
│   │   ├── features/           # Feature-based modules
│   │   └── main.dart
│   └── pubspec.yaml
├── services/
│   ├── user/                   # User management service
│   │   ├── src/
│   │   │   ├── controllers/
│   │   │   ├── middleware/
│   │   │   ├── model/
│   │   │   ├── routes/
│   │   │   └── utils/
│   │   └── package.json
│   ├── blog/                   # Blog management service
│   │   ├── src/
│   │   │   ├── controllers/
│   │   │   ├── middleware/
│   │   │   ├── routes/
│   │   │   └── utils/
│   │   └── package.json
│   └── media/                  # Media upload service
│       ├── internal/
│       ├── config/
│       └── main.go
```

## API Endpoints

### User Service

- `POST /api/v1/users/register` - User registration
- `POST /api/v1/users/login` - User login
- `POST /api/v1/users/verify-email` - Email verification
- `POST /api/v1/users/forgot-password` - Password reset request
- `GET /api/v1/users/:id` - Get user profile
- `PUT /api/v1/users` - Update user profile
- `POST /api/v1/users/avatar` - Upload avatar

### Blog Service

- `GET /api/v1/blogs/filter` - Get blogs with filtering
- `POST /api/v1/blogs` - Create blog post
- `GET /api/v1/blogs/:id` - Get blog details
- `POST /api/v1/blogs/:id/upvote` - Like blog
- `POST /api/v1/blogs/:id/save` - Save blog
- `GET /api/v1/blogs/categories` - Get categories
- `POST /api/v1/blogs/categories` - Create category

### Media Service

- `POST /api/v1/media/avatar-upload` - Upload user avatar
- `POST /api/v1/media/blog-image` - Upload blog image

## Setup Instructions

### Prerequisites

- Flutter SDK (3.8.1+)
- Node.js (18+)
- Go (1.25+)
- MongoDB
- PostgreSQL
- Redis
- RabbitMQ
- Cloudinary account

### Environment Variables

Copy the `.env.example` files to `.env` in each service directory and configure the values:

- `services/user/.env.example` → `services/user/.env`
- `services/blog/.env.example` → `services/blog/.env`
- `services/media/.env.example` → `services/media/.env`
- `blog_client/.env.example` → `blog_client/.env`

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd blog-app
```

2. **Install dependencies for each service**

User Service:

```bash
cd services/user
npm install
npm run build
```

Blog Service:

```bash
cd services/blog
npm install
npm run build
```

Media Service:

```bash
cd services/media
go mod tidy
go build -o media-service main.go
```

Flutter Client:

```bash
cd blog_client
flutter pub get
```

3. **Start the services**

Start each service in separate terminals:

```bash
# User Service
cd services/user
npm run dev

# Blog Service
cd services/blog
npm run dev

# Media Service
cd services/media
./media-service

# Flutter Client
cd blog_client
flutter run
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
