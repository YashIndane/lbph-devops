from flask import Flask, render_template, request
from base64 import b64decode
from PIL import Image, ImageFile
from io import BytesIO
import cv2

app = Flask("face-detection")

face_classifier=cv2.CascadeClassifier("haarcascade_frontalface_default.xml")

@app.route("/home")
def home():
  return render_template("face.html")

@app.route("/process", methods = ["GET"])
def process_uri():

  ImageFile.LOAD_TRUNCATED_IMAGES = True
  uri_string = request.args.get("duri")
  uri_string = uri_string[uri_string.index(",")+1:]
  image = Image.open(BytesIO(b64decode(uri_string))) 
  image.save("face.png", "PNG") 
  
  image = cv2.imread("face.png")
  gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
  faces = face_classifier.detectMultiScale(gray, 1.3, 5)

  if faces is ():
    return "No face found"

  for (x, y, w, h) in faces:
    
    face = image[y:y+h, x:x+w]
    face = cv2.resize(face, (200, 200))
    face=cv2.cvtColor(face, cv2.COLOR_BGR2GRAY)
    #below line is dummy just a reference to insert other lines
    print()

    else:
        return "I dont know U"

app.run(host = "0.0.0.0", port=55)
