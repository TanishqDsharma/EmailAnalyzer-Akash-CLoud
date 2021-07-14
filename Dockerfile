FROM python:3.8

WORKDIR /EmailAnalyzer-Akash-Cloud
COPY . .

RUN pip install -r requirments.txt

ENTRYPOINT ["python"]

CMD ["EmailInspector-Web.py"] 
