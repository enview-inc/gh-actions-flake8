FROM python:3.8-alpine

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Flake8 with GitHub Actions"
LABEL org.opencontainers.image.description="Flake8 with GitHub Actions -- including annotations for Pull Requests"

COPY LICENSE \
        README.md \
        entrypoint.sh \
        flake8-matcher.json \
        requirements.txt \
        /code/

RUN pip install -r /code/requirements.txt

ENTRYPOINT ["/code/entrypoint.sh"]
CMD []
