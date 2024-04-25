from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer

chatbot = ChatBot("Sure, Not")

trainer = ChatterBotCorpusTrainer(chatbot)
trainer.train("chatterbot.corpus.english")
