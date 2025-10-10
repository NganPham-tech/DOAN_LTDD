# MySQL Setup cho WordMaster

## 🗄️ Cài đặt MySQL Database

### 1. Tạo Database

```sql
DROP DATABASE IF EXISTS wordmasterapp;
CREATE DATABASE wordmasterapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE wordmasterapp;
```

### 2. Tạo Tables

```sql
-- 1. USER TABLE
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastLogin DATETIME,
    INDEX idx_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. CATEGORIES
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT,
    ColorCode VARCHAR(7) DEFAULT '#6c757d',
    Icon VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. DECK
CREATE TABLE Deck (
    DeckID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Thumbnail VARCHAR(255),
    IsPublic BOOLEAN DEFAULT FALSE,
    ViewCount INT DEFAULT 0,
    Rating FLOAT DEFAULT 0,
    TotalRatings INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL,
    INDEX idx_user (UserID),
    INDEX idx_public (IsPublic),
    FULLTEXT INDEX idx_search (Name, Description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. FLASHCARD
CREATE TABLE Flashcard (
    FlashcardID INT AUTO_INCREMENT PRIMARY KEY,
    DeckID INT NOT NULL,
    CardType ENUM('Vocabulary', 'Grammar') DEFAULT 'Vocabulary',
    Question TEXT NOT NULL,
    Answer TEXT NOT NULL,
    Example TEXT,
    Phonetic VARCHAR(100),
    ImagePath VARCHAR(255),
    Difficulty ENUM('Easy', 'Medium', 'Hard') DEFAULT 'Medium',
    WordType VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (DeckID) REFERENCES Deck(DeckID) ON DELETE CASCADE,
    INDEX idx_deck (DeckID),
    INDEX idx_type (CardType)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. LEARNING HISTORY (SRS Algorithm)
CREATE TABLE LearningHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    FlashcardID INT NOT NULL,
    Status ENUM('New', 'Learning', 'Mastered') DEFAULT 'New',
    Repetitions INT DEFAULT 0,
    EaseFactor FLOAT DEFAULT 2.5,
    IntervalDays INT DEFAULT 1,
    LastReviewed DATETIME,
    NextReviewDate DATE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (FlashcardID) REFERENCES Flashcard(FlashcardID) ON DELETE CASCADE,
    UNIQUE KEY unique_user_card (UserID, FlashcardID),
    INDEX idx_next_review (UserID, NextReviewDate),
    INDEX idx_status (Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. QUIZ SYSTEM
CREATE TABLE Quiz (
    QuizID INT AUTO_INCREMENT PRIMARY KEY,
    DeckID INT NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    QuizType ENUM('Listening', 'FillInBlank', 'MultipleChoice', 'Mixed') DEFAULT 'Mixed',
    Duration INT DEFAULT 10,
    PassScore INT DEFAULT 70,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DeckID) REFERENCES Deck(DeckID) ON DELETE CASCADE,
    INDEX idx_deck (DeckID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. STUDY SESSION
CREATE TABLE StudySession (
    SessionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    DeckID INT,
    Mode ENUM('Learn', 'Review', 'Quiz') NOT NULL,
    Score INT,
    TotalCards INT,
    CorrectCards INT,
    Duration INT,
    StartedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CompletedAt DATETIME,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (DeckID) REFERENCES Deck(DeckID) ON DELETE SET NULL,
    INDEX idx_user_date (UserID, StartedAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. USER PROGRESS
CREATE TABLE UserProgress (
    ProgressID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    TotalLearned INT DEFAULT 0,
    TotalMastered INT DEFAULT 0,
    CurrentStreak INT DEFAULT 0,
    BestStreak INT DEFAULT 0,
    LastActiveDate DATE,
    TotalPoints INT DEFAULT 0,
    Level INT DEFAULT 1,
    PerfectQuizCount INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. ACHIEVEMENT SYSTEM
CREATE TABLE Achievement (
    AchievementID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    IconPath VARCHAR(255),
    Category ENUM('Learning', 'Streak', 'Quiz', 'Mastery', 'Special') DEFAULT 'Learning',
    RequirementType ENUM('cards_learned', 'cards_mastered', 'streak_days', 'quiz_perfect', 'total_points') NOT NULL,
    RequirementValue INT NOT NULL,
    Points INT DEFAULT 10,
    SortOrder INT DEFAULT 0,
    INDEX idx_category (Category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE UserAchievement (
    UserAchievementID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    AchievementID INT NOT NULL,
    Progress INT DEFAULT 0,
    IsUnlocked BOOLEAN DEFAULT FALSE,
    UnlockedAt DATETIME,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (AchievementID) REFERENCES Achievement(AchievementID) ON DELETE CASCADE,
    UNIQUE KEY unique_user_achievement (UserID, AchievementID),
    INDEX idx_user (UserID),
    INDEX idx_unlocked (IsUnlocked)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3. Sample Data

```sql
-- Insert Categories
INSERT INTO Categories (Name, Description, ColorCode, Icon) VALUES
('Basic English', 'Từ vựng tiếng Anh cơ bản', '#ffc107', 'book'),
('IELTS Vocabulary', 'Từ vựng luyện thi IELTS', '#17a2b8', 'trophy'),
('TOEIC Vocabulary', 'Từ vựng luyện thi TOEIC', '#20c997', 'briefcase'),
('Grammar', 'Ngữ pháp tiếng Anh', '#6610f2', 'bookmark'),
('Daily Conversations', 'Giao tiếp hàng ngày', '#fd7e14', 'message-circle');

-- Insert Admin User
INSERT INTO User (FullName, Email, Password) VALUES
('Admin User', 'admin@wordmaster.com', 'admin123');

-- Insert Sample Users
INSERT INTO User (FullName, Email, Password) VALUES
('Nguyen Van A', 'nguyenvana@gmail.com', 'password123'),
('Tran Thi B', 'tranthib@gmail.com', 'password123');

-- Initialize UserProgress for all users
INSERT INTO UserProgress (UserID) VALUES (1), (2), (3);

-- Insert Sample Decks
INSERT INTO Deck (UserID, CategoryID, Name, Description, IsPublic) VALUES
(1, 1, 'Essential English Words', 'Top 1000 từ vựng thiết yếu', TRUE),
(1, 2, 'IELTS Academic Words', 'Từ vựng học thuật IELTS', TRUE),
(1, 4, 'English Grammar Basics', 'Ngữ pháp cơ bản', TRUE);

-- Insert Sample Flashcards
INSERT INTO Flashcard (DeckID, CardType, Question, Answer, Example, Phonetic, Difficulty, WordType) VALUES
-- Basic vocabulary
(1, 'Vocabulary', 'Hello', 'Xin chào', 'Hello! How are you today?', '/həˈloʊ/', 'Easy', 'Interjection'),
(1, 'Vocabulary', 'Beautiful', 'Đẹp', 'She has a beautiful smile.', '/ˈbjuːtɪfl/', 'Medium', 'Adjective'),
(1, 'Vocabulary', 'Important', 'Quan trọng', 'This is an important meeting.', '/ɪmˈpɔːrtənt/', 'Medium', 'Adjective'),

-- IELTS vocabulary
(2, 'Vocabulary', 'Analyze', 'Phân tích', 'We need to analyze the data carefully.', '/ˈænəlaɪz/', 'Hard', 'Verb'),
(2, 'Vocabulary', 'Significant', 'Quan trọng, đáng kể', 'This is a significant achievement.', '/sɪɡˈnɪfɪkənt/', 'Hard', 'Adjective'),

-- Grammar cards
(3, 'Grammar', 'Present Simple Tense', 'Thì hiện tại đơn - Diễn tả thói quen, sự thật hiển nhiên', 'I go to school every day.', NULL, 'Easy', NULL),
(3, 'Grammar', 'Past Simple Tense', 'Thì quá khứ đơn - Diễn tả hành động đã xảy ra trong quá khứ', 'I visited Paris last year.', NULL, 'Easy', NULL);

-- Insert Sample Achievements
INSERT INTO Achievement (Name, Description, Category, RequirementType, RequirementValue, Points) VALUES
('First Steps', 'Học 10 thẻ đầu tiên', 'Learning', 'cards_learned', 10, 50),
('Vocabulary Master', 'Thuộc lòng 100 từ vựng', 'Mastery', 'cards_mastered', 100, 200),
('Weekly Streak', 'Học liên tục 7 ngày', 'Streak', 'streak_days', 7, 100),
('Quiz Champion', 'Hoàn thành 5 quiz với điểm tối đa', 'Quiz', 'quiz_perfect', 5, 150);
```

## 🔧 Cấu hình Flutter App

### 1. Cập nhật MySQL Helper
Sửa thông tin kết nối trong `lib/data/mysql_helper.dart`:

```dart
// Database connection settings
static const String _host = 'localhost';  // hoặc IP server của bạn
static const String _port = 3306;
static const String _user = 'root';       // MySQL username
static const String _password = '';       // MySQL password
static const String _database = 'wordmasterapp';
```

### 2. Test Connection
Chạy app và kiểm tra kết nối MySQL trong console.

## 📱 Tính năng đã sẵn sàng

### ✅ Hoàn thành
- **User Authentication**: Login/Register system
- **Category Management**: Danh mục học tập
- **Deck Management**: Quản lý bộ thẻ
- **Flashcard System**: Với phonetic, word type
- **SRS Algorithm**: Spaced repetition learning
- **MySQL Integration**: Full database support
- **State Management**: Provider pattern

### 🔄 Cần phát triển tiếp
- Login/Register UI screens
- Quiz UI implementation
- Achievement UI
- Statistics dashboard
- Advanced search features

## 🚀 Next Steps

1. **Setup MySQL server** và chạy script tạo database
2. **Update connection settings** trong mysql_helper.dart
3. **Test MySQL connection** 
4. **Implement authentication UI**
5. **Update existing screens** để sử dụng new models

Project đã sẵn sàng với MySQL backend hoàn chỉnh theo README.md!