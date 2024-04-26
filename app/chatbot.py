from chatterbot import ChatBot

chatbot = ChatBot(
    "Sure, Not",
    logic_adapters=[
        'chatterbot.logic.BestMatch',
        'chatterbot.logic.MathematicalEvaluation',
        'chatterbot.logic.TimeLogicAdapter'
    ],
    read_only=True
)
