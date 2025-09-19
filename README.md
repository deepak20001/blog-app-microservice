# Blog App - Microservice Architecture

A full-stack blog application built with Flutter frontend and microservice backend architecture. The application provides comprehensive blog management features including user authentication, blog creation, commenting, and social interactions.

## Screenshots

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 01 45 12" src="https://github.com/user-attachments/assets/87bb8932-afa4-4143-b45e-7cc36eea1b20" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 01 45 21" src="https://github.com/user-attachments/assets/01fd7086-3566-4393-b081-e411c1454eb1" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 01 49 07" src="https://github.com/user-attachments/assets/6c078609-f603-461c-a6ae-bafad17b0a33" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 26 24" src="https://github.com/user-attachments/assets/46916514-18c9-477c-954f-7ec222f2ace8" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 26 52" src="https://github.com/user-attachments/assets/86b2db51-ee3d-447e-a97f-c31defd25593" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 27 06" src="https://github.com/user-attachments/assets/97675cb6-2b79-463a-aa43-d94a50abcdd8" />

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 14 40" src="https://github.com/user-attachments/assets/e2d928fb-e922-4a7d-b638-cb75354c5397" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 22 39" src="https://github.com/user-attachments/assets/becfc8fb-5709-4fa5-ba15-bfcf5b68cfa4" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 23 22" src="https://github.com/user-attachments/assets/9f50a47a-ffbb-4c56-abdb-aa3879200db5" />

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 35 38" src="https://github.com/user-attachments/assets/91d66538-0abd-4db4-bebc-7f018a6f323e" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 01 55 17" src="https://github.com/user-attachments/assets/ad4d31e8-5aef-486f-9377-6a494ed49732" />

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 25 25" src="https://github.com/user-attachments/assets/d09c6f4e-e343-414c-a90e-27c888ffeffa" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 24 03" src="https://github.com/user-attachments/assets/e7b3016b-d79d-4f08-805a-040b9cc5b363" />

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 24 21" src="https://github.com/user-attachments/assets/1adc77b3-3245-46a7-b3a7-52f3cfea5b15" />

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 23 34" src="https://github.com/user-attachments/assets/459b48e2-f612-406d-818a-a5598c5bee89" />

<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 25 44" src="https://github.com/user-attachments/assets/2a55cc08-ded0-4824-a7a9-2a3e658470d3" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 25 47" src="https://github.com/user-attachments/assets/00ce68e8-93b7-4a87-86b8-90de373eb0c8" />
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 16 Plus - 2025-09-20 at 02 25 51" src="https://github.com/user-attachments/assets/5eace186-547e-46eb-93c1-69afe9f4bd60" />


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
