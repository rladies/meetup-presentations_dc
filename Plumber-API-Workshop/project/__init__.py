###########
##imports##
###########
from flask import Flask

##########
##config##
##########

app = Flask(__name__)
from . import views
