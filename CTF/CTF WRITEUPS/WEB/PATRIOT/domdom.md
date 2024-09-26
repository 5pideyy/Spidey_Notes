### Challenge ###
DOMDOM
312
Medium
I love face-book and I love to share my photos with my friends.

http://chal.competitivecyber.club:9090

Author: Kiran Ghimire (sau_12)

### Solution ###

We are given the source code to this challenge:
```python
#!/usr/bin/env python

__author__ = "kiransau"
__title__ =  "DOMDOM"

import os
import json
import urllib
import random
import requests
from PIL import Image
from importlib.metadata import version
from PIL.ExifTags import TAGS
from flask import Flask, flash, request, redirect, url_for, render_template
from werkzeug.utils import secure_filename
from lxml import etree

UPLOAD_FOLDER = '/app/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg'}

app = Flask(__name__,
            static_url_path='/static', 
            template_folder='templates')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    filename = ''
    if request.method == 'POST':
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename) + str(random.randrange(10000, 90000))
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

    return render_template('upload.html', filename=filename)

@app.route('/check', methods=['POST', 'GET'])
def check():
    r = requests.Session()
    allow_ip = request.headers['Host']
    if request.method == 'POST':
        url = request.form['url']
        url_parsed = urllib.parse.urlparse(url).netloc 
        if allow_ip == url_parsed:
            get_content = r.get(url = url)
        else:
            return "Cannot request for that url"
        try:
            parsed_json = json.loads(get_content.content.decode())["Comment"]
            parser = etree.XMLParser(no_network=False, resolve_entities=True)
            get_doc = etree.fromstring(str(parsed_json), parser)
            print(get_doc, "ho")
            result = etree.tostring(get_doc)
        except:
            return "Something wrong!!"
        if result: return result
        else: return "Empty head"
    else:
        return render_template('check.html') 

@app.route('/meta')
def meta():
    iname = request.args.get("image", type=str)
    try:
        name = UPLOAD_FOLDER + '/' + iname
        try:
            image = Image.open(name)
            image_dict = {
                   "Filename": image.filename,
                   "Image Size": image.size,
                   "Comment": image.info.get('Comment')
                   }
            return image_dict
        except FileNotFoundError:
            return "File not found."
    except:
        return render_template('meta.html')


if __name__ == '__main__':
    app.secret_key = "734df63066793dfe6f7e417d4d80f453"
    app.run(debug=False, host='0.0.0.0', port=9090)
```
We have a server which allows us to upload a image and then it parses the image.

We have 3 endpoints:
  / => Which allows us to upload the image.
  /meta => take a query parameter image and extracts the metadata of the image.
  /check => This takes a url as input and verify the url to the host header if the domain and the host are same or not and then if requests the content of the url.

The /check endpoint assumes that the data it will recieve will be in json and will have a Comment field and luckly /meta endpoint has both these properties.
And after filtering out the comment from the response it parses it as xml. This parsing is vulnerable to XXE attack.
We can add xxe payload in a image and upload it on to the server and then send the url of the image to /check and we will get the flag.
```xml
exiftool -Comment="<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe SYSTEM \"file:///etc/passwd\" >]><foo>&xxe;</foo>" image.png
```
This command will create a add the xxe payload in images comment field.
