ALTER TABLE `auth` RENAME TO `passwords`;--> statement-breakpoint
PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_passwords` (
	`userId` blob PRIMARY KEY NOT NULL,
	`password` blob NOT NULL,
	`salt` blob NOT NULL,
	`N` integer NOT NULL,
	`r` integer NOT NULL,
	`p` integer NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_passwords`("userId", "password", "salt", "N", "r", "p") SELECT "userId", "password", "salt", "N", "r", "p" FROM `passwords`;--> statement-breakpoint
DROP TABLE `passwords`;--> statement-breakpoint
ALTER TABLE `__new_passwords` RENAME TO `passwords`;--> statement-breakpoint
PRAGMA foreign_keys=ON;