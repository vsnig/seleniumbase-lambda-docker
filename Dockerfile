#  build:
#     docker build -t sblambdadocker --platform linux/amd64 .
#  run:
#     docker run --platform linux/amd64 -it --rm --entrypoint /var/lang/bin/python sblambdadocker app.py

FROM ghcr.io/astral-sh/uv:0.8.3 AS uv
FROM public.ecr.aws/lambda/python:3.13 AS build

RUN dnf install -y unzip && \
    curl -Lo "/tmp/chrome-linux64.zip" "https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.168/linux64/chrome-linux64.zip" && \
    unzip /tmp/chrome-linux64.zip -d /opt/

RUN --mount=from=uv,source=/uv,target=/bin/uv \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv export --frozen --no-emit-workspace --no-dev --no-editable -o requirements.txt && \
    uv pip install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

# patch seleniumbase
RUN dnf install -y perl
# - change downloaded_files path to be in /tmp - https://discord.com/channels/727927627830001734/1278793301482536990/1342920682773676081
RUN perl -i -pe's/downloaded_files/\/tmp\/asdf/g' seleniumbase/fixtures/constants.py
# patch.. - https://discord.com/channels/727927627830001734/1278793301482536990/1342920682773676081
RUN perl -i -pe's/await asyncio.sleep\(0\.25\)/await asyncio.sleep\(2\.5\)/g' seleniumbase/undetected/cdp_driver/browser.py

FROM public.ecr.aws/lambda/python:3.13

RUN dnf install -y atk cups-libs gtk3 libXcomposite alsa-lib \
    libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
    libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
    xorg-x11-xauth dbus-glib dbus-glib-devel nss mesa-libgbm

COPY --from=build /opt/chrome-linux64 /opt/chrome
ENV PATH="/opt/chrome/:${PATH}"
COPY --from=build ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}

COPY ./app.py ${LAMBDA_TASK_ROOT}/

ENV PYTHONPATH=/tmp/python:/var/task
# ENV DISPLAY=:99
# ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
