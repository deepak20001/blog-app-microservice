# Blog App - Microservice Architecture

A full-stack blog application built with Flutter frontend and microservice backend architecture. The application provides comprehensive blog management features including user authentication, blog creation, commenting, and social interactions.

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/87bb8932-afa4-4143-b45e-7cc36eea1b20" width="200" />
  <img src="https://github.com/user-attachments/assets/01fd7086-3566-4393-b081-e411c1454eb1" width="200" />
  <img src="https://github.com/user-attachments/assets/6c078609-f603-461c-a6ae-bafad17b0a33" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/46916514-18c9-477c-954f-7ec222f2ace8" width="200" />
  <img src="https://github.com/user-attachments/assets/86b2db51-ee3d-447e-a97f-c31defd25593" width="200" />
  <img src="https://github.com/user-attachments/assets/97675cb6-2b79-463a-aa43-d94a50abcdd8" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e2d928fb-e922-4a7d-b638-cb75354c5397" width="200" />
  <img src="https://github.com/user-attachments/assets/becfc8fb-5709-4fa5-ba15-bfcf5b68cfa4" width="200" />
  <img src="https://github.com/user-attachments/assets/9f50a47a-ffbb-4c56-abdb-aa3879200db5" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/91d66538-0abd-4db4-bebc-7f018a6f323e" width="200" />
  <img src="https://github.com/user-attachments/assets/ad4d31e8-5aef-486f-9377-6a494ed49732" width="200" />
  <img src="https://github.com/user-attachments/assets/d09c6f4e-e343-414c-a90e-27c888ffeffa" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e7b3016b-d79d-4f08-805a-040b9cc5b363" width="200" />
  <img src="https://github.com/user-attachments/assets/1adc77b3-3245-46a7-b3a7-52f3cfea5b15" width="200" />
  <img src="https://github.com/user-attachments/assets/459b48e2-f612-406d-818a-a5598c5bee89" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/2a55cc08-ded0-4824-a7a9-2a3e658470d3" width="200" />
  <img src="https://github.com/user-attachments/assets/00ce68e8-93b7-4a87-86b8-90de373eb0c8" width="200" />
  <img src="https://github.com/user-attachments/assets/5eace186-547e-46eb-93c1-69afe9f4bd60" width="200" />
</p>

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

#### Authentication & Registration

- `POST /api/v1/users/register` - Register new user account
- `POST /api/v1/users/login` - User login with email/password
- `POST /api/v1/users/check-registration` - Check if email is already registered
- `POST /api/v1/users/verify-email` - Verify email with OTP
- `POST /api/v1/users/resend-verification-otp` - Resend email verification OTP

#### Password Management

- `POST /api/v1/users/forgot-password` - Request password reset
- `POST /api/v1/users/verify-password-reset-otp` - Verify password reset OTP
- `POST /api/v1/users/resend-password-reset-otp` - Resend password reset OTP
- `POST /api/v1/users/reset-password` - Reset password with OTP
- `PATCH /api/v1/users/change-password` - Change password (authenticated)

#### User Profile Management

- `GET /api/v1/users/:id` - Get user profile by ID
- `PATCH /api/v1/users` - Update user profile
- `PATCH /api/v1/users/avatar` - Update user avatar
- `GET /api/v1/users/profile-stats/:id` - Get user profile statistics
- `GET /api/v1/users` - Search users
- `POST /api/v1/users/profiles` - Get multiple user profiles
- `DELETE /api/v1/users` - Delete user account

#### Social Features

- `GET /api/v1/relationships/followers/:id` - Get user's followers
- `GET /api/v1/relationships/followings/:id` - Get user's followings
- `POST /api/v1/relationships/follow` - Follow a user
- `POST /api/v1/relationships/unfollow` - Unfollow a user

### Blog Service

#### Blog Management

- `POST /api/v1/blogs` - Create new blog post
- `GET /api/v1/blogs/filter` - Get blogs with filtering, pagination, and search
- `GET /api/v1/blogs/:id` - Get blog details by ID
- `PATCH /api/v1/blogs/:id` - Update blog post
- `DELETE /api/v1/blogs/:id` - Delete blog post
- `GET /api/v1/blogs/my-blogs/:id` - Get user's own blogs
- `GET /api/v1/blogs/saved-blogs/:id` - Get user's saved blogs
- `GET /api/v1/blogs/user-blogs-count/:id` - Get user's blog count

#### Blog Interactions

- `POST /api/v1/blogs/upvote-blog` - Like/upvote a blog
- `DELETE /api/v1/blogs/unupvote-blog` - Unlike/unupvote a blog
- `POST /api/v1/blogs/save-blog` - Save blog for later
- `DELETE /api/v1/blogs/unsave-blog` - Remove saved blog

#### Categories

- `POST /api/v1/blogs/category` - Create new category
- `GET /api/v1/blogs/categories` - Get all categories

#### AI Content Generation

- `POST /api/v1/blogs/ai-title` - Generate AI-powered blog title
- `POST /api/v1/blogs/ai-short-desc` - Generate AI short description
- `POST /api/v1/blogs/ai-desc` - Generate AI full description

#### Comments

- `POST /api/v1/comments` - Create comment on blog
- `GET /api/v1/comments/:id` - Get comments for blog
- `POST /api/v1/comments/upvote` - Like/upvote a comment
- `DELETE /api/v1/comments/unupvote` - Unlike/unupvote a comment
- `DELETE /api/v1/comments` - Delete comment

### Media Service

#### File Upload

- `GET /health` - Health check endpoint
- `POST /api/v1/media/avatar-upload` - Upload user avatar (JPG, PNG, WebP, max 5MB)
- `POST /api/v1/media/blog-image` - Upload blog image (JPG, PNG, WebP, max 5MB)

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
