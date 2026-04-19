import threading
import time
import random

class NotificationSystem:
    def __init__(self):
        self.notifications = []

    def add_notification(self, notification):
        self.notifications.append(notification)

    def remove_notification(self, notification):
        self.notifications.remove(notification)

    def get_notifications(self):
        return self.notifications

class RealTimeNotificationSystem(NotificationSystem):
    def __init__(self):
        super().__init__()
        self.lock = threading.Lock()

    def monitor_notifications(self):
        while True:
            with self.lock:
                for notification in self.get_notifications():
                    print(notification)
            time.sleep(1)

    def start_monitoring(self):
        thread = threading.Thread(target=self.monitor_notifications)
        thread.daemon = True
        thread.start()

def generate_random_notification():
    notifications = ["New message", "New email", "New notification"]
    return random.choice(notifications)

def main():
    system = RealTimeNotificationSystem()
    system.start_monitoring()

    for _ in range(10):
        notification = generate_random_notification()
        system.add_notification(notification)
        print(f"Added notification: {notification}")
        time.sleep(1)

    for _ in range(10):
        notification = system.get_notifications()[0]
        system.remove_notification(notification)
        print(f"Removed notification: {notification}")
        time.sleep(1)

if __name__ == "__main__":
    main()