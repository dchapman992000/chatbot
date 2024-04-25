from chatterbot import ChatBot
from chatbot import chatbot
from flask import Flask, render_template, request

app = Flask(__name__)
app.static_folder = 'static'

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/get")
def get_bot_response():
    userText = request.args.get('msg')
    return str(chatbot.get_response(userText))

if __name__ == "__main__":
#    from waitress import serve
#    serve(app, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
    app.run(debug=False, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))