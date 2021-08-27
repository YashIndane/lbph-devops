declare -a dirs
i=1
for d in */
do
    dirs[i++]="${d%/}"
done
for((i=1;i<=${#dirs[@]};i++))
do 

if [ ${dirs[i]} != "templates" ]
then 

echo "data_path = './${dirs[i]}/'
onlyfiles = [f for f in listdir(data_path) if isfile(join(data_path, f))]
Training_Data, Labels = [], []
for i, files in enumerate(onlyfiles):
    image_path = data_path + onlyfiles[i]
    images = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    Training_Data.append(np.asarray(images, dtype=np.uint8))
    Labels.append(i)
Labels = np.asarray(Labels, dtype=np.int32)
model  = cv2.face_LBPHFaceRecognizer.create()
model.train(np.asarray(Training_Data), np.asarray(Labels))
model.save('${dirs[i]}.xml')
print('${dirs[i]} model saved')" >> training_model_template.py

sed -i "/^face_classifier=.*/a  ${dirs[i]}=cv2.face.LBPHFaceRecognizer_create()\n${dirs[i]}.read('${dirs[i]}.xml')" app_template.py
sed -i "/^    print().*/a \    results_${dirs[i]}=${dirs[i]}.predict(face)\n    confidence_${dirs[i]}=int(100*(1-(results_${dirs[i]}[1])/400))" app_template.py

if [ $i -eq 1 ]
then 
    sed -i "/^    else:.*/i \    if confidence_${dirs[i]} > 83:\n      return 'Hey ${dirs[i]}'" app_template.py
else
    sed -i "/^    else:.*/i \    elif confidence_${dirs[i]} > 83:\n      return 'Hey ${dirs[i]}'" app_template.py
fi

fi

done

sudo python3 training_model_template.py

random_no=$RANDOM

sudo docker build -t yashindane/lbphrecog:$random_no .
sudo docker push yashindane/lbphrecog:$random_no

sudo aws eks update-kubeconfig --region ap-south-1 --name face-app

sudo /usr/local/bin/kubectl set image deployment face-app-deployment lbphrecog=yashindane/lbphrecog:$random_no 

sudo sleep 15
sudo /usr/local/bin/kubectl get svc
