# Phân tích Database Schema - WordMaster

## 🚨 Vấn đề phát hiện

### Không khớp giữa README.md và Project hiện tại

**README.md (MySQL Schema):**
- ✅ Hệ thống User đầy đủ
- ✅ Categories cho Deck
- ✅ Achievement system  
- ✅ Quiz system với TTS
- ✅ Rating & Review system
- ✅ SRS Algorithm (Spaced Repetition)
- ✅ Gamification (Points, Levels, Streaks)

**Project hiện tại (SQLite):**
- ❌ Chưa có User system
- ❌ Chưa có Categories
- ❌ Chưa có Achievement
- ❌ Chưa có Quiz system
- ❌ Chưa có Rating system
- ✅ Chỉ có basic Flashcard learning

## 🔧 Đề xuất giải pháp

### Option 1: Cập nhật Project theo README (Recommend)
Implement đầy đủ theo thiết kế trong README.md

### Option 2: Cập nhật README theo Project hiện tại
Đơn giản hóa README cho phù hợp với MVP

### Option 3: Hybrid Approach
Giữ cấu trúc đơn giản nhưng chuẩn bị cho mở rộng

## 📝 Database Schema cần thiết cho Project

```sql
-- Simplified WordMaster Database for Flutter/SQLite

-- 1. Categories Table
CREATE TABLE categories (
    categoryID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    colorCode TEXT DEFAULT '#6c757d',
    icon TEXT,
    createdDate TEXT NOT NULL
);

-- 2. Updated Decks Table
CREATE TABLE decks (
    deckID INTEGER PRIMARY KEY AUTOINCREMENT,
    categoryID INTEGER,
    name TEXT NOT NULL,
    description TEXT,
    imagePath TEXT,
    createdDate TEXT NOT NULL,
    lastStudied TEXT,
    totalCards INTEGER DEFAULT 0,
    masteredCards INTEGER DEFAULT 0,
    difficulty TEXT DEFAULT 'Medium',
    isPublic INTEGER DEFAULT 0,
    FOREIGN KEY (categoryID) REFERENCES categories (categoryID) ON DELETE SET NULL
);

-- 3. Enhanced Flashcards Table  
CREATE TABLE flashcards (
    flashcardID INTEGER PRIMARY KEY AUTOINCREMENT,
    deckID INTEGER NOT NULL,
    cardType TEXT DEFAULT 'Vocabulary', -- 'Vocabulary' or 'Grammar'
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    example TEXT,
    phonetic TEXT, -- IPA notation
    audioPath TEXT,
    imagePath TEXT,
    status TEXT DEFAULT 'fresh', -- 'fresh', 'learning', 'mastered'
    difficulty TEXT DEFAULT 'Medium', -- 'Easy', 'Medium', 'Hard'
    wordType TEXT, -- 'Noun', 'Verb', 'Adjective', etc.
    nextReviewDate TEXT,
    reviewCount INTEGER DEFAULT 0,
    easeFactor REAL DEFAULT 2.5, -- For SRS algorithm
    intervalDays INTEGER DEFAULT 1,
    createdDate TEXT NOT NULL,
    FOREIGN KEY (deckID) REFERENCES decks (deckID) ON DELETE CASCADE
);

-- 4. Study Sessions Table
CREATE TABLE study_sessions (
    sessionID INTEGER PRIMARY KEY AUTOINCREMENT,
    deckID INTEGER NOT NULL,
    mode TEXT DEFAULT 'learn', -- 'learn', 'review', 'quiz'
    startTime TEXT NOT NULL,
    endTime TEXT,
    totalCards INTEGER DEFAULT 0,
    correctAnswers INTEGER DEFAULT 0,
    wrongAnswers INTEGER DEFAULT 0,
    score REAL DEFAULT 0.0,
    duration INTEGER DEFAULT 0, -- in seconds
    FOREIGN KEY (deckID) REFERENCES decks (deckID) ON DELETE CASCADE
);

-- 5. User Settings (Local storage)
CREATE TABLE user_settings (
    id INTEGER PRIMARY KEY,
    speechRate REAL DEFAULT 0.5,
    volume REAL DEFAULT 1.0,
    pitch REAL DEFAULT 1.0,
    language TEXT DEFAULT 'en-US',
    studySessionSize INTEGER DEFAULT 10,
    autoPlay INTEGER DEFAULT 1,
    showExample INTEGER DEFAULT 1,
    vibrationEnabled INTEGER DEFAULT 1,
    isDarkMode INTEGER DEFAULT 0,
    updatedDate TEXT
);

-- Sample Data
INSERT INTO categories (name, description, colorCode, icon, createdDate) VALUES
('Basic English', 'Từ vựng tiếng Anh cơ bản', '#ffc107', 'book', datetime('now')),
('IELTS Vocabulary', 'Từ vựng luyện thi IELTS', '#17a2b8', 'trophy', datetime('now')),
('Grammar', 'Ngữ pháp tiếng Anh', '#6610f2', 'bookmark', datetime('now')),
('Daily Conversations', 'Giao tiếp hàng ngày', '#fd7e14', 'message-circle', datetime('now'));
```

## 🎯 Action Items

### Immediate (Phase 1)
1. ✅ Thêm Categories support
2. ✅ Cập nhật Deck model với categoryID
3. ✅ Enhance Flashcard với phonetic, cardType, wordType
4. ✅ Cập nhật Database Helper

### Near Future (Phase 2)  
1. ⏳ Quiz system implementation
2. ⏳ SRS Algorithm cho spaced repetition
3. ⏳ Achievement system
4. ⏳ Statistics và Progress tracking

### Long Term (Phase 3)
1. 🔮 User accounts và cloud sync
2. 🔮 Public deck sharing
3. 🔮 Rating system
4. 🔮 Advanced analytics

## 💡 Recommendation

**Nên cập nhật Project theo hướng README** vì:
- Design trong README rất comprehensive và professional
- Có đầy đủ tính năng cho một app học tập hiện đại
- Architecture scalable và maintainable
- UX/UI sẽ rich hơn nhiều

Tuy nhiên, có thể implement theo phases để không overwhelming.