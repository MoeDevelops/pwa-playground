CREATE TABLE `auth` (
	`userId` blob PRIMARY KEY NOT NULL,
	`password` blob NOT NULL,
	`salt` blob NOT NULL,
	`N` integer NOT NULL,
	`r` integer NOT NULL,
	`p` integer NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `chats` (
	`id` blob PRIMARY KEY NOT NULL,
	`user1` blob NOT NULL,
	`user2` blob NOT NULL,
	FOREIGN KEY (`user1`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`user2`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `messages` (
	`id` blob PRIMARY KEY NOT NULL,
	`chat` blob NOT NULL,
	`author` blob NOT NULL,
	`content` text NOT NULL,
	FOREIGN KEY (`chat`) REFERENCES `chats`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`author`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `tokens` (
	`id` blob PRIMARY KEY NOT NULL,
	`userId` blob NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` blob PRIMARY KEY NOT NULL,
	`username` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_username_unique` ON `users` (`username`);