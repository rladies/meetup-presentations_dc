# views.py

from . import app
import requests
from flask import render_template


@app.route('/')
def getImg():
    r = requests.get('https://rserver-10-0-3-147-59ea236c2b44739a7f87bc4b.stackspace.space:8000/iris_plot', data={'colors': 'TRUE'}, verify=False)
    #img = Image.open(io.BytesIO(r.content))
    output = open("project/static/img01.png","wb")
    output.write(r.content)
    output.close()
    return render_template('index.html')



@app.route('/htmlex')
def html():
    html = requests.get('https://rserver-10-0-3-147-59ea236c2b44739a7f87bc4b.stackspace.space:8000/htmlex', verify=False)
    return html.content
