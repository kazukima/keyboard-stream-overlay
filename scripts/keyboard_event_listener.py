from pynput import keyboard
import socket

def on_press(key):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            key = str(key).replace('', "").upper()
            key = stringify(key)
            print(key)
            if key == "":
                return
            sock.sendto(key.encode(), ('127.0.0.1', 12345))
    except Exception as e:
        print(f"Error: {e}")


def stringify(key):
    if len(key) > 4:
        return key.split(".")[1]
    if "\\" in key:
        return ""
    return key

listener = keyboard.Listener(on_press=on_press)
listener.start()
listener.join()
listener.join()