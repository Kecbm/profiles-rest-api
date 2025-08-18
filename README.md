# Profiles REST API

A complete REST API built with Django and Django REST Framework, featuring user authentication, profile management, and a social feed system.

**Course Reference:** [Build a Backend REST API with Python & Django - Beginner](https://www.udemy.com/course/django-python/)
- Teacher: https://www.linkedin.com/in/markwinterbottom/
- Original Repository: https://github.com/LondonAppDev/profiles-rest-api

## What was developed

### 🔐 **User Authentication System**
- Custom user model with email-based authentication
- Secure password hashing and validation
- Token-based authentication for API access
- Session authentication for web interface
- User registration and login endpoints

### 👤 **User Profile Management**
- Complete CRUD operations for user profiles
- Custom permissions ensuring users can only edit their own profiles
- Profile search and filtering capabilities
- Admin interface integration

### 📱 **Social Feed System**
- Create, read, update, and delete feed items
- Automatic user assignment to posts
- Public reading with authenticated writing
- Custom permissions for post ownership
- Timestamp tracking for all posts

### 🛡️ **Security Features**
- Custom permission classes (`UpdateOwnProfile`, `UpdateOwnStatus`)
- Hybrid authentication (Token + Session)
- Read-only fields for sensitive data
- Proper user authorization checks

### 🏗️ **API Architecture**
- RESTful design with proper HTTP methods
- Django REST Framework ViewSets
- Automatic URL routing with DefaultRouter
- Serializers with validation
- Browsable API interface for development

<p align="right"><a href="#top">Back to the top 👆🏾</a></p>

<details><summary>Execute the project</summary>

### Prerequisites
- Python 3.8+
- pip (Python package manager)

### 🚀 **Quick Start**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd profiles-rest-api
   ```

2. **Create and activate virtual environment**
   ```bash
   python -m venv ~/env
   source ~/env/bin/activate  # On Windows: ~/env/Scripts/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run database migrations**
   ```bash
   python manage.py makemigrations profiles_api
   python manage.py migrate
   ```

5. **Create a superuser (optional)**
   ```bash
   python manage.py createsuperuser
   ```

6. **Start the development server**
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

### 🌐 **Access Points**
- **API Root**: http://127.0.0.1:8000/api/
- **Admin Interface**: http://127.0.0.1:8000/admin/
- **User Profiles**: http://127.0.0.1:8000/api/profile/
- **Feed Items**: http://127.0.0.1:8000/api/feed/
- **Authentication**: http://127.0.0.1:8000/api/login/

### 🔧 **Development Commands**
```bash
# Deactivate virtual environment
deactivate

# Create new migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate
```
</details>

<p align="right"><a href="#top">Back to the top 👆🏾</a></p>

## Project Architecture

### 🏗️ **System Architecture Overview**

The Profiles REST API follows a layered architecture pattern that ensures separation of concerns, scalability, and maintainability. The system is built using Django REST Framework and implements a clean, RESTful design.

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Layer  │    │ Authentication  │    │   API Layer     │
│                 │    │     Layer       │    │                 │
│ • Web Browser   │───▶│ • Session Auth  │───▶│ • ViewSets      │
│ • Mobile App    │    │ • Token Auth    │    │ • URL Router    │
│ • API Client    │    │                 │    │ • Endpoints     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Permission Layer│    │Serialization    │    │Business Logic   │
│                 │    │     Layer       │    │     Layer       │
│ • UpdateOwn*    │    │ • Serializers   │    │ • Custom Logic  │
│ • IsAuth*       │    │ • Validation    │    │ • User Manager  │
│ • Custom Perms  │    │ • Data Transform│    │ • perform_*     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Data Layer                               │
│                                                                 │
│  ┌─────────────────┐              ┌─────────────────┐           │
│  │ UserProfile     │              │ ProfileFeedItem │           │
│  │ Model           │──────────────│ Model           │           │
│  │                 │   1:N        │                 │           │
│  └─────────────────┘              └─────────────────┘           │
│                           │                                     │
│                           ▼                                     │
│                  ┌─────────────────┐                            │
│                  │ SQLite Database │                            │
│                  └─────────────────┘                            │
└─────────────────────────────────────────────────────────────────┘
```

<details><summary>🔄 Data Flow Architecture</summary>

#### **Profile Management Flow**
```
User Request → Authentication → Permissions → Serializer → Business Logic → Model → Database
     ↓              ↓              ↓             ↓             ↓          ↓        ↓
  HTTP POST    Token/Session   UpdateOwnProfile  Validation   UserManager  UserProfile  SQLite
```

#### **Feed Item Flow**
```
User Request → Authentication → Permissions → Serializer → Business Logic → Model → Database
     ↓              ↓              ↓             ↓             ↓          ↓        ↓
  HTTP POST    Token/Session   UpdateOwnStatus   Validation   perform_create  FeedItem  SQLite
```
</details>

<details><summary>📋 Layer Responsibilities</summary>

#### **1. Client Layer**
- **Purpose**: Interface for user interaction
- **Components**: Web browsers, mobile apps, API clients
- **Responsibility**: Send HTTP requests and handle responses

#### **2. Authentication Layer**
- **Purpose**: Verify user identity
- **Components**:
  - `TokenAuthentication`: For API clients
  - `SessionAuthentication`: For web browsers
- **Responsibility**: Validate credentials and establish user context

#### **3. API Layer (Django REST Framework)**
- **Purpose**: Handle HTTP requests and route to appropriate handlers
- **Components**:
  - `DefaultRouter`: Automatic URL routing
  - `UserProfileViewSet`: Profile CRUD operations
  - `UserProfileFeedViewSet`: Feed CRUD operations
  - `UserLoginApiView`: Authentication endpoint
- **Responsibility**: Request routing, HTTP method handling, response formatting

#### **4. Permission Layer**
- **Purpose**: Control access to resources
- **Components**:
  - `UpdateOwnProfile`: Users can only edit their own profiles
  - `UpdateOwnStatus`: Users can only edit their own feed items
  - `IsAuthenticatedOrReadOnly`: Public read, authenticated write
- **Responsibility**: Authorization and access control

#### **5. Serialization Layer**
- **Purpose**: Data validation and transformation
- **Components**:
  - `UserProfileSerializer`: Profile data handling
  - `ProfileFeedItemSerializer`: Feed item data handling
- **Responsibility**: Input validation, data transformation, output formatting

#### **6. Business Logic Layer**
- **Purpose**: Application-specific logic and rules
- **Components**:
  - `UserProfileManager`: Custom user creation logic
  - `perform_create`: Auto-assign user to feed items
  - Validation methods
- **Responsibility**: Business rules, data processing, custom logic

#### **7. Data Layer**
- **Purpose**: Data persistence and relationships
- **Components**:
  - `UserProfile`: Custom user model
  - `ProfileFeedItem`: Feed post model
  - SQLite database
- **Responsibility**: Data storage, relationships, constraints
</details>

### 🔄 **CRUD Operations Flow**

<details><summary>Profile CRUD Flow</summary>

##### **CREATE Profile (POST /api/profile/)**
```
1. Client sends POST request with user data
2. SessionAuthentication/TokenAuthentication validates request
3. No permission check needed (public registration)
4. UserProfileSerializer validates input data
5. UserProfileSerializer.create() calls UserProfileManager.create_user()
6. UserProfileManager hashes password using set_password()
7. UserProfile instance saved to database
8. Serialized response returned to client
```

##### **READ Profile (GET /api/profile/)**
```
1. Client sends GET request
2. Authentication layer identifies user (if logged in)
3. No permission check (public read access)
4. ViewSet queries UserProfile.objects.all()
5. UserProfileSerializer serializes data (password excluded)
6. JSON response returned to client
```

##### **UPDATE Profile (PUT/PATCH /api/profile/{id}/)**
```
1. Client sends PUT/PATCH request with updated data
2. Authentication layer validates user
3. UpdateOwnProfile permission checks if user owns profile
4. UserProfileSerializer validates input data
5. UserProfileSerializer.update() handles password hashing if provided
6. Model instance updated in database
7. Serialized response returned to client
```

##### **DELETE Profile (DELETE /api/profile/{id}/)**
```
1. Client sends DELETE request
2. Authentication layer validates user
3. UpdateOwnProfile permission checks ownership
4. ViewSet calls destroy() method
5. UserProfile instance deleted from database
6. 204 No Content response returned
```
</details>

<details><summary>Feed Item CRUD Flow</summary>

##### **CREATE Feed Item (POST /api/feed/)**
```
1. Client sends POST request with status_text
2. Authentication layer validates user (required)
3. IsAuthenticatedOrReadOnly allows authenticated users
4. ProfileFeedItemSerializer validates input
5. perform_create() automatically assigns user_profile=request.user
6. ProfileFeedItem instance saved to database
7. Serialized response returned with auto-generated fields
```

##### **READ Feed Items (GET /api/feed/)**
```
1. Client sends GET request
2. No authentication required (public read)
3. IsAuthenticatedOrReadOnly allows read access
4. ViewSet queries ProfileFeedItem.objects.all()
5. ProfileFeedItemSerializer serializes data
6. JSON response with all feed items returned
```

##### **UPDATE Feed Item (PUT/PATCH /api/feed/{id}/)**
```
1. Client sends PUT/PATCH request
2. Authentication layer validates user
3. UpdateOwnStatus checks if user owns the feed item
4. ProfileFeedItemSerializer validates input
5. Model instance updated in database
6. Serialized response returned
```

##### **DELETE Feed Item (DELETE /api/feed/{id}/)**
```
1. Client sends DELETE request
2. Authentication layer validates user
3. UpdateOwnStatus permission checks ownership
4. ViewSet calls destroy() method
5. ProfileFeedItem instance deleted from database
6. 204 No Content response returned
```
</details>

### 🔐 **Security Flow**

#### **Authentication Process**
```
Token Auth: Client → Header "Authorization: Token xxx" → TokenAuthentication → User Object
Session Auth: Client → Login Form → Session Cookie → SessionAuthentication → User Object
```

#### **Permission Validation**
```
Request → Authentication → Permission Classes → has_permission() → has_object_permission() → Allow/Deny
```

### 🗄️ **Database Relationships**

```sql
UserProfile (1) ──────── (N) ProfileFeedItem
    │                           │
    ├── id (PK)                ├── id (PK)
    ├── email (unique)         ├── user_profile (FK)
    ├── name                   ├── status_text
    ├── password (hashed)      └── created_on
    ├── is_active
    └── is_staff
```

### 📊 **Data Validation Pipeline**

#### **Profile Data Validation**
```
Input Data → Field Validation → Custom Validation → Password Hashing → Database Constraints → Save
```

#### **Feed Item Validation**
```
Input Data → Field Validation → User Assignment → Timestamp Generation → Database Save
```

## Documentation

<details><summary>📚 API Endpoints</summary>

#### Authentication
- `POST /api/login/` - User login (returns authentication token)

#### User Profiles
- `GET /api/profile/` - List all user profiles
- `POST /api/profile/` - Create new user profile
- `GET /api/profile/{id}/` - Retrieve specific user profile
- `PUT /api/profile/{id}/` - Update user profile (own profile only)
- `PATCH /api/profile/{id}/` - Partial update user profile (own profile only)
- `DELETE /api/profile/{id}/` - Delete user profile (own profile only)

#### Feed Items
- `GET /api/feed/` - List all feed items (public)
- `POST /api/feed/` - Create new feed item (authenticated users only)
- `GET /api/feed/{id}/` - Retrieve specific feed item
- `PUT /api/feed/{id}/` - Update feed item (owner only)
- `PATCH /api/feed/{id}/` - Partial update feed item (owner only)
- `DELETE /api/feed/{id}/` - Delete feed item (owner only)
</details>

<details><summary>🔐 Authentication</summary>

The API supports two authentication methods:

1. **Token Authentication** (for API clients)
```bash
curl -H "Authorization: Token your_token_here" http://127.0.0.1:8000/api/feed/
```

2. **Session Authentication** (for web browsers)
   - Login through the browsable API interface
   - Automatic session management

### 📝 **Request/Response Examples**

#### Create User Profile
```json
POST /api/profile/
{
    "email": "user@example.com",
    "name": "John Doe",
    "password": "securepassword123"
}
```

#### Create Feed Item
```json
POST /api/feed/
{
    "status_text": "This is my first post!"
}
```

#### Login
```json
POST /api/login/
{
    "username": "user@example.com",
    "password": "securepassword123"
}
```
</details>

### 🛡️ **Permissions**

- **Public**: Can read user profiles and feed items
- **Authenticated**: Can create feed items and profiles
- **Owner**: Can update/delete own profiles and feed items
- **Admin**: Full access through Django admin interface

### 🔍 **Search & Filtering**

- **User Profiles**: Search by name and email
```
GET /api/profile/?search=john
```

<p align="right"><a href="#top">Back to the top 👆🏾</a></p>

## Technologies

### Backend Stack

<img title="Python" alt="Python" height="80" width="80" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/python/python-original.svg" /> <img title="Django" alt="Django" height="80" width="80" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/django/django-plain.svg" /> <img title="Django Rest Framework" alt="Django Rest Framework" height="80" width="80" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/djangorest/djangorest-original.svg" /> <img title="SQLite" alt="SQLite" height="80" width="80" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/sqlite/sqlite-original.svg" />

### Key Features
- **Custom User Model** with email authentication
- **Token Authentication** for API access
- **Custom Permissions** for data security
- **Automatic API Documentation** via browsable API
- **Docker Support** for containerization

<p align="right"><a href="#top">Back to the top 👆🏾</a></p>

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is based on the Udemy course materials and is intended for educational purposes.

<p align="right"><a href="#top">Back to the top 👆🏾</a></p>

<p align="center">API developed by <a href="https://www.linkedin.com/in/kecbm/">Klecianny Melo</a> 😁</p>
