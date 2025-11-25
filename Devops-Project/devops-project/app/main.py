import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    # Leemos una variable de entorno con un valor por defecto
    message = os.getenv("APP_MESSAGE", "Hola desde Flask en Docker!")
    return message

if __name__ == "__main__":
    # host=0.0.0.0 es indispensable para Docker
    app.run(host="0.0.0.0", port=5000)
