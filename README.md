Build:
`docker build -t sblambdadocker --platform linux/amd64 .`
Run:
`docker run --platform linux/amd64 -it --rm --entrypoint /var/lang/bin/python sblambdadocker app.py`
