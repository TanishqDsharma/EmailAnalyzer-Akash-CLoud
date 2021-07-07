FROM python:3.8

WORKDIR /EmailInspector
COPY . .

RUN pip install -r requirments.txt

ENTRYPOINT ["python"]

CMD ["EmailInspector-Web.py"] 
