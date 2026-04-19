CREATE TABLE Users (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Notifications (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Notification_Settings (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    notification_type VARCHAR(255) NOT NULL,
    notification_frequency VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Notification_History (
    id INT PRIMARY KEY,
    notification_id INT NOT NULL,
    user_id INT NOT NULL,
    read_at TIMESTAMP,
    FOREIGN KEY (notification_id) REFERENCES Notifications(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

INSERT INTO Users (id, username, email) VALUES
(1, 'user1', 'user1@example.com'),
(2, 'user2', 'user2@example.com'),
(3, 'user3', 'user3@example.com');

INSERT INTO Notifications (id, user_id, message) VALUES
(1, 1, 'New message from user2'),
(2, 2, 'New message from user1'),
(3, 3, 'New message from user1');

INSERT INTO Notification_Settings (id, user_id, notification_type, notification_frequency) VALUES
(1, 1, 'email', 'daily'),
(2, 2, 'sms', 'weekly'),
(3, 3, 'push', 'monthly');

INSERT INTO Notification_History (id, notification_id, user_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

CREATE VIEW UnreadNotifications AS
SELECT n.id, n.message, u.username
FROM Notifications n
JOIN Users u ON n.user_id = u.id
LEFT JOIN Notification_History nh ON n.id = nh.notification_id AND u.id = nh.user_id
WHERE nh.read_at IS NULL;

CREATE PROCEDURE SendNotification()
BEGIN
    INSERT INTO Notifications (user_id, message)
    SELECT user_id, 'New message from ' || (SELECT username FROM Users WHERE id = 1)
    FROM Users
    WHERE id != 1;
END;

CREATE TRIGGER NotificationTrigger
AFTER INSERT ON Notifications
FOR EACH ROW
BEGIN
    INSERT INTO Notification_History (notification_id, user_id)
    VALUES (NEW.id, NEW.user_id);
END;

SELECT * FROM UnreadNotifications;
CALL SendNotification();
SELECT * FROM Notifications;