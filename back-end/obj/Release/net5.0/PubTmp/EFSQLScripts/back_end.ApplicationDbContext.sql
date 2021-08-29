﻿IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210507000312_Initial')
BEGIN
    CREATE TABLE [Generos] (
        [Id] int NOT NULL IDENTITY,
        [Nombre] nvarchar(50) NOT NULL,
        CONSTRAINT [PK_Generos] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210507000312_Initial')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210507000312_Initial', N'5.0.9');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210527001812_Actores')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Generos]') AND [c].[name] = N'Nombre');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Generos] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [Generos] ALTER COLUMN [Nombre] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210527001812_Actores')
BEGIN
    CREATE TABLE [Actores] (
        [Id] int NOT NULL IDENTITY,
        [Nombre] nvarchar(200) NOT NULL,
        [Biografia] nvarchar(max) NULL,
        [FechaNacimiento] datetime2 NOT NULL,
        [Foto] nvarchar(max) NULL,
        CONSTRAINT [PK_Actores] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210527001812_Actores')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210527001812_Actores', N'5.0.9');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210605213748_Cines')
BEGIN
    CREATE TABLE [Cines] (
        [Id] int NOT NULL IDENTITY,
        [Nombre] nvarchar(75) NOT NULL,
        [ubicacion] geography NULL,
        CONSTRAINT [PK_Cines] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210605213748_Cines')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210605213748_Cines', N'5.0.9');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Generos]') AND [c].[name] = N'Nombre');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Generos] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [Generos] ALTER COLUMN [Nombre] nvarchar(50) NOT NULL;
    ALTER TABLE [Generos] ADD DEFAULT N'' FOR [Nombre];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE TABLE [Peliculas] (
        [Id] int NOT NULL IDENTITY,
        [Titulo] nvarchar(300) NOT NULL,
        [Resumen] nvarchar(max) NULL,
        [Trailer] nvarchar(max) NULL,
        [EnCines] bit NOT NULL,
        [FechaLanzamiento] datetime2 NOT NULL,
        [Poster] nvarchar(max) NULL,
        CONSTRAINT [PK_Peliculas] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE TABLE [PeliculasActores] (
        [PeliculaId] int NOT NULL,
        [ActorId] int NOT NULL,
        [Personaje] nvarchar(100) NULL,
        [Orden] int NOT NULL,
        CONSTRAINT [PK_PeliculasActores] PRIMARY KEY ([ActorId], [PeliculaId]),
        CONSTRAINT [FK_PeliculasActores_Actores_ActorId] FOREIGN KEY ([ActorId]) REFERENCES [Actores] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_PeliculasActores_Peliculas_PeliculaId] FOREIGN KEY ([PeliculaId]) REFERENCES [Peliculas] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE TABLE [PeliculasCines] (
        [PeliculaId] int NOT NULL,
        [CineId] int NOT NULL,
        CONSTRAINT [PK_PeliculasCines] PRIMARY KEY ([PeliculaId], [CineId]),
        CONSTRAINT [FK_PeliculasCines_Cines_CineId] FOREIGN KEY ([CineId]) REFERENCES [Cines] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_PeliculasCines_Peliculas_PeliculaId] FOREIGN KEY ([PeliculaId]) REFERENCES [Peliculas] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE TABLE [PeliculasGeneros] (
        [PeliculaId] int NOT NULL,
        [GeneroId] int NOT NULL,
        CONSTRAINT [PK_PeliculasGeneros] PRIMARY KEY ([PeliculaId], [GeneroId]),
        CONSTRAINT [FK_PeliculasGeneros_Generos_GeneroId] FOREIGN KEY ([GeneroId]) REFERENCES [Generos] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_PeliculasGeneros_Peliculas_PeliculaId] FOREIGN KEY ([PeliculaId]) REFERENCES [Peliculas] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE INDEX [IX_PeliculasActores_PeliculaId] ON [PeliculasActores] ([PeliculaId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE INDEX [IX_PeliculasCines_CineId] ON [PeliculasCines] ([CineId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    CREATE INDEX [IX_PeliculasGeneros_GeneroId] ON [PeliculasGeneros] ([GeneroId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210610014859_Peliculas')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210610014859_Peliculas', N'5.0.9');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetRoles] (
        [Id] nvarchar(450) NOT NULL,
        [Name] nvarchar(256) NULL,
        [NormalizedName] nvarchar(256) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetUsers] (
        [Id] nvarchar(450) NOT NULL,
        [UserName] nvarchar(256) NULL,
        [NormalizedUserName] nvarchar(256) NULL,
        [Email] nvarchar(256) NULL,
        [NormalizedEmail] nvarchar(256) NULL,
        [EmailConfirmed] bit NOT NULL,
        [PasswordHash] nvarchar(max) NULL,
        [SecurityStamp] nvarchar(max) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        [PhoneNumber] nvarchar(max) NULL,
        [PhoneNumberConfirmed] bit NOT NULL,
        [TwoFactorEnabled] bit NOT NULL,
        [LockoutEnd] datetimeoffset NULL,
        [LockoutEnabled] bit NOT NULL,
        [AccessFailedCount] int NOT NULL,
        CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetRoleClaims] (
        [Id] int NOT NULL IDENTITY,
        [RoleId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetUserClaims] (
        [Id] int NOT NULL IDENTITY,
        [UserId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetUserLogins] (
        [LoginProvider] nvarchar(450) NOT NULL,
        [ProviderKey] nvarchar(450) NOT NULL,
        [ProviderDisplayName] nvarchar(max) NULL,
        [UserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetUserRoles] (
        [UserId] nvarchar(450) NOT NULL,
        [RoleId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE TABLE [AspNetUserTokens] (
        [UserId] nvarchar(450) NOT NULL,
        [LoginProvider] nvarchar(450) NOT NULL,
        [Name] nvarchar(450) NOT NULL,
        [Value] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210811010500_SistemaDeUsuarios')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210811010500_SistemaDeUsuarios', N'5.0.9');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210817000717_Ratings')
BEGIN
    CREATE TABLE [Ratings] (
        [Id] int NOT NULL IDENTITY,
        [Puntuacion] int NOT NULL,
        [PeliculaId] int NOT NULL,
        [UsuarioId] nvarchar(450) NULL,
        CONSTRAINT [PK_Ratings] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Ratings_AspNetUsers_UsuarioId] FOREIGN KEY ([UsuarioId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Ratings_Peliculas_PeliculaId] FOREIGN KEY ([PeliculaId]) REFERENCES [Peliculas] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210817000717_Ratings')
BEGIN
    CREATE INDEX [IX_Ratings_PeliculaId] ON [Ratings] ([PeliculaId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210817000717_Ratings')
BEGIN
    CREATE INDEX [IX_Ratings_UsuarioId] ON [Ratings] ([UsuarioId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210817000717_Ratings')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210817000717_Ratings', N'5.0.9');
END;
GO

COMMIT;
GO

