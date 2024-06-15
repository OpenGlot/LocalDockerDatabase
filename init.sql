CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;


DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Languages" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Name" text NOT NULL,
        CONSTRAINT "PK_Languages" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Courses" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Name" text NOT NULL,
        "DifficultyLevel" text NOT NULL,
        "LanguageId" integer,
        CONSTRAINT "PK_Courses" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Courses_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Modules" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Name" text NOT NULL,
        "Rank" integer NOT NULL,
        "CourseId" integer,
        CONSTRAINT "PK_Modules" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Modules_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Lessons" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Name" text NOT NULL,
        "LanguageId" integer NOT NULL,
        "DifficultyLevel" text NOT NULL,
        "Level" text NOT NULL,
        "ModuleId" integer,
        CONSTRAINT "PK_Lessons" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Lessons_Modules_ModuleId" FOREIGN KEY ("ModuleId") REFERENCES "Modules" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Questions" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Content" text NOT NULL,
        "QuestionType" integer NOT NULL,
        "LessonId" integer,
        CONSTRAINT "PK_Questions" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Questions_Lessons_LessonId" FOREIGN KEY ("LessonId") REFERENCES "Lessons" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Answers" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "CorrectAnswers" text[] NOT NULL,
        "QuestionId" integer,
        CONSTRAINT "PK_Answers" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Answers_Questions_QuestionId" FOREIGN KEY ("QuestionId") REFERENCES "Questions" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE TABLE "Options" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Text" text NOT NULL,
        "ImageUrl" text NOT NULL,
        "AudioUrl" text NOT NULL,
        "QuestionId" integer,
        CONSTRAINT "PK_Options" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Options_Questions_QuestionId" FOREIGN KEY ("QuestionId") REFERENCES "Questions" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE INDEX "IX_Answers_QuestionId" ON "Answers" ("QuestionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE INDEX "IX_Courses_LanguageId" ON "Courses" ("LanguageId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE INDEX "IX_Lessons_ModuleId" ON "Lessons" ("ModuleId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE INDEX "IX_Modules_CourseId" ON "Modules" ("CourseId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE INDEX "IX_Options_QuestionId" ON "Options" ("QuestionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    CREATE INDEX "IX_Questions_LessonId" ON "Questions" ("LessonId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240609195909_InitialCreate') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240609195909_InitialCreate', '8.0.6');
    END IF;
END $EF$;
COMMIT;
