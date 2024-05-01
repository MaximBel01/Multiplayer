FROM ubuntu:latest
LABEL authors="MaximBel01"
ENV GODOT_VERSION:"4.2.1"
ENV GODOT_EXPORT_PRESET:"LINUX/X11"
ENV GODOT_GAME_NAME:"Multiplayer"
ENV HTTPS_GIT_REPO:"https://github.com/MaximBel01/Multiplayer"
RUN apk update
RUN apk add --no-cache bash
RUN apk add --no-cache wget
RUN apk add --no-cache git
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz\
    && mkdir ~/.cache\
    && mkdir -p /.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && mv Godot v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && rm -f Godot v${GODOT_VERSION}-stable_export_templates.tpz Godot v${GODOT_VERSION}-stable_linux_headless.64.zip
RUN mkdir /godot_app
RUN mkdir /godotbuidspace
WORKDIR /godotbuidspace
RUN git clone -b Linux ${HTTPS_GIT_REPO}
RUN godot --path /godotbuidspace --export-pack ${GODOT_EXPORT_PRESET} Linux.pck
RUN mv Linux.pck /godot_app
WORKDIR /godot_app
RUN rm -f -R /godotbuidspace
CMD godot --main-pack Linux.pck
ENTRYPOINT ["top", "-b"]