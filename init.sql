﻿CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

CREATE TABLE "Images" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "UrlKey" text NOT NULL,
    "Description" text NOT NULL,
    "UploadedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Images" PRIMARY KEY ("Id")
);

CREATE TABLE "InteractiveStorybooks" (
    "StorybookId" integer GENERATED BY DEFAULT AS IDENTITY,
    "Title" text NOT NULL,
    "Content" text NOT NULL,
    "Language" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_InteractiveStorybooks" PRIMARY KEY ("StorybookId")
);

CREATE TABLE "Languages" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    CONSTRAINT "PK_Languages" PRIMARY KEY ("Id")
);

CREATE TABLE "Roles" (
    "RoleId" integer GENERATED BY DEFAULT AS IDENTITY,
    "RoleName" text NOT NULL,
    CONSTRAINT "PK_Roles" PRIMARY KEY ("RoleId")
);

CREATE TABLE "UserProfiles" (
    "UserId" text NOT NULL,
    "Username" text NOT NULL,
    "Email" text NOT NULL,
    "NativeLanguage" text NOT NULL,
    "TargetLanguage" text NOT NULL,
    "TargetLanguageLevel" text NOT NULL,
    "TargetLanguage2" text,
    "TargetLanguageLevel2" text,
    "TargetLanguage3" text,
    "TargetLanguageLevel3" text,
    "DateOfBirth" timestamp with time zone NOT NULL,
    "TimeZone" text NOT NULL,
    CONSTRAINT "PK_UserProfiles" PRIMARY KEY ("UserId")
);

CREATE TABLE "StoryChoices" (
    "ChoiceId" integer GENERATED BY DEFAULT AS IDENTITY,
    "StorybookId" integer NOT NULL,
    "ChoiceText" text NOT NULL,
    "Outcome" text NOT NULL,
    CONSTRAINT "PK_StoryChoices" PRIMARY KEY ("ChoiceId"),
    CONSTRAINT "FK_StoryChoices_InteractiveStorybooks_StorybookId" FOREIGN KEY ("StorybookId") REFERENCES "InteractiveStorybooks" ("StorybookId") ON DELETE CASCADE
);

CREATE TABLE "Audios" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "UrlKey" text NOT NULL,
    "Transcript" text NOT NULL,
    "EnglishTranslation" text NOT NULL,
    "LanguageId" integer NOT NULL,
    "UploadedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Audios" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Audios_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Courses" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "Title" text NOT NULL,
    "LanguageId" integer NOT NULL,
    CONSTRAINT "PK_Courses" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Courses_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Badges" (
    "BadgeId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "BadgeName" text NOT NULL,
    "AwardedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Badges" PRIMARY KEY ("BadgeId"),
    CONSTRAINT "FK_Badges_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Flashcards" (
    "FlashcardId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "Front" text NOT NULL,
    "Back" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Flashcards" PRIMARY KEY ("FlashcardId"),
    CONSTRAINT "FK_Flashcards_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Notifications" (
    "NotificationId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "Message" text NOT NULL,
    "SentAt" timestamp with time zone NOT NULL,
    "IsRead" boolean NOT NULL,
    CONSTRAINT "PK_Notifications" PRIMARY KEY ("NotificationId"),
    CONSTRAINT "FK_Notifications_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Subscriptions" (
    "SubscriptionId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "PlanName" integer NOT NULL,
    "StartDate" timestamp with time zone NOT NULL,
    "EndDate" timestamp with time zone NOT NULL,
    "IsActive" boolean NOT NULL,
    CONSTRAINT "PK_Subscriptions" PRIMARY KEY ("SubscriptionId"),
    CONSTRAINT "FK_Subscriptions_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserGeneratedContents" (
    "ContentId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "Title" text NOT NULL,
    "ContentType" integer NOT NULL,
    "Content" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_UserGeneratedContents" PRIMARY KEY ("ContentId"),
    CONSTRAINT "FK_UserGeneratedContents_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserRoles" (
    "UserRoleId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "RoleId" integer NOT NULL,
    CONSTRAINT "PK_UserRoles" PRIMARY KEY ("UserRoleId"),
    CONSTRAINT "FK_UserRoles_Roles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "Roles" ("RoleId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserRoles_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Modules" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "Title" text NOT NULL,
    "CourseId" integer NOT NULL,
    CONSTRAINT "PK_Modules" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Modules_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Lessons" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "Title" text NOT NULL,
    "ContentType" integer NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    "ModuleId" integer NOT NULL,
    CONSTRAINT "PK_Lessons" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Lessons_Modules_ModuleId" FOREIGN KEY ("ModuleId") REFERENCES "Modules" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Progresses" (
    "ProgressId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "CourseId" integer,
    "ModuleId" integer,
    "CompletionPercentage" integer NOT NULL,
    "LastUpdated" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Progresses" PRIMARY KEY ("ProgressId"),
    CONSTRAINT "FK_Progresses_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id"),
    CONSTRAINT "FK_Progresses_Modules_ModuleId" FOREIGN KEY ("ModuleId") REFERENCES "Modules" ("Id"),
    CONSTRAINT "FK_Progresses_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Questions" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "Text" text NOT NULL,
    "QuestionType" integer NOT NULL,
    "Answer" text NOT NULL,
    "LessonId" integer NOT NULL,
    "AudioId" integer,
    "ImageId" integer,
    CONSTRAINT "PK_Questions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Questions_Audios_AudioId" FOREIGN KEY ("AudioId") REFERENCES "Audios" ("Id"),
    CONSTRAINT "FK_Questions_Images_ImageId" FOREIGN KEY ("ImageId") REFERENCES "Images" ("Id"),
    CONSTRAINT "FK_Questions_Lessons_LessonId" FOREIGN KEY ("LessonId") REFERENCES "Lessons" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Ratings" (
    "RatingId" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "ContentType" integer NOT NULL,
    "ContentId" integer NOT NULL,
    "IsThumbsUp" boolean NOT NULL,
    "RatedAt" timestamp with time zone NOT NULL,
    "LessonId" integer NOT NULL,
    "ModuleId" integer,
    CONSTRAINT "PK_Ratings" PRIMARY KEY ("RatingId"),
    CONSTRAINT "FK_Ratings_Lessons_ContentId" FOREIGN KEY ("ContentId") REFERENCES "Lessons" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_Ratings_Modules_ModuleId" FOREIGN KEY ("ModuleId") REFERENCES "Modules" ("Id"),
    CONSTRAINT "FK_Ratings_UserProfiles_UserId" FOREIGN KEY ("UserId") REFERENCES "UserProfiles" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Options" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "Text" text NOT NULL,
    "AudioId" integer,
    "ImageId" integer,
    "QuestionId" integer NOT NULL,
    CONSTRAINT "PK_Options" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Options_Audios_AudioId" FOREIGN KEY ("AudioId") REFERENCES "Audios" ("Id"),
    CONSTRAINT "FK_Options_Images_ImageId" FOREIGN KEY ("ImageId") REFERENCES "Images" ("Id"),
    CONSTRAINT "FK_Options_Questions_QuestionId" FOREIGN KEY ("QuestionId") REFERENCES "Questions" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_Audios_LanguageId" ON "Audios" ("LanguageId");

CREATE INDEX "IX_Badges_UserId" ON "Badges" ("UserId");

CREATE INDEX "IX_Courses_LanguageId" ON "Courses" ("LanguageId");

CREATE INDEX "IX_Flashcards_UserId" ON "Flashcards" ("UserId");

CREATE INDEX "IX_Lessons_ModuleId" ON "Lessons" ("ModuleId");

CREATE INDEX "IX_Modules_CourseId" ON "Modules" ("CourseId");

CREATE INDEX "IX_Notifications_UserId" ON "Notifications" ("UserId");

CREATE INDEX "IX_Options_AudioId" ON "Options" ("AudioId");

CREATE INDEX "IX_Options_ImageId" ON "Options" ("ImageId");

CREATE INDEX "IX_Options_QuestionId" ON "Options" ("QuestionId");

CREATE INDEX "IX_Progresses_CourseId" ON "Progresses" ("CourseId");

CREATE INDEX "IX_Progresses_ModuleId" ON "Progresses" ("ModuleId");

CREATE INDEX "IX_Progresses_UserId" ON "Progresses" ("UserId");

CREATE INDEX "IX_Questions_AudioId" ON "Questions" ("AudioId");

CREATE INDEX "IX_Questions_ImageId" ON "Questions" ("ImageId");

CREATE INDEX "IX_Questions_LessonId" ON "Questions" ("LessonId");

CREATE INDEX "IX_Ratings_ContentId" ON "Ratings" ("ContentId");

CREATE INDEX "IX_Ratings_ModuleId" ON "Ratings" ("ModuleId");

CREATE INDEX "IX_Ratings_UserId" ON "Ratings" ("UserId");

CREATE INDEX "IX_StoryChoices_StorybookId" ON "StoryChoices" ("StorybookId");

CREATE UNIQUE INDEX "IX_Subscriptions_UserId" ON "Subscriptions" ("UserId");

CREATE INDEX "IX_UserGeneratedContents_UserId" ON "UserGeneratedContents" ("UserId");

CREATE INDEX "IX_UserRoles_RoleId" ON "UserRoles" ("RoleId");

CREATE INDEX "IX_UserRoles_UserId" ON "UserRoles" ("UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20240617034340_InitialCreate', '8.0.6');

COMMIT;

-- Seed Data

-- Seed data for UserProfiles
INSERT INTO "UserProfiles" ("UserId", "Username", "Email", "NativeLanguage", "TargetLanguage", "TargetLanguageLevel", "TargetLanguage2", "TargetLanguageLevel2", "TargetLanguage3", "TargetLanguageLevel3", "DateOfBirth", "TimeZone")
VALUES
('1', 'user1', 'user1@example.com', 'English', 'Spanish', 'Intermediate', 'Chinese', 'Beginner', 'French', 'Advanced', '1990-01-01 00:00:00+00', 'UTC'),
('2', 'user2', 'user2@example.com', 'Chinese', 'English', 'Advanced', 'Japanese', 'Intermediate', NULL, NULL, '1985-05-15 00:00:00+00', 'UTC+8'),
('3', 'user3', 'user3@example.com', 'Spanish', 'Portuguese', 'Intermediate', 'English', 'Advanced', 'German', 'Beginner', '1992-08-20 00:00:00+00', 'UTC-5'),
('4', 'user4', 'user4@example.com', 'French', 'Russian', 'Beginner', 'Arabic', 'Intermediate', 'Japanese', 'Beginner', '1988-12-30 00:00:00+00', 'UTC+1');

-- Seed data for Languages
INSERT INTO "Languages" ("Name", "Description")
VALUES
('Chinese', 'Spoken in China, Taiwan, Singapore. Useful for business and cultural understanding.'),
('Spanish', 'Spoken in Spain, Latin America. Useful for travel and communication in Spanish-speaking countries.'),
('English', 'Spoken worldwide. Essential for international business and travel.'),
('Arabic', 'Spoken in the Middle East and North Africa. Important for business and cultural studies.'),
('Hindi', 'Spoken in India. Useful for business and cultural exchange in South Asia.'),
('Portuguese', 'Spoken in Portugal, Brazil, and some African countries. Useful for travel and business in these regions.'),
('Russian', 'Spoken in Russia and former Soviet states. Important for business and diplomatic relations.'),
('Japanese', 'Spoken in Japan. Useful for business, travel, and cultural understanding.'),
('Korean', 'Spoken in South Korea. Important for business and cultural understanding.'),
('French', 'Spoken in France, Canada, and many African countries. Useful for travel, business, and diplomatic relations.');

-- Seed data for Courses
INSERT INTO "Courses" ("Title", "LanguageId")
VALUES
('Beginner Chinese', 1),
('Beginner Spanish', 2),
('Beginner English', 3),
('Beginner Arabic', 4),
('Beginner Hindi', 5),
('Beginner Portuguese', 6),
('Beginner Russian', 7),
('Beginner Japanese', 8),
('Beginner Korean', 9),
('Beginner French', 10);

-- Seed data for Modules
INSERT INTO "Modules" ("Title", "CourseId")
VALUES
('Chinese Basics', 1),
('Spanish Basics', 2),
('English Basics', 3),
('Arabic Basics', 4),
('Hindi Basics', 5),
('Portuguese Basics', 6),
('Russian Basics', 7),
('Japanese Basics', 8),
('Korean Basics', 9),
('French Basics', 10);

-- Seed data for Lessons
INSERT INTO "Lessons" ("Title", "ContentType", "CreatedAt", "ModuleId")
VALUES
('Introduction to Chinese', 1, '2024-06-16 00:00:00+00', 1),
('Introduction to Spanish', 1, '2024-06-16 00:00:00+00', 2),
('Introduction to English', 1, '2024-06-16 00:00:00+00', 3),
('Introduction to Arabic', 1, '2024-06-16 00:00:00+00', 4),
('Introduction to Hindi', 1, '2024-06-16 00:00:00+00', 5),
('Introduction to Portuguese', 1, '2024-06-16 00:00:00+00', 6),
('Introduction to Russian', 1, '2024-06-16 00:00:00+00', 7),
('Introduction to Japanese', 1, '2024-06-16 00:00:00+00', 8),
('Introduction to Korean', 1, '2024-06-16 00:00:00+00', 9),
('Introduction to French', 1, '2024-06-16 00:00:00+00', 10);
